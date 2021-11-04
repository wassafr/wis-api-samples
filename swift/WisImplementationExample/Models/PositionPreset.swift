//
//  PositionPreset.swift
//  WisImplementationExample
//
//  Created by Bertrand VILLAIN on 20/10/2021.
//

import Foundation

enum PositionPreset: String, Codable {
  
  case upperRight = "upper_right"
  case lowerRight = "lower_right"
  case upperLeft = "upper_left"
  case lowerLeft = "lower_left"
  case centerRight = "center_right"
  case centerLeft = "center_left"
  case center = "center"
  case lower = "lower"
  
  init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    let rawValue = try container.decode(String.self)
    guard let state = PositionPreset(rawValue: rawValue.lowercased()) else { throw WisNetworkError.errorParsingJSON("PositionPreset") }
    self = state
  }

}
