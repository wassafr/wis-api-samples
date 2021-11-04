//
//  IdentitySearchResult.swift
//  WisImplementationExample
//
//  Created by Bertrand VILLAIN on 18/10/2021.
//

import Foundation

struct IdentitySearchResult: Decodable {
  var identityId: String?
  var score: Double?
  var recognition: Bool?
}
