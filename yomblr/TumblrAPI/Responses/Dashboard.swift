//
//  Dashboard.swift
//  yomblr
//
//  Created by Yoshiyuki Kawashima on 2017/06/24.
//  Copyright © 2017 ykws. All rights reserved.
//

/**
 Tumblr API /user/dashboard - Retrieve a User's Dashboard Responses
 
 **Only Photo Posts**
 
 https://www.tumblr.com/docs/en/api/v2#user-methods
 */
struct Dashboard : JSONDecodable {
  let posts: [PhotoPost]
  
  init(json: Any) throws {
    guard let dictionary = json as? [String : Any] else {
      throw JSONDecodeError.invalidFormat(json: json)
    }
    
    guard let postObjects = dictionary["posts"] as? [Any] else {
      throw JSONDecodeError.missingValue(key: "posts", actualValue: dictionary["posts"])
    }
    
    let posts = try postObjects.map {
      return try PhotoPost(json: $0)
    }
    
    self.posts = posts
  }
}
