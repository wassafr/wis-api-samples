//
//  OrientationResponse.swift
//  WisImplementationExample
//
//  Created by Bertrand VILLAIN on 18/10/2021.
//

import Foundation

class OrientationResponse: Decodable {
  let status: JobStatus
  var label: Orientation?
  var confidence: Double?
}
