//
//  SoilingResponse.swift
//  WisImplementationExample
//
//  Created by Bertrand VILLAIN on 18/10/2021.
//

import Foundation

class SoilingResponse: Decodable {
  let status: JobStatus
  var resultSoiling: Soiling?
}
