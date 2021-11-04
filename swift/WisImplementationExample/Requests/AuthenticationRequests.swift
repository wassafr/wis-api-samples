//
//  AuthenticationRequests.swift
//  WisImplementationExample
//
//  Created by Bertrand VILLAIN on 20/10/2021.
//

import Foundation

extension WisService {
  
  ///Login to Wassa Innovation Services API.
  ///You will retrieve a token that need to be use in all other routes.
  func login(clientId: String, secretId: String, completion: @escaping (Result<Token, WisNetworkError>) -> Void) {
    
    let parameters: [String: String] = ["clientId": clientId, "secretId": secretId]
    
    var request = URLRequest(url: URL(string: "\(serverUrl)/login")!, timeoutInterval: Double.infinity)
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    
    let encoder = JSONEncoder()
    
    request.httpBody = try? encoder.encode(parameters)
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      
      guard let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode),
            let data = data else {
              completion(.failure(WisNetworkError(from: data, response: response, error: error)))
              return
            }
      
      do {
        let token = try self.decoder.decode(Token.self, from: data)
          completion(.success(token))
      } catch let e {
        completion(.failure(WisNetworkError.error(e)))
      }
    }
    task.resume()
  }
  
  ///Refresh the access token of a User
  ///The Bearer token can be expired.
  ///Notice that you should pass token (even expired) in the authentication process as a bearer token, as any other routes.
  func refreshToken(token: Token, completion: @escaping (Result<Token, WisNetworkError>) -> Void) {
    
    let parameters: [String: String] = ["refreshToken": token.refreshToken]

    var request = URLRequest(url: URL(string: "\(serverUrl)/token")!, timeoutInterval: Double.infinity)
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("Bearer \(token.token)", forHTTPHeaderField: "Authorization")
    request.httpMethod = "POST"
    
    let encoder = JSONEncoder()
    
    request.httpBody = try? encoder.encode(parameters)
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      
      guard let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode),
            let data = data else {
              completion(.failure(WisNetworkError(from: data, response: response, error: error)))
              return
            }
      
      do {
        let token = try self.decoder.decode(Token.self, from: data)
          completion(.success(token))
      } catch let e {
        completion(.failure(WisNetworkError.error(e)))
      }
    }
    task.resume()
  }
  
  ///Close session from WIS, and invalidate token.
  ///If not used, session will close after the timeout returned by login.
  ///Notice that you should pass token (even expired) in the authentication process as a bearer token, as any other routes.
  func logout(token: Token, completion: @escaping (Result<Void, WisNetworkError>) -> Void) {
    
    var request = URLRequest(url: URL(string: "\(serverUrl)/logout")!, timeoutInterval: Double.infinity)
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("Bearer \(token.token)", forHTTPHeaderField: "Authorization")
    request.httpMethod = "POST"
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      
      guard let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode) else {
              completion(.failure(WisNetworkError(from: data, response: response, error: error)))
              return
            }
      
      completion(.success(Void()))
      
    }
    task.resume()
  }
  
}
