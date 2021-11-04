//
//  CongestionRequests.swift
//  WisImplementationExample
//
//  Created by Bertrand VILLAIN on 19/10/2021.
//

import Foundation
import UIKit

extension WisService {
  
  ///This route will create a congestion detection job.
  func congestionCreateJob(token: Token, image: UIImage, congestionLine: [Point], completion: @escaping (Result<String, WisNetworkError>) -> Void) {
    
    let formData = NSMutableData()
    
    var request = URLRequest(url: URL(string: "\(serverUrl)/innovation-service/congestion")!, timeoutInterval: Double.infinity)
    let boundary = "Boundary-\(UUID().uuidString)"
    request.addValue("Bearer \(token.token)", forHTTPHeaderField: "Authorization")
    request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    
    if let pngData = image.pngData() {
      formData.append(self.convertFileData(fieldName: "picture", fileName: "image.png", mimeType: "image/png", fileData: pngData, using: boundary))
    }
    if let congestionData = try? encoder.encode(congestionLine) {
      formData.appendString(self.convertFormField(named: "congestion_line", value: congestionData, using: boundary))
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
  
  ///Returns the job status.
  ///In case of success response will contains a list of detected vehicles.
  func congestionGetJobStatus(token: Token, jobId: String, completion: @escaping (Result<VehicleResponse, WisNetworkError>) -> Void) {
    
    var url = URLComponents(string: "\(serverUrl)/innovation-service/congestion")!
    url.queryItems = [URLQueryItem(name: "congestion_job_id", value: jobId)]
    
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
        let value = try self.decoder.decode(VehicleResponse.self, from: data)
        completion(.success(value))
      } catch let e {
        completion(.failure(WisNetworkError.error(e)))
      }
    }
    task.resume()
  }
  
}
