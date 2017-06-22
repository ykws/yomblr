//
//  CroppedViewController.swift
//  yomblr
//
//  Created by Yoshiyuki Kawashima on 2017/06/22.
//  Copyright © 2017 ykws. All rights reserved.
//

import UIKit

class CroppedViewController: UIViewController {
  
  // MARK: - Properties
  
  var image: UIImage!
  
  // MARK: - Outlets
  
  @IBOutlet weak var croppedView: UIImageView!
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    croppedView.image = image
  }
}
