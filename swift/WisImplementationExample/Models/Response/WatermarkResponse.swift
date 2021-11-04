//
//  WatermarkResponse.swift
//  WisImplementationExample
//
//  Created by Bertrand VILLAIN on 18/10/2021.
//

import Foundation

class WatermarkResponse: Decodable {
  let status: JobStatus
  var outputImageUrl: String?
}
