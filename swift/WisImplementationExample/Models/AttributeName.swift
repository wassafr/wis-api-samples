//
//  AttributeName.swift
//  WisImplementationExample
//
//  Created by Bertrand VILLAIN on 18/10/2021.
//

import Foundation

enum AttributeName: String, Decodable {
  
  case age
  case gender
  case mask
  
  init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    let rawValue = try container.decode(String.self)
    guard let state = AttributeName(rawValue: rawValue) else { throw WisNetworkError.errorParsingJSON("AttributeName") }
    self = state
  }
  
}
