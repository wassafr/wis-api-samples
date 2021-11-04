//
//  JobStatus.swift
//  WisImplementationExample
//
//  Created by Bertrand VILLAIN on 18/10/2021.
//

import Foundation

enum JobStatus: String, Codable {
  
  case unknown = "Unknown Status"
  case sent = "Sent"
  case started = "Started"
  case succeeded = "Succeeded"
  case failed = "Failed"
  case retrieved = "Retrieved"
  case revoked = "Revoked"

  init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    let rawValue = try container.decode(String.self)
    guard let state = JobStatus(rawValue: rawValue) else { throw WisNetworkError.errorParsingJSON("JobStatus") }
    self = state
  }
  
}
