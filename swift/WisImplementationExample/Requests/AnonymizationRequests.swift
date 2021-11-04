//
//  AnonymizationRequests.swift
//  WisImplementationExample
//
//  Created by Bertrand VILLAIN on 19/10/2021.
//

import UIKit

extension WisService {
  
  ///This route will create a job for bluring faces and/or plates of an image.
  func anonymizationCreateJob(token: Token, image: UIImage, activationBlurFaces: Bool = true, outputDetections: Bool, includedArea: Box?, completion: @escaping (Result<String, WisNetworkError>) -> Void) {
    
    let formData = NSMutableData()

    var request = URLRequest(url: URL(string: "\(serverUrl)/innovation-service/anonymization")!, timeoutInterval: Double.infinity)
    let boundary = "Boundary-\(UUID().uuidString)"
    request.addValue("Bearer \(token.token)", forHTTPHeaderField: "Authorization")
    request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    
    if let pngData = image.pngData() {
      formData.append(self.convertFileData(fieldName: "input_media", fileName: "image.png", mimeType: "image/png", fileData: pngData, using: boundary))
    }
    if let area = includedArea,
      let includedAreaData = try? encoder.encode(area) {
      formData.appendString(self.convertFormField(named: "included_area", value: includedAreaData, using: boundary))
    }
    if let value = try? encoder.encode(activationBlurFaces) {
      formData.appendString(self.convertFormField(named: "activation_faces_blur", value: value, using: boundary))
    }
    if let value = try? encoder.encode(outputDetections) {
      formData.appendString(self.convertFormField(named: "output_detections_url", value: value, using: boundary))
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
  ///In case of success response will contains an url to an image `output_image_url`.
  ///This image need to be retrieve with /innovation-service/result/{fileName}
  func anonymizationGetJobStatus(token: Token, jobId: String, completion: @escaping (Result<AnonymizationResponse, WisNetworkError>) -> Void) {
    
    var url = URLComponents(string: "\(serverUrl)/innovation-service/anonymization")!
    url.queryItems = [URLQueryItem(name: "anonymization_job_id", value: jobId)]
    
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
        let value = try self.decoder.decode(AnonymizationResponse.self, from: data)
          completion(.success(value))
      } catch let e {
        completion(.failure(WisNetworkError.error(e)))
      }
    }
    task.resume()
  }
  
}
