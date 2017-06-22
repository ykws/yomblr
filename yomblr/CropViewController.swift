//
//  CropViewController.swift
//  yomblr
//
//  Created by Yoshiyuki Kawashima on 2017/06/22.
//  Copyright © 2017 ykws. All rights reserved.
//

import UIKit
import AKImageCropperView

class CropViewController: UIViewController {
  
  // MARK: - Properties
  
  var image: UIImage!
  
  // MARK: - Outlets
  
  @IBOutlet weak var cropView: AKImageCropperView!
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    cropView.image = image
    cropView.showOverlayView(animationDuration: 0)
  }
  
  // MARK: - Navigation
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    (segue.destination as! CroppedViewController).image = cropView.croppedImage
  }
}
