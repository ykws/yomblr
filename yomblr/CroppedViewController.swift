//
//  CroppedViewController.swift
//  yomblr
//
//  Created by Yoshiyuki Kawashima on 2017/06/22.
//  Copyright © 2017 ykws. All rights reserved.
//

import UIKit
import TMTumblrSDK

class CroppedViewController: UIViewController {
  
  // MARK: - Properties
  
  var blogName: String!
  var image: UIImage!
  var postUrl: String!
  
  // MARK: - Outlets
  
  @IBOutlet weak var croppedView: UIImageView!
  
  // MARK: - Actions
  
  @IBAction func post(_ sender: Any) {
    let base64Image: String = (UIImagePNGRepresentation(image)?.base64EncodedString())!
    TMAPIClient.sharedInstance().post(blogName, type: "photo", parameters: ["link": postUrl, "data64": base64Image], callback: { result, error in
      if (error != nil) {
        print("\(String(describing: error?.localizedDescription))")
        return
      }

      self.navigationController?.popToRootViewController(animated: true)
    })
  }
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    croppedView.image = image
  }
}
