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

  @IBOutlet weak var message: UILabel!
  @IBOutlet weak var photo: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    TMAPIClient.sharedInstance().authenticate("yomblr", from: self, callback: { error in
      if (error != nil) {
        self.message.text = error?.localizedDescription
        return
      }
      
      self.message.text = "Authenticated on Tumblr!"

      TMAPIClient.sharedInstance().dashboard(["type": "photo", "limit": 1], callback: { result, erro in
        if (error != nil) {
          self.message.text = error?.localizedDescription
          return
        }

        guard let dictionary = result as? [String: Any] else {
          self.message.text = "result was not JSON."
          return
        }
        
        guard let postObjects = dictionary["posts"] as? [Any] else {
          self.message.text = "result was not fount \"posts\"."
          return
        }
        
        guard let postObject = postObjects[0] as? [String: Any] else {
          self.message.text = "\"posts\" counts is 0."
          return
        }
        
        guard let photoObjects = postObject["photos"] as? [Any] else {
          self.message.text = "result was not fount \"photos\"."
          return
        }
        
        guard let photoObject = photoObjects[0] as? [String: Any] else {
          self.message.text = "\"photos\" counts is 0."
          return
        }
        
        guard let altSizeObjects = photoObject["alt_sizes"] as? [Any] else {
          self.message.text = "result was not fount \"alt_sizes\"."
          return
        }
        
        guard let altSizeObject = altSizeObjects[0] as? [String: Any] else {
          self.message.text = "\"alt_size\" counts is 0."
          return
        }
        
        guard let url = altSizeObject["url"] as? String else {
          self.message.text = "result was not fount \"url\"."
          return
        }
        
        self.message.text = "Dashboard on Tumblr!"
        self.photo.sd_setImage(with: URL(string: url), placeholderImage: nil)
      })
    })
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

