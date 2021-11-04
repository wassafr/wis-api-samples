//
//  VehicleType.swift
//  WisImplementationExample
//
//  Created by Bertrand VILLAIN on 18/10/2021.
//

import Foundation

enum VehicleType: String, Codable {
  
  case car
  case truck
  case pedestrian
  case bus
  case motorcycle
  case bicycle

  init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    let rawValue = try container.decode(String.self)
    guard let state = VehicleType(rawValue: rawValue) else { throw WisNetworkError.errorParsingJSON("VehicleType") }
    self = state
  }
  
}
