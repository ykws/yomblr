//
//  Likes.swift
//  yomblr
//
//  Created by Yoshiyuki Kawashima on 2017/06/25.
//  Copyright © 2017 ykws. All rights reserved.
//

/**
 Tumblr API /likes - Retrieve Blog's Likes
 
 **Only Photo Posts**
 
 https://www.tumblr.com/docs/en/api/v2#blog-likes
 */
struct Likes : JSONDecodable {
  let likedPosts: [PhotoPost]
  let likedCount: Int
  let ignoreCount: Int
  
  init(json: Any) throws {
    guard let dictionary = json as? [String : Any] else {
      throw JSONDecodeError.invalidFormat(json: json)
    }
    
    guard let postObjects = dictionary["liked_posts"] as? [Any] else {
      throw JSONDecodeError.missingValue(key: "liked_posts", actualValue: dictionary["liked_posts"])
    }
    
    var ignoreCount: Int = 0
    var posts: [PhotoPost] = Array.init()
    for postObject in postObjects {
      do {
        let post = try PhotoPost.init(json: postObject)
        posts.append(post)
      } catch JSONDecodeError.unsupportedType(let type) {
        ignoreCount += 1
        print("Ignore: \(type) type is unsupported.")
      }
    }
    
    guard let likedCount = dictionary["liked_count"] as? Int else {
      throw JSONDecodeError.missingValue(key: "liked_count", actualValue: dictionary["liked_count"])
    }
    
    self.likedPosts = posts
    self.likedCount = likedCount
    self.ignoreCount = ignoreCount
  }
}
