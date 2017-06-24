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

class ViewController: UIViewController {
  
  // MARK: - Properties
  
  var user: User!
  var dashboard: Dashboard!
  
  // MARK: - Outlets

  @IBOutlet weak var photo: UIImageView!
  
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
    showDashboard()
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
      cropViewController.postUrl = dashboard.posts.first?.photos.first?.altSizes.first?.url
    }
  }

  // MARK: - Tumblr

  func authenticate() {
    TMAPIClient.sharedInstance().authenticate("yomblr", from: self, callback: { error in
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

      self.showDashboard()
    })
  }

  func showDashboard() {
    TMAPIClient.sharedInstance().userInfo({ response, error in
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

      TMAPIClient.sharedInstance().dashboard(["type": "photo", "limit": 1], callback: { response, error in
        if (error != nil) {
          print("\(String(describing: error?.localizedDescription))")
          return
        }

        do {
          self.dashboard = try Dashboard.init(json: response!)
        } catch {
          print("Error: \(error)")
          return
        }
        
        guard let url = self.dashboard.posts.first?.photos.first?.altSizes.first?.url else {
          print("Nothing post.")
          return
        }
        
        self.photo.sd_setImage(with: URL(string: url), placeholderImage: nil)
      })
    })
  }
}
