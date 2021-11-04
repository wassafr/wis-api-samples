//
//  Orientation.swift
//  WisImplementationExample
//
//  Created by Bertrand VILLAIN on 18/10/2021.
//

import Foundation

enum Orientation: String, Decodable {
  
  case normal
  case clockwise
  case counterClockwise = "counter_clockwise"
  case upsideDown = "upside_down"
  
  init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    let rawValue = try container.decode(String.self)
    guard let state = Orientation(rawValue: rawValue) else { throw WisNetworkError.errorParsingJSON("Orientation") }
    self = state
  }
  
}
