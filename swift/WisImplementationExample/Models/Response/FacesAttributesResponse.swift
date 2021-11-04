//
//  <#name#>.swift
//  WisImplementationExample
//
//  Created by Bertrand VILLAIN on 18/10/2021.
//

import Foundation

class FacesAttributesResponse: Decodable {
  let status: JobStatus
  var faces: [Face]?
}
