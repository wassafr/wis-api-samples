//
//  WisService.swift
//  CoreMLModelTesting
//
//  Created by Bertrand VILLAIN on 18/10/2021.
//

import Foundation
#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

let serverUrl = "https://api.services.wassa.io"


class WisService {
  
  let encoder = JSONEncoder()
  let decoder = JSONDecoder()
  static var token: Token?
  
  init() {
    decoder.keyDecodingStrategy = .convertFromSnakeCase
  }
  
  // MARK: Recover file
  
  func retrieveFile(token: Token, fileName: String, completion: @escaping (Result<URL, WisNetworkError>) -> Void) {
    
    guard let url = URL(string: fileName) else {
      completion(.failure(WisNetworkError(statusCode: 0, message: "Incorrect filename url", error: "Incorrect filename url")))
      return
    }
    
    var request = URLRequest(url: url, timeoutInterval: Double.infinity)
    
    request.addValue("Bearer \(token.token)", forHTTPHeaderField: "Authorization")
    request.httpMethod = "GET"
        
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      
      guard let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode),
            let data = data else {
              completion(.failure(WisNetworkError(from: data, response: response, error: error)))
              return
            }
      
      let path = FileManager.default.urls(for: .documentDirectory,
                                             in: .userDomainMask)[0].appendingPathComponent("\(UUID().uuidString)")

      try? data.write(to: path)
      completion(.success(path))
    }
    task.resume()
  }

  
  // MARK: Utils methods
  
  func convertFileData(fieldName: String, fileName: String, mimeType: String, fileData: Data, using boundary: String) -> Data {
    let data = NSMutableData()
    
    data.appendString("--\(boundary)\r\n")
    data.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
    data.appendString("Content-Type: \(mimeType)\r\n\r\n")
    data.append(fileData)
    data.appendString("\r\n")

    return data as Data
  }
  
  func convertFormField(named name: String, value: Data, using boundary: String) -> String {
    var fieldString = "--\(boundary)\r\n"
    fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n"
    fieldString += "\r\n"
    fieldString += "\(String(data: value, encoding: .utf8)!)\r\n"

    return fieldString
  }
  
}
