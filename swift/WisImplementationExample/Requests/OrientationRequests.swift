//
//  OrientationRequests.swift
//  WisImplementationExample
//
//  Created by Bertrand VILLAIN on 19/10/2021.
//

import UIKit

extension WisService {
  
  ///This route will start a detection of orientation from an image.
  func orientationCreateJob(token: Token, image: UIImage, completion: @escaping (Result<String, WisNetworkError>) -> Void) {
    
    let formData = NSMutableData()

    var request = URLRequest(url: URL(string: "\(serverUrl)/innovation-service/orientation")!, timeoutInterval: Double.infinity)
    let boundary = "Boundary-\(UUID().uuidString)"
    request.addValue("Bearer \(token.token)", forHTTPHeaderField: "Authorization")
    request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    
    if let pngData = image.pngData() {
      formData.append(self.convertFileData(fieldName: "input_media", fileName: "image.png", mimeType: "image/png", fileData: pngData, using: boundary))
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
  
  ///Get status of an orientation job. If succeeded, get the detected orientation with an accuracy score.
  func orientationGetJobStatus(token: Token, jobId: String, completion: @escaping (Result<OrientationResponse, WisNetworkError>) -> Void) {
    
    var url = URLComponents(string: "\(serverUrl)/innovation-service/orientation")!
    url.queryItems = [URLQueryItem(name: "orientation_job_id", value: jobId)]
    
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
        let value = try self.decoder.decode(OrientationResponse.self, from: data)
          completion(.success(value))
      } catch let e {
        completion(.failure(WisNetworkError.error(e)))
      }
    }
    task.resume()
  }
  
}
