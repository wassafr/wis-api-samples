//
//  Token.swift
//  WisImplementationExample
//
//  Created by Bertrand VILLAIN on 18/10/2021.
//

import Foundation

struct Token: Decodable {
  var token : String
  var expireTime : Int
  var refreshToken : String
}
