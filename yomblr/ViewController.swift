//
//  ViewController.swift
//  yomblr
//
//  Created by Yoshiyuki Kawashima on 2017/06/21.
//  Copyright © 2017 ykws. All rights reserved.
//

import UIKit
import TMTumblrSDK
import SDWebImage
import MBProgressHUD
import ChameleonFramework

class ViewController: UITableViewController {
  
  // MARK: - Properties
  
  private let limit: Int = 20
  
  var user: User!
  var posts: [PhotoPost] = Array()
  var offset: Int = 0
  var ignoreLikes: Int = 0
  
  // MARK: - Actions

  @IBAction func dashboard(_ sender: Any) {
    TMTumblrAppClient.viewDashboard()
  }

  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setApplicationColor()
    
    refreshControl = UIRefreshControl()
    refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
    refreshControl?.addTarget(self, action: #selector(requestLikes), for: UIControlEvents.valueChanged)
    tableView.addSubview(refreshControl!)
    
    guard let oAuthToken = UserDefaults.standard.string(forKey: "OAuthToken"),
      let oAuthTokenSecret = UserDefaults.standard.string(forKey: "OAuthTokenSecret") else {
      requestAuthenticate()
      return
    }

    TMAPIClient.sharedInstance().oAuthToken = oAuthToken
    TMAPIClient.sharedInstance().oAuthTokenSecret = oAuthTokenSecret
    requestUserInfo()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    navigationController?.setNavigationBarHidden(true, animated: animated)
    super.viewWillAppear(animated)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    navigationController?.setNavigationBarHidden(false, animated: animated)
    super.viewWillDisappear(animated)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  // MARK: - TableView
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return posts.count
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return posts[section].photos.count
  }
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return section == 0 ? 0 : 20
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let screenWidth = UIScreen.main.bounds.size.width
    
    guard let altSize = posts[indexPath.section].photos[indexPath.row].altSizes.first else {
      return screenWidth
    }
    
    let scale = screenWidth / CGFloat(altSize.width)
    return CGFloat(altSize.height) * scale
  }
  
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = UIView()
    header.backgroundColor = UIColor.clear
    return header
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == (offset + limit - 1) {
      refreshView(withOffset: offset + limit)
    }
    
    let cell: CustomCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
    
    guard let url = posts[indexPath.section].photos[indexPath.row].altSizes.first?.url else {
      showMessage("Can't retrieve url.")
      return cell
    }
    
    cell.photo.sd_setShowActivityIndicatorView(true)
    cell.photo.sd_setIndicatorStyle(.gray)
    cell.photo.sd_setImage(with: URL(string: url), placeholderImage: nil)
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell: CustomCell = tableView.cellForRow(at: indexPath) as! CustomCell
    crop(postIndex: indexPath.section, photoIndex: indexPath.row, image: cell.photo.image!)
  }

  // MARK: - Tumblr

  func requestAuthenticate() {
    TMAPIClient.sharedInstance().authenticate("yomblr", from: self, callback: { error in
      if (error != nil) {
        self.showError(error!)
        return
      }

      guard let oAuthToken = TMAPIClient.sharedInstance().oAuthToken,
        let oAuthTokenSecret = TMAPIClient.sharedInstance().oAuthTokenSecret else {
          self.showMessage("Can't retrieve OAuthToken or OAuthTokenSecret")
          return
      }

      UserDefaults.standard.set(oAuthToken, forKey: "OAuthToken")
      UserDefaults.standard.set(oAuthTokenSecret, forKey: "OAuthTokenSecret")

      self.requestUserInfo()
    })
  }
  
  func requestUserInfo() {
    let hud = showProgress(withMessage: "Requesting user's information...")
    
    TMAPIClient.sharedInstance().userInfo({ response, error in
      self.hideProgress(hud: hud)
      
      if (error != nil) {
        self.showError(error!)
        return
      }
      
      do {
        self.user = try User.init(json: response!)
      } catch {
        self.showError(error)
        return
      }
      
      self.refreshView()
    })
  }

  func requestDashboard(withOffset offset: Int = 0) {
    let hud = showProgress(withMessage: "Requesting dashboard...")
    
    TMAPIClient.sharedInstance().dashboard(["offset": offset, "type": "photo"], callback: { response, error in
      self.hideProgress(hud: hud)
      
      if (error != nil) {
        self.showError(error!)
        return
      }

      do {
        let dashboard = try Dashboard.init(json: response!)
        self.updatePosts(posts: dashboard.posts, offset: self.offset)
      } catch {
        self.showError(error)
        return
      }
    })
  }
  
  func requestLikes(sender: AnyObject /*withOffset offset: Int = 0*/) {
    let hud = showProgress(withMessage: "Requesting likes...")
    
    TMAPIClient.sharedInstance().likes(user.blogs.first?.name, parameters: ["offset": offset], callback: { response, error in
      self.hideProgress(hud: hud)

      if (error != nil) {
        self.refreshControl?.endRefreshing()
        self.showError(error!)
        return
      }
      
      do {
        let likes = try Likes.init(json: response!)
        
        // Cancel displaying previous photo if no more previous likes photo
        if likes.likedPosts.count == 0 {
          self.refreshControl?.endRefreshing()
          self.showMessage("No more likes")
          return
        }
        
        self.updatePosts(posts: likes.likedPosts, offset: self.offset)
        self.ignoreLikes += likes.ignoreCount
        self.refreshControl?.endRefreshing()
      } catch {
        self.refreshControl?.endRefreshing()
        self.showError(error)
        return
      }
    })
  }
  
  // MARK: - View
  
  func refreshView(withOffset offset: Int = 0) {
    self.offset = offset == 0 ? offset : offset + ignoreLikes
    requestLikes(sender: refreshControl!)
  }
  
  func updatePosts(posts: [PhotoPost], offset: Int) {
    if offset == 0 {
      self.posts = posts
    } else {
      posts.forEach { post in
        self.posts.append(post)
      }
    }
    
    self.offset = offset == 0 ? offset : offset - ignoreLikes
    
    tableView.reloadData()
  }
  
  // MARK: - Controller
  
  func browse(postIndex: Int) {
    let webViewController: WebViewController = storyboard?.instantiateViewController(withIdentifier: "web") as! WebViewController
    initWebViewController(webViewController, postIndex: postIndex)
    navigationController?.pushViewController(webViewController, animated: true)
  }

  func crop(postIndex: Int, photoIndex: Int, image: UIImage) {
    let cropViewController: CropViewController = storyboard?.instantiateViewController(withIdentifier: "crop") as! CropViewController
    cropViewController.blogName = user.blogs.first?.name
    cropViewController.image = image
    cropViewController.postUrl = posts[postIndex].photos[photoIndex].altSizes.first?.url
    navigationController?.pushViewController(cropViewController, animated: true)
  }
  
  // MARK: - Initializer
  
  func initWebViewController(_ webViewController: WebViewController, postIndex: Int) {
    webViewController.blogName = user.blogs.first?.name
    
    let targetString = posts[postIndex].sourceUrl ?? posts[postIndex].postUrl
    if targetString.contains("%") {
      webViewController.urlString = targetString
      return
    }
    
    let encodedString = targetString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
    webViewController.urlString = encodedString
  }
}
