//
//  JSONDecodeError.swift
//  yomblr
//
//  Created by Yoshiyuki Kawashima on 2017/06/24.
//  Copyright © 2017 ykws. All rights reserved.
//

enum JSONDecodeError : Error {
  case invalidFormat(json: Any)
  case missingValue(key: String, actualValue: Any?)
  case unsupportedType(String)
}
