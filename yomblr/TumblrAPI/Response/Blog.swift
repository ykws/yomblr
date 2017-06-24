//
//  Blog.swift
//  yomblr
//
//  Created by Yoshiyuki Kawashima on 2017/06/24.
//  Copyright © 2017 ykws. All rights reserved.
//

/**
 The user's blog's information
 
 Including in Tumblr API /user/info - Get a User's Information Responses

 https://www.tumblr.com/docs/en/api/v2#user-methods
 */
struct Blog : JSONDecodable {
  let name: String
  let url: String
  let title: String
  let primary: Bool
  let followers: Int
  let tweet: String
  let facebook: String
  let type: String
  
  init(json: Any) throws {
    guard let dictionary = json as? [String : Any] else {
      throw JSONDecodeError.invalidFormat(json: json)
    }
    
    guard let name = dictionary["name"] as? String else {
      throw JSONDecodeError.missingValue(key: "name", actualValue: dictionary["name"])
    }
    
    guard let url = dictionary["url"] as? String else {
      throw JSONDecodeError.missingValue(key: "url", actualValue: dictionary["url"])
    }
    
    guard let title = dictionary["title"] as? String else {
      throw JSONDecodeError.missingValue(key: "title", actualValue: dictionary["title"])
    }
    
    guard let primary = dictionary["primary"] as? Bool else {
      throw JSONDecodeError.missingValue(key: "primary", actualValue: dictionary["primary"])
    }
    
    guard let followers = dictionary["followers"] as? Int else {
      throw JSONDecodeError.missingValue(key: "followers", actualValue: dictionary["followers"])
    }
    
    guard let tweet = dictionary["tweet"] as? String else {
      throw JSONDecodeError.missingValue(key: "tweet", actualValue: dictionary["tweet"])
    }
    
    guard let facebook = dictionary["facebook"] as? String else {
      throw JSONDecodeError.missingValue(key: "facebook", actualValue: dictionary["facebook"])
    }
    
    guard let type = dictionary["type"] as? String else {
      throw JSONDecodeError.missingValue(key: "type", actualValue: dictionary["type"])
    }
    
    self.name = name
    self.url = url
    self.title = title
    self.primary = primary
    self.followers = followers
    self.tweet = tweet
    self.facebook = facebook
    self.type = type
  }
}
