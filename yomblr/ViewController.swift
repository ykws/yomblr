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
  
  // MARK: - Outlets

  @IBOutlet weak var photo: UIImageView!

  // MARK: - Actions

  @IBAction func next(_ sender: Any) {
    photoIndex -= 1
    guard photoIndex >= 0 else {
      postIndex -= 1
      guard postIndex >= 0 else {
        requestDashboard()
        return
      }

      photoIndex = posts[postIndex].photos.count - 1
      updatePhoto(withPostIndex: postIndex, withPhotoIndex: photoIndex)
      return
    }
    
    updatePhoto(withPostIndex: postIndex, withPhotoIndex: photoIndex)
  }

  @IBAction func prev(_ sender: Any) {
    photoIndex += 1
    guard photoIndex < posts[postIndex].photos.count else {
      postIndex += 1
      guard postIndex < posts.count else {
        requestDashboard(withOffset: postIndex)
        return
      }

      photoIndex = 0
      updatePhoto(withPostIndex: postIndex)
      return
    }

    updatePhoto(withPostIndex: postIndex, withPhotoIndex: photoIndex)
  }

  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    guard let oAuthToken = UserDefaults.standard.string(forKey: "OAuthToken"),
      let oAuthTokenSecret = UserDefaults.standard.string(forKey: "OAuthTokenSecret") else {
      authenticate()
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
      cropViewController.postUrl = posts[postIndex].photos.first?.altSizes.first?.url
    }
  }

  // MARK: - Tumblr

  func authenticate() {
    let hud = MBProgressHUD.showAdded(to: view, animated: true)
    hud.mode = .indeterminate
    hud.label.text = "authenticating..."
    
    TMAPIClient.sharedInstance().authenticate("yomblr", from: self, callback: { error in
      hud.hide(animated: true)
      
      if (error != nil) {
        print("\(String(describing: error?.localizedDescription))")
        return
      }

      guard let oAuthToken = TMAPIClient.sharedInstance().oAuthToken,
        let oAuthTokenSecret = TMAPIClient.sharedInstance().oAuthTokenSecret else {
          print("can't retrieve OAuthToken or OAuthTokenSecret")
          return
      }

      UserDefaults.standard.set(oAuthToken, forKey: "OAuthToken")
      UserDefaults.standard.set(oAuthTokenSecret, forKey: "OAuthTokenSecret")

      self.requestUserInfo()
    })
  }
  
  func requestUserInfo() {
    let hud = MBProgressHUD.showAdded(to: view, animated: true)
    hud.mode = .indeterminate
    hud.label.text = "requesting user's information..."
    
    TMAPIClient.sharedInstance().userInfo({ response, error in
      hud.hide(animated: true)
      
      if (error != nil) {
        print("\(String(describing: error?.localizedDescription))")
        return
      }
      
      do {
        self.user = try User.init(json: response!)
      } catch {
        print("Error: \(error)")
        return
      }
      
      self.requestDashboard()
    })
  }

  func requestDashboard(withOffset offset: Int = 0) {
    let hud = MBProgressHUD.showAdded(to: view, animated: true)
    hud.mode = .indeterminate
    hud.label.text = "requesting dashboard..."
    
    TMAPIClient.sharedInstance().dashboard(["limit": 20, "offset": offset, "type": "photo"], callback: { response, error in
      hud.hide(animated: true)
      
      if (error != nil) {
        print("\(String(describing: error?.localizedDescription))")
        return
      }

      do {
        let dashboard = try Dashboard.init(json: response!)
        if offset == 0 {
          self.posts = dashboard.posts
        } else {
          dashboard.posts.forEach { post in
            self.posts.append(post)
          }
        }
      } catch {
        print("Error: \(error)")
        return
      }

      self.postIndex = offset
      self.photoIndex = 0
      self.updatePhoto(withPostIndex: self.postIndex)
    })
  }
  
  // MARK: - Private
  
  func updatePhoto(withPostIndex postIndex: Int, withPhotoIndex photoIndex: Int = 0) {
    guard let url = posts[postIndex].photos[photoIndex].altSizes.first?.url else {
      print("can't retrieve url.")
      return
    }
    
    photo.sd_setShowActivityIndicatorView(true)
    photo.sd_setIndicatorStyle(.gray)
    photo.sd_setImage(with: URL(string: url), placeholderImage: nil)
  }
}
