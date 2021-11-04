//
//  IdentityRequests.swift
//  WisImplementationExample
//
//  Created by Bertrand VILLAIN on 19/10/2021.
//

import UIKit

extension WisService {
  
  //MARK: Identity
  
  ///This route will start a job that will process a maximum of 5 input_images,
  ///create associated vectors and register an identity if success.
  func identityCreateJob(token: Token, images: [UIImage], completion: @escaping (Result<String, WisNetworkError>) -> Void) {
    
    let formData = NSMutableData()

    var request = URLRequest(url: URL(string: "\(serverUrl)/innovation-service/identity")!, timeoutInterval: Double.infinity)
    let boundary = "Boundary-\(UUID().uuidString)"
    request.addValue("Bearer \(token.token)", forHTTPHeaderField: "Authorization")
    request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    
    images.forEach { image in
      if let pngData = image.pngData() {
        formData.append(self.convertFileData(fieldName: "input_images", fileName: "image.png", mimeType: "image/png", fileData: pngData, using: boundary))
      }
    }

    formData.appendString("--\(boundary)--\r\n")
    request.httpBody = formData as Data
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      
      guard let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode),
            let data = data else {
              completion(.failure(WisNetworkError(from: data, response: response, error: error)))
              return
            }
      
      do {
        let value = try self.decoder.decode([String: String].self, from: data)
        let jobId = value.values.first!
          completion(.success(jobId))
      } catch let e {
        completion(.failure(WisNetworkError.error(e)))
      }
    }
    task.resume()
  }
  
  ///Return the job status.
  ///In case of success the response will contain a list of detected faces and their atributes.
  func identityGetJobStatus(token: Token, jobId: String, completion: @escaping (Result<IdentityResponse, WisNetworkError>) -> Void) {
    
    var url = URLComponents(string: "\(serverUrl)/innovation-service/identity")!
    url.queryItems = [URLQueryItem(name: "job_id", value: jobId)]
    
    var request = URLRequest(url: url.url!, timeoutInterval: Double.infinity)
    
    request.addValue("Bearer \(token.token)", forHTTPHeaderField: "Authorization")
    request.httpMethod = "GET"
        
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      
      guard let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode),
            let datat = data else {
              completion(.failure(WisNetworkError(from: data, response: response, error: error)))
              return
            }
      
      do {
        let value = try self.decoder.decode(IdentityResponse.self, from: datat)
          completion(.success(value))
      } catch let e {
        completion(.failure(WisNetworkError.error(e)))
      }
    }
    task.resume()
  }
  
  //MARK: Identity Search
  
  ///This route will start a search job. The search job will search in all known identities to match the input_image.
  ///Result can be 0, 1 or any other matching identities.
  ///Results are sorted by their trust score.
  func identitySearchCreateJob(token: Token, image: UIImage, maxResults: Int, completion: @escaping (Result<String, WisNetworkError>) -> Void) {
    
    let formData = NSMutableData()

    var request = URLRequest(url: URL(string: "\(serverUrl)/innovation-service/identity/search")!, timeoutInterval: Double.infinity)
    let boundary = "Boundary-\(UUID().uuidString)"
    request.addValue("Bearer \(token.token)", forHTTPHeaderField: "Authorization")
    request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    
    if let pngData = image.pngData() {
      formData.append(self.convertFileData(fieldName: "input_image", fileName: "image.png", mimeType: "image/png", fileData: pngData, using: boundary))
    }

    formData.appendString(self.convertFormField(named: "max_result", value: try! encoder.encode(maxResults), using: boundary))

    formData.appendString("--\(boundary)--\r\n")
    request.httpBody = formData as Data
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      
      guard let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode),
            let data = data else {
              completion(.failure(WisNetworkError(from: data, response: response, error: error)))
              return
            }
      
      do {
        let value = try self.decoder.decode([String: String].self, from: data)
        let jobId = value.values.first!
          completion(.success(jobId))
      } catch let e {
        completion(.failure(WisNetworkError.error(e)))
      }
    }
    task.resume()
  }
  
  ///If case of success, returns a list of identity ids and trust score sorted by score. Only scores above 0.85 will be returned.
  func identitySearchGetJobStatus(token: Token, jobId: String, completion: @escaping (Result<IdentitySearchResponse, WisNetworkError>) -> Void) {
    
    var url = URLComponents(string: "\(serverUrl)/innovation-service/identity/search")!
    url.queryItems = [URLQueryItem(name: "job_id", value: jobId)]
    
    var request = URLRequest(url: url.url!, timeoutInterval: Double.infinity)
    
    request.addValue("Bearer \(token.token)", forHTTPHeaderField: "Authorization")
    request.httpMethod = "GET"
        
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      
      guard let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode),
            let data = data else {
              completion(.failure(WisNetworkError(from: data, response: response, error: error)))
              return
            }
      
      do {
        let value = try self.decoder.decode(IdentitySearchResponse.self, from: data)
          completion(.success(value))
      } catch let e {
        completion(.failure(WisNetworkError.error(e)))
      }
    }
    task.resume()
  }
  
  //MARK: Identity Recognition
  
  ///This route will start a recognize job. This job will confirm if the input image is matching the input identity_id.
  func identityCreateRecognizeJob(token: Token, image: UIImage, identityId: String, completion: @escaping (Result<String, WisNetworkError>) -> Void) {
    
    let formData = NSMutableData()

    var request = URLRequest(url: URL(string: "\(serverUrl)/innovation-service/identity/recognize")!, timeoutInterval: Double.infinity)
    let boundary = "Boundary-\(UUID().uuidString)"
    request.addValue("Bearer \(token.token)", forHTTPHeaderField: "Authorization")
    request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    
      if let pngData = image.pngData() {
        formData.append(self.convertFileData(fieldName: "input_image", fileName: "image.png", mimeType: "image/png", fileData: pngData, using: boundary))
      }
    formData.appendString(self.convertFormField(named: "identity_id", value: identityId.data(using: .utf8)!, using: boundary))

    formData.appendString("--\(boundary)--\r\n")
    request.httpBody = formData as Data
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      
      guard let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode),
            let data = data else {
              completion(.failure(WisNetworkError(from: data, response: response, error: error)))
              return
            }
      
      do {
        let value = try self.decoder.decode([String: String].self, from: data)
        let jobId = value.values.first!
          completion(.success(jobId))
      } catch let e {
        completion(.failure(WisNetworkError.error(e)))
      }
    }
    task.resume()
  }
  
  ///In case of success, returns an identity_id, a score of comparison and a confirmation boolean.
  ///This confirmation boolean will be true if the score is above or equal 0.95 and false if the score is under 0.95.
  func identityRecognizeGetJobStatus(token: Token, jobId: String, completion: @escaping (Result<IdentityRecognizeResponse, WisNetworkError>) -> Void) {
    
    var url = URLComponents(string: "\(serverUrl)/innovation-service/identity/recognize")!
    url.queryItems = [URLQueryItem(name: "job_id", value: jobId)]
    
    var request = URLRequest(url: url.url!, timeoutInterval: Double.infinity)
    
    request.addValue("Bearer \(token.token)", forHTTPHeaderField: "Authorization")
    request.httpMethod = "GET"
        
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      
      guard let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode),
            let data = data else {
              completion(.failure(WisNetworkError(from: data, response: response, error: error)))
              return
            }
      
      do {
        let value = try self.decoder.decode(IdentityRecognizeResponse.self, from: data)
          completion(.success(value))
      } catch let e {
        completion(.failure(WisNetworkError.error(e)))
      }
    }
    task.resume()
  }
  
  ///This route will start a job that will process a maximum of 5 input_images, create associated vectors for a specified identity_id.
  func identityCreateAddImageJob(token: Token, images: [UIImage], identityId: String, completion: @escaping (Result<String, WisNetworkError>) -> Void) {
    
    let formData = NSMutableData()

    var request = URLRequest(url: URL(string: "\(serverUrl)/innovation-service/identity")!, timeoutInterval: Double.infinity)
    let boundary = "Boundary-\(UUID().uuidString)"
    request.addValue("Bearer \(token.token)", forHTTPHeaderField: "Authorization")
    request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "PUT"
    
    images.forEach { image in
      if let pngData = image.pngData() {
        formData.append(self.convertFileData(fieldName: "input_images", fileName: "image.png", mimeType: "image/png", fileData: pngData, using: boundary))
      }
    }
    formData.appendString(self.convertFormField(named: "identity_id", value: identityId.data(using: .utf8)!, using: boundary))

    formData.appendString("--\(boundary)--\r\n")
    request.httpBody = formData as Data
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      
      guard let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode),
            let data = data else {
              completion(.failure(WisNetworkError(from: data, response: response, error: error)))
              return
            }
      
      do {
        let value = try self.decoder.decode([String: String].self, from: data)
        let jobId = value.values.first!
          completion(.success(jobId))
      } catch let e {
        completion(.failure(WisNetworkError.error(e)))
      }
    }
    task.resume()
  }

  ///Delete an identity on server from a given identity_id.
  func identityDeleteIdentities(token: Token, identityIds: [String], completion: @escaping (Result<Void, WisNetworkError>) -> Void) {
    
    let parameters: [String: [String]] = ["identity_id": identityIds]
    let url = URLComponents(string: "\(serverUrl)/innovation-service/identity")!
    
    var request = URLRequest(url: url.url!, timeoutInterval: Double.infinity)
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("Bearer \(token.token)", forHTTPHeaderField: "Authorization")
    request.httpMethod = "DELETE"
    
    let encoder = JSONEncoder()
    
    request.httpBody = try? encoder.encode(parameters)
    
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
