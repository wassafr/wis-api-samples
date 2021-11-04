//
//  <#name#>.swift
//  WisImplementationExample
//
//  Created by Bertrand VILLAIN on 18/10/2021.
//

import Foundation

class AnonymizationResponse: Decodable {
  let status: JobStatus
  var outputMedia: String?
  var outputJson: String?
}
