//
//  Blog.swift
//  yomblr
//
//  Created by Yoshiyuki Kawashima on 2017/06/24.
//  Copyright © 2017 ykws. All rights reserved.
//
//  Tumblr API Blog Info Responses
//
//  https://www.tumblr.com/docs/en/api/v2#blog-info
//

struct Blog : JSONDecodable {
  let title: String
  let posts: Int
  let name: String
  let updated: Int
  let description: String
  let ask: Bool
  let askAnon: Bool
  let likes: Int
  let isBlockedFromPrimary: Bool
  
  init(json: Any) throws {
    guard let dictionary = json as? [String : Any] else {
      throw JSONDecodeError.invalidFormat(json: json)
    }
    
    guard let title = dictionary["title"] as? String else {
      throw JSONDecodeError.missingValue(key: "title", actualValue: dictionary["title"])
    }
    
    guard let posts = dictionary["posts"] as? Int else {
      throw JSONDecodeError.missingValue(key: "posts", actualValue: dictionary["posts"])
    }
    
    guard let name = dictionary["name"] as? String else {
      throw JSONDecodeError.missingValue(key: "name", actualValue: dictionary["name"])
    }
    
    guard let updated = dictionary["updated"] as? Int else {
      throw JSONDecodeError.missingValue(key: "updated", actualValue: dictionary["updated"])
    }
    
    guard let description = dictionary["description"] as? String else {
      throw JSONDecodeError.missingValue(key: "description", actualValue: dictionary["description"])
    }
    
    guard let ask = dictionary["ask"] as? Bool else {
      throw JSONDecodeError.missingValue(key: "ask", actualValue: dictionary["ask"])
    }
    
    guard let isBlockedFromPrimary = dictionary["is_blocked_from_primary"] as? Bool else {
      throw JSONDecodeError.missingValue(key: "is_blocked_from_primary", actualValue: dictionary["is_blocked_from_primary"])
    }
    
    self.title = title
    self.posts = posts
    self.name = name
    self.updated = updated
    self.description = description
    self.ask = ask
    self.isBlockedFromPrimary = isBlockedFromPrimary
    
    if ask {
      self.askAnon = false
    } else {
      guard let askAnon = dictionary["ask_anon"] as? Bool else {
        throw JSONDecodeError.missingValue(key: "ask_anon", actualValue: dictionary["ask_anon"])
      }
      
      self.askAnon = askAnon
    }
    
    if !isBlockedFromPrimary {
      self.likes = 0
    } else {
      guard let likes = dictionary["likes"] as? Int else {
        throw JSONDecodeError.missingValue(key: "likes", actualValue: dictionary["likes"])
      }
      
      self.likes = likes
    }
  }
}
