//
//  IdentityResponse.swift
//  WisImplementationExample
//
//  Created by Bertrand VILLAIN on 18/10/2021.
//

import Foundation

class IdentityResponse: Codable {
  let status: JobStatus
  var identityId: String?
}
