//
//  User.swift
//  yomblr
//
//  Created by Yoshiyuki Kawashima on 2017/06/24.
//  Copyright © 2017 ykws. All rights reserved.
//
//  Tumblr API User's Information Responses
//
//  https://www.tumblr.com/docs/en/api/v2#user-methods
//

struct User : JSONDecodable {
  let following: Int
  let defaultPostFormat: String
  let name: String
  let likes: Int
  let blogs: [Blog]
  
  init(json: Any) throws {
    guard let dictionary = json as? [String : Any] else {
      throw JSONDecodeError.invalidFormat(json: json)
    }
    
    guard let user = dictionary["user"] as? [String : Any] else {
      throw JSONDecodeError.missingValue(key: "user", actualValue: dictionary["user"])
    }
    
    guard let following = user["following"] as? Int else {
      throw JSONDecodeError.missingValue(key: "following", actualValue: user["following"])
    }
    
    guard let defaultPostFormat = user["default_post_format"] as? String else {
      throw JSONDecodeError.missingValue(key: "default_post_format", actualValue: user["default_post_format"])
    }
    
    guard let name = user["name"] as? String else {
      throw JSONDecodeError.missingValue(key: "name", actualValue: user["name"])
    }
    
    guard let likes = user["likes"] as? Int else {
      throw JSONDecodeError.missingValue(key: "likes", actualValue: user["likes"])
    }
    
    guard let blogObjects = user["blogs"] as? [Any] else {
      throw JSONDecodeError.missingValue(key: "blogs", actualValue: user["blogs"])
    }
    
    let blogs = try blogObjects.map {
      return try Blog(json: $0)
    }
    
    self.following = following
    self.defaultPostFormat = defaultPostFormat
    self.name = name
    self.likes = likes
    self.blogs = blogs
  }
}
