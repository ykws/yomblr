//
//  Photo.swift
//  yomblr
//
//  Created by Yoshiyuki Kawashima on 2017/06/24.
//  Copyright © 2017 ykws. All rights reserved.
//

/**
 Post's photo's information
 
 Including in Tumblr API /posts - Retrieve Published Posts Responses
 
 https://www.tumblr.com/docs/en/api/v2#m-posts-responses
 */
struct Photo : JSONDecodable {
  let caption: String
  let altSizes: [AltSize]
  
  init(json: Any) throws {
    guard let dictionary = json as? [String : Any] else {
      throw JSONDecodeError.invalidFormat(json: json)
    }
    
    guard let caption = dictionary["caption"] as? String else {
      throw JSONDecodeError.missingValue(key: "caption", actualValue: dictionary["caption"])
    }
    
    guard let altSizeObjects = dictionary["alt_sizes"] as? [Any] else {
      throw JSONDecodeError.missingValue(key: "alt_sizes", actualValue: dictionary["alt_sizes"])
    }
    
    let altSizes = try altSizeObjects.map {
      return try AltSize(json: $0)
    }
    
    self.caption = caption
    self.altSizes = altSizes
  }
}
