//
//  IdentityRecognizeResponse.swift
//  WisImplementationExample
//
//  Created by Bertrand VILLAIN on 18/10/2021.
//

import Foundation

class IdentityRecognizeResponse: Decodable {
  let status: JobStatus
  var results: IdentitySearchResult?
}
