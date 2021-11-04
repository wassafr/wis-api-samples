//
//  Face.swift
//  WisImplementationExample
//
//  Created by Bertrand VILLAIN on 18/10/2021.
//

import Foundation

struct Face: Decodable {
  var confidence: Double?
  var box: Box?
  var attributes: [FaceAttributes]?
}
