//
//  WisNetworkError.swift
//  CoreMLModelTesting
//
//  Created by Bertrand VILLAIN on 18/10/2021.
//

import Foundation

struct WisNetworkError: Error, Decodable {
  
  let statusCode: Int
  let message: String
  let error: String
  
  internal init(statusCode: Int, message: String, error: String) {
    self.statusCode = statusCode
    self.message = message
    self.error = error
  }
  
  static func errorParsingJSON(_ field: String) -> WisNetworkError {
    return WisNetworkError(statusCode: 0, message: "Unable to deserialize the field: \(field)", error: "")
  }
  
  static func error(_ error: Error?) -> WisNetworkError {
    if let error = error as? WisNetworkError {
      return error
    } else {
      return WisNetworkError(statusCode: 0, message: error?.localizedDescription ?? "An unkown error occured", error: "Unknown error")
    }
  }
  
  init(from data: Data?, response: URLResponse?, error: Error?) {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    
    if let data = data,
       let error = try? decoder.decode(WisNetworkError.self, from: data) {
      self = error
    } else if let response = response as? HTTPURLResponse {
      self = WisNetworkError(statusCode: response.statusCode, message: response.description, error: "")
    } else {
      self = WisNetworkError(statusCode: 0, message: "An unkown error occured", error: "Unknown error")
    }
  }
  
}
