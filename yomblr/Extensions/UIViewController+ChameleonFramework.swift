//
//  UIViewController+ChameleonFramework.swift
//  yomblr
//
//  Created by Yoshiyuki Kawashima on 2017/07/04.
//  Copyright © 2017 ykws. All rights reserved.
//

import UIKit
import ChameleonFramework

extension UIViewController {
  
  func setApplicationColor() {
    view.backgroundColor = FlatBlack()
    setThemeUsingPrimaryColor(.flatBlack, with: .contrast)
  }
}
