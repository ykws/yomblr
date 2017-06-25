//
//  AltSize.swift
//  yomblr
//
//  Created by Yoshiyuki Kawashima on 2017/06/24.
//  Copyright © 2017 ykws. All rights reserved.
//

/**
 Alternate photo size
 
 Including in Tumblr API /posts - Retrieve Published Posts Responses
 
 https://www.tumblr.com/docs/en/api/v2#m-posts-responses
 */
struct AltSize : JSONDecodable {
  let width: Int
  let height: Int
  let url: String
  
  init(json: Any) throws {
    guard let dictionary = json as? [String : Any] else {
      throw JSONDecodeError.invalidFormat(json: json)
    }
    
    guard let width = dictionary["width"] as? Int else {
      throw JSONDecodeError.missingValue(key: "width", actualValue: dictionary["width"])
    }
    
    guard let height = dictionary["height"] as? Int else {
      throw JSONDecodeError.missingValue(key: "height", actualValue: dictionary["height"])
    }
    
    guard let url = dictionary["url"] as? String else {
      throw JSONDecodeError.missingValue(key: "url", actualValue: dictionary["url"])
    }
    
    self.width = width
    self.height = height
    self.url = url
  }
}
