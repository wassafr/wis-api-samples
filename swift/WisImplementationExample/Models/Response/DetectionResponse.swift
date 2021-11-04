//
//  DetectionResponse.swift
//  WisImplementationExample
//
//  Created by Bertrand VILLAIN on 18/10/2021.
//

import Foundation

class DetectionResponse: Decodable {
  let status: JobStatus
  var objectCounting: [String: Int]?
  var objects: [String]?
}
