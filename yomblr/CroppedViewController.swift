//
//  CroppedViewController.swift
//  yomblr
//
//  Created by Yoshiyuki Kawashima on 2017/06/22.
//  Copyright © 2017 ykws. All rights reserved.
//

import UIKit
import TMTumblrSDK
import MBProgressHUD

class CroppedViewController: UIViewController {
  
  // MARK: - Properties
  
  var blogName: String!
  var image: UIImage!
  var postUrl: String!
  
  // MARK: - Outlets
  
  @IBOutlet weak var croppedView: UIImageView!
  
  // MARK: - Actions
  
  @IBAction func post(_ sender: Any) {
    guard let base64EncodedString = UIImagePNGRepresentation(image)?.base64EncodedString() else {
      print("can't Base64 encode.")
      return
    }
    
    requestPhotoPost(withImageBase64EncodedString: base64EncodedString)
  }
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    croppedView.image = image
  }
  
  // MARK: - Tumblr
  
  func requestPhotoPost(withImageBase64EncodedString data64: String) {
    let hud = MBProgressHUD.showAdded(to: view, animated: true)
    hud.mode = .indeterminate
    hud.label.text = "Uploading..."
    
    TMAPIClient.sharedInstance().post(blogName, type: "photo", parameters: ["link": postUrl, "data64": data64], callback: { response, error in
      hud.hide(animated: true)
      
      if (error != nil) {
        print("\(String(describing: error?.localizedDescription))")
        return
      }

      self.navigationController?.popToRootViewController(animated: true)
    })   
  }
}
