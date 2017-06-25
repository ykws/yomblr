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

class ViewController: UIViewController {
  
  // MARK: - Properties
  
  var user: User!
  var posts: [PhotoPost]!
  var postIndex: Int = 0
  var photoIndex: Int = 0
  var ignoreLikes: Int = 0
  
  // MARK: - Outlets

  @IBOutlet weak var photo: UIImageView!

  // MARK: - Actions

  @IBAction func dashboard(_ sender: Any) {
    TMTumblrAppClient.viewDashboard()
  }

  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(gesture:)))
    swipeRight.direction = UISwipeGestureRecognizerDirection.right
    view.addGestureRecognizer(swipeRight)
    
    let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(gesture:)))
    swipeLeft.direction = UISwipeGestureRecognizerDirection.left
    view.addGestureRecognizer(swipeLeft)
    
    let longPress = UILongPressGestureRecognizer(target: self, action: #selector(respondToLongPressGesture(gesture:)))
    view.addGestureRecognizer(longPress)
    
    guard let oAuthToken = UserDefaults.standard.string(forKey: "OAuthToken"),
      let oAuthTokenSecret = UserDefaults.standard.string(forKey: "OAuthTokenSecret") else {
      requestAuthenticate()
      return
    }

    TMAPIClient.sharedInstance().oAuthToken = oAuthToken
    TMAPIClient.sharedInstance().oAuthTokenSecret = oAuthTokenSecret
    requestUserInfo()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  // MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let cropViewController: CropViewController = segue.destination as? CropViewController {
      cropViewController.blogName = user.blogs.first?.name
      cropViewController.image = photo.image
      cropViewController.postUrl = posts[postIndex].photos[photoIndex].altSizes.first?.url
    }
  }

  // MARK: - Tumblr

  func requestAuthenticate() {
    let hud = showProgress(withMessage: "Requesting authenticate...")
    
    TMAPIClient.sharedInstance().authenticate("yomblr", from: self, callback: { error in
      self.hideProgress(hud: hud)
      
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
        self.updatePosts(posts: dashboard.posts, offset: offset)
      } catch {
        self.showError(error)
        return
      }
    })
  }
  
  func requestLikes(withOffset offset: Int = 0) {
    let hud = showProgress(withMessage: "Requesting likes...")
    
    TMAPIClient.sharedInstance().likes(user.blogs.first?.name, parameters: ["offset": offset], callback: { response, error in
      self.hideProgress(hud: hud)

      if (error != nil) {
        self.showError(error!)
        return
      }
      
      do {
        let likes = try Likes.init(json: response!)
        self.updatePosts(posts: likes.likedPosts, offset: offset)
        self.ignoreLikes += likes.ignoreCount
      } catch {
        self.showError(error)
        return
      }
    })
  }
  
  // MARK: - View
  
  func refreshView(withOffset offset: Int = 0) {
    requestLikes(withOffset: offset == 0 ? offset : offset + ignoreLikes)
  }
  
  func updatePosts(posts: [PhotoPost], offset: Int) {
    if offset == 0 {
      self.posts = posts
    } else {
      posts.forEach { post in
        self.posts.append(post)
      }
    }
    
    self.postIndex = offset == 0 ? offset : offset - ignoreLikes
    self.photoIndex = 0
    self.updatePhoto(withPostIndex: self.postIndex)
  }

  func updatePhoto(withPostIndex postIndex: Int, withPhotoIndex photoIndex: Int = 0) {
    guard let url = posts[postIndex].photos[photoIndex].altSizes.first?.url else {
      showMessage("Can't retrieve url.")
      return
    }
    
    photo.sd_setShowActivityIndicatorView(true)
    photo.sd_setIndicatorStyle(.gray)
    photo.sd_setImage(with: URL(string: url), placeholderImage: nil)
  }

  // MARK: - Controller
  
  func next() {
    photoIndex -= 1
    guard photoIndex >= 0 else {
      postIndex -= 1
      guard postIndex >= 0 else {
        refreshView()
        return
      }
      
      photoIndex = posts[postIndex].photos.count - 1
      updatePhoto(withPostIndex: postIndex, withPhotoIndex: photoIndex)
      return
    }
    
    updatePhoto(withPostIndex: postIndex, withPhotoIndex: photoIndex)
  }
  
  func prev() {
    photoIndex += 1
    guard photoIndex < posts[postIndex].photos.count else {
      postIndex += 1
      guard postIndex < posts.count else {
        refreshView(withOffset: postIndex)
        return
      }

      photoIndex = 0
      updatePhoto(withPostIndex: postIndex)
      return
    }

    updatePhoto(withPostIndex: postIndex, withPhotoIndex: photoIndex)
  }
  
  func crop() {
    let cropViewController: CropViewController = storyboard?.instantiateViewController(withIdentifier: "crop") as! CropViewController
    cropViewController.blogName = user.blogs.first?.name
    cropViewController.image = photo.image
    cropViewController.postUrl = posts[postIndex].photos[photoIndex].altSizes.first?.url
    navigationController?.pushViewController(cropViewController, animated: true)
  }
  
  // MARK: - Gesture
  
  func respondToSwipeGesture(gesture: UIGestureRecognizer) {
    if let swipeGesture = gesture as? UISwipeGestureRecognizer {
      switch swipeGesture.direction {
      case UISwipeGestureRecognizerDirection.left:
        prev()
      case UISwipeGestureRecognizerDirection.right:
        next()
      default:
        break;
      }
    }
  }

  func respondToLongPressGesture(gesture: UIGestureRecognizer) {
    if gesture .state != .began {
      return
    }

    crop()
  }
}
