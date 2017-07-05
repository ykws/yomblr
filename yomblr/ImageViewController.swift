//
//  ImageViewController.swift
//  yomblr
//
//  Created by Yoshiyuki Kawashima on 2017/07/04.
//  Copyright © 2017 ykws. All rights reserved.
//

import UIKit
import SDWebImage

class ImageViewController: UIViewController {
  
  // MARK: - Properties
  
  var blogName: String!
  var postUrl: String!
  var imageUrl: String!
 
  // MARK: - Outlets

  @IBOutlet weak var photo: UIImageView!
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setApplicationColor()
    
    photo.sd_setShowActivityIndicatorView(true)
    photo.sd_setIndicatorStyle(.gray)
    photo.sd_setImage(with: URL(string: imageUrl), placeholderImage: nil)
  }
}
