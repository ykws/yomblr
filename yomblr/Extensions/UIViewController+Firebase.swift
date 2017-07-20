//
//  UIViewController+Firebase.swift
//  yomblr
//
//  Created by Yoshiyuki Kawashima on 2017/07/21.
//  Copyright © 2017 ykws. All rights reserved.
//

import UIKit
import Firebase

extension UIViewController {

  func logEvent(title: String, type: String) {
    Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
      AnalyticsParameterItemID: "id-\(title)" as NSObject,
      AnalyticsParameterItemName: title as NSObject,
      AnalyticsParameterContentType: type as NSObject
    ])
  }
}
