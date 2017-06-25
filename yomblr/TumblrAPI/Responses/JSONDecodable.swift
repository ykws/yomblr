//
//  JSONDecodable.swift
//  yomblr
//
//  Created by Yoshiyuki Kawashima on 2017/06/24.
//  Copyright © 2017 ykws. All rights reserved.
//

protocol JSONDecodable {
  init(json: Any) throws
}
