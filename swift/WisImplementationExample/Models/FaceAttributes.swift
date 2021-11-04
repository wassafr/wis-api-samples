//
//  FaceAttributes.swift
//  WisImplementationExample
//
//  Created by Bertrand VILLAIN on 18/10/2021.
//

import Foundation

struct FaceAttributes: Decodable {
  var name: AttributeName?
  ///var value: String / Int?
  var confidence: Double?
}
