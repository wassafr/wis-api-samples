//
//  VehicleResponse.swift
//  WisImplementationExample
//
//  Created by Bertrand VILLAIN on 18/10/2021.
//

import Foundation

class VehicleResponse: Decodable {
  let status: JobStatus
  var vehicles: [VehicleType]?
}
