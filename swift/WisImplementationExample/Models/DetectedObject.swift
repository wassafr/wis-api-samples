//
//  DetectedObject.swift
//  WisImplementationExample
//
//  Created by Bertrand VILLAIN on 18/10/2021.
//

import Foundation

struct DetectedObject: Decodable {
  var className: VehicleType?
  var score: Double?
  var box: [Point]?
}
