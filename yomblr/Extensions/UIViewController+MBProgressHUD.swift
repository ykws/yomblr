//
//  UIViewController+MBProgressHUD.swift
//  yomblr
//
//  Created by Yoshiyuki Kawashima on 2017/06/25.
//  Copyright © 2017 ykws. All rights reserved.
//

import UIKit
import MBProgressHUD

extension UIViewController {
  
  /**
   Show progress and begin ignoreing interaction events.
   
   - parameter message: display on hud
   
   - returns: Showed hud
   */
  func showProgress(withMessage message: String) -> MBProgressHUD {
    UIApplication.shared.beginIgnoringInteractionEvents()
    let hud = MBProgressHUD.showAdded(to: view, animated: true)
    hud.mode = .indeterminate
    hud.label.text = message
    return hud
  }
  
  /**
   Show message, can't handle hud
   
   - parameter message: display on hud
   */
  func showMessage(_ message: String) {
    let hud = MBProgressHUD.showAdded(to: view, animated: true)
    hud.mode = .text
    hud.detailsLabel.text = message
  }
  
  /**
   Show error, can't handle hud
   
   - parameter error: display on hud, and output consolse
   */
  func showError(_ error: Error) {
    let hud = MBProgressHUD.showAdded(to: view, animated: true)
    hud.mode = .text
    hud.detailsLabel.text = error.localizedDescription
    print("Error: \(error)")
  }
  
  /**
   Hide progress and end ignoring interaction evenets.
   
   - parameter hud: hide hud
   */
  func hideProgress(hud: MBProgressHUD) {
    hud.hide(animated: true)
    UIApplication.shared.endIgnoringInteractionEvents()
  }
}
