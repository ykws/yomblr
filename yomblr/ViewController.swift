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
  
  // MARK: - Outlets

  @IBOutlet weak var photo: UIImageView!
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    TMAPIClient.sharedInstance().authenticate("yomblr", from: self, callback: { error in
      if (error != nil) {
        print("\(String(describing: error?.localizedDescription))")
        return
      }
      
      TMAPIClient.sharedInstance().dashboard(["type": "photo", "limit": 1], callback: { result, erro in
        if (error != nil) {
          print("\(String(describing: error?.localizedDescription))")
          return
        }

        guard let dictionary = result as? [String: Any] else {
          print("result was not JSON.")
          return
        }
        
        guard let postObjects = dictionary["posts"] as? [Any] else {
          print("result was not fount \"posts\".")
          return
        }
        
        guard let postObject = postObjects[0] as? [String: Any] else {
          print("\"posts\" counts is 0.")
          return
        }
        
        guard let photoObjects = postObject["photos"] as? [Any] else {
          print("result was not fount \"photos\".")
          return
        }
        
        guard let photoObject = photoObjects[0] as? [String: Any] else {
          print("\"photos\" counts is 0.")
          return
        }
        
        guard let altSizeObjects = photoObject["alt_sizes"] as? [Any] else {
          print("result was not fount \"alt_sizes\".")
          return
        }
        
        guard let altSizeObject = altSizeObjects[0] as? [String: Any] else {
          print("\"alt_size\" counts is 0.")
          return
        }
        
        guard let url = altSizeObject["url"] as? String else {
          print("result was not fount \"url\".")
          return
        }
        
        self.photo.sd_setImage(with: URL(string: url), placeholderImage: nil)
      })
    })
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  // MARK: - Navigation
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    (segue.destination as! CropViewController).image = photo.image
  }
}
