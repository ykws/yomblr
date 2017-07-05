//
//  WebViewController.swift
//  yomblr
//
//  Created by Yoshiyuki Kawashima on 2017/07/04.
//  Copyright © 2017 ykws. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate {
  
  // MARK: - Properties
  
  var blogName: String!
  var urlString: String!
  var webView: WKWebView!
  
  // MARK: - Life  Cycle
  
  override func loadView() {
    let webConfiguration = WKWebViewConfiguration()
    webView = WKWebView(frame: .zero, configuration: webConfiguration)
    webView.uiDelegate = self
    webView.allowsBackForwardNavigationGestures = true
    view = webView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let url = URL(string: urlString)
    let request = NSURLRequest(url: url!)
    webView.load(request as URLRequest)
  }

  // MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let cropViewController: CropViewController = segue.destination as? CropViewController {
      cropViewController.blogName = blogName
      cropViewController.image = screenshot()
      cropViewController.postUrl = webView.url?.absoluteString
    }
  }

  // MARK: - Private
  
  func screenshot() -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(webView.bounds.size, true, 0)
    webView.drawHierarchy(in: webView.bounds, afterScreenUpdates: true)
    let snapshotImage = UIGraphicsGetImageFromCurrentImageContext()
    let data = UIImagePNGRepresentation(snapshotImage!)
    UIGraphicsEndImageContext()
    return UIImage.init(data: data!)
  }
}
