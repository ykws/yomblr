//
//  PhotoPost.swift
//  yomblr
//
//  Created by Yoshiyuki Kawashima on 2017/06/24.
//  Copyright © 2017 ykws. All rights reserved.
//

/**
 Post's information **only Photo Posts**

 Including in Tumblr API /user/dashboard - Retrieve a User's Dashboard Responses
 returned in Tumblr API /posts - Retrieve Published Posts Responses.
 
 https://www.tumblr.com/docs/en/api/v2#m-posts-responses
 
 exclude.
 
 reason: for quotes, reblogs, etc.
 
 - `source_url`
 - `source_title`
 
 reason: missing field.
 
 - `total_posts`
 - `width`
 - `height`
 */
struct PhotoPost : JSONDecodable {
  
  // MARK: - All Post Types
  
  let blogName: String
  let id: Int
  let postUrl: String
  let type: String
  let timestamp: Int
  let date: String
  let format: String
  let reblogKey: String
  let tags: [String]
  let bookmarklet: Bool
  let mobile: Bool
  let liked: Bool
  let state: String
  
  // MARK: - Photo Posts
  
  let photos : [Photo]
  let caption: String
  
  // MARK: - Initializer
  
  init(json: Any) throws {
    guard let dictionary = json as? [String : Any] else {
      throw JSONDecodeError.invalidFormat(json: json)
    }
    
    guard let blogName = dictionary["blog_name"] as? String else {
      throw JSONDecodeError.missingValue(key: "blog_name", actualValue: dictionary["blog_name"])
    }
    
    guard let id = dictionary["id"] as? Int else {
      throw JSONDecodeError.missingValue(key: "id", actualValue: dictionary["id"])
    }
    
    guard let postUrl = dictionary["post_url"] as? String else {
      throw JSONDecodeError.missingValue(key: "post_url", actualValue: dictionary["post_url"])
    }
    
    guard let type = dictionary["type"] as? String else {
      throw JSONDecodeError.missingValue(key: "type", actualValue: dictionary["type"])
    }
    
    guard type == "photo" else {
      throw JSONDecodeError.unsupportedType(type)
    }
    
    guard let timestamp = dictionary["timestamp"] as? Int else {
      throw JSONDecodeError.missingValue(key: "timestamp", actualValue: dictionary["timestamp"])
    }
    
    guard let date = dictionary["date"] as? String else {
      throw JSONDecodeError.missingValue(key: "date", actualValue: dictionary["date"])
    }
    
    guard let format = dictionary["format"] as? String else {
      throw JSONDecodeError.missingValue(key: "format", actualValue: dictionary["format"])
    }
    
    guard let reblogKey = dictionary["reblog_key"] as? String else {
      throw JSONDecodeError.missingValue(key: "reblog_key", actualValue: dictionary["reblog_key"])
    }
    
    guard let tags = dictionary["tags"] as? [String] else {
      throw JSONDecodeError.missingValue(key: "tags", actualValue: dictionary["tags"])
    }
    
    let bookmarklet = dictionary["bookmarklet"] as? Bool ?? false
    let mobile = dictionary["mobile"] as? Bool ?? false
    
    guard let liked = dictionary["liked"] as? Bool else {
      throw JSONDecodeError.missingValue(key: "liked", actualValue: dictionary["liked"])
    }
    
    guard let state = dictionary["state"] as? String else {
      throw JSONDecodeError.missingValue(key: "state", actualValue: dictionary["state"])
    }
    
    guard let photoObjects = dictionary["photos"] as? [Any] else {
      throw JSONDecodeError.missingValue(key: "photos", actualValue: dictionary["photos"])
    }
    
    let photos = try photoObjects.map {
      return try Photo(json: $0)
    }
    
    guard let caption = dictionary["caption"] as? String else {
      throw JSONDecodeError.missingValue(key: "caption", actualValue: dictionary["caption"])
    }
    
    self.blogName = blogName
    self.id = id
    self.postUrl = postUrl
    self.type = type
    self.timestamp = timestamp
    self.date = date
    self.format = format
    self.reblogKey = reblogKey
    self.tags = tags
    self.bookmarklet = bookmarklet
    self.mobile = mobile
    self.liked = liked
    self.state = state
    
    self.photos = photos
    self.caption = caption
  }
}
