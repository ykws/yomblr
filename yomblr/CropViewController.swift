//
//  CropViewController.swift
//  yomblr
//
//  Created by Yoshiyuki Kawashima on 2017/06/22.
//  Copyright © 2017 ykws. All rights reserved.
//

import UIKit
import AKImageCropperView
import Firebase

class CropViewController: UIViewController {
  
  // MARK: - Properties
  
  var blogName: String!
  var image: UIImage!
  var postUrl: String!
  
  // MARK: - Outlets
  
  @IBOutlet weak var cropView: AKImageCropperView!
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    
    setApplicationColor()
    
    cropView.image = image
    cropView.showOverlayView(animationDuration: 0)
  }
  
  // MARK: - Navigation
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let croppedViewController: CroppedViewController = segue.destination as? CroppedViewController {
      logEvent(title: "Done", type: "Button")
      croppedViewController.blogName = blogName
      croppedViewController.image = cropView.croppedImage
      croppedViewController.postUrl = postUrl
    }
  }
}
