//
//  WatermarkRequests.swift
//  WisImplementationExample
//
//  Created by Bertrand VILLAIN on 19/10/2021.
//

import UIKit

extension WisService {
  
  ///This route will create a job for overlay an image (watermark) over another image (input media),
  ///with a few customisation parameters. 
  func watermarkCreateJob(token: Token, inputImage: UIImage, watermarkImage: UIImage, transparency: Double, ratio: Double, positionPreset: PositionPreset, completion: @escaping (Result<String, WisNetworkError>) -> Void) {
    
    let formData = NSMutableData()

    var request = URLRequest(url: URL(string: "\(serverUrl)/innovation-service/watermark")!, timeoutInterval: Double.infinity)
    let boundary = "Boundary-\(UUID().uuidString)"
    request.addValue("Bearer \(token.token)", forHTTPHeaderField: "Authorization")
    request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    
    if let inputPngData = inputImage.pngData(),
       let watermarkPngData = watermarkImage.pngData() {
      formData.append(self.convertFileData(fieldName: "input_media", fileName: "image.png", mimeType: "image/png", fileData: inputPngData, using: boundary))
      formData.append(self.convertFileData(fieldName: "input_watermark", fileName: "watermark.png", mimeType: "image/png", fileData: watermarkPngData, using: boundary))
    }
    formData.appendString(self.convertFormField(named: "watermark_transparency", value: try! encoder.encode(transparency), using: boundary))
    formData.appendString(self.convertFormField(named: "watermark_ratio", value: try! encoder.encode(ratio), using: boundary))
    formData.appendString(self.convertFormField(named: "watermark_position_preset", value: positionPreset.rawValue.data(using: .utf8)!, using: boundary))

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
  ///This image needs to be retrieved with /innovation-service/result/{fileName}
  func watermarkGetJobStatus(token: Token, jobId: String, completion: @escaping (Result<WatermarkResponse, WisNetworkError>) -> Void) {
    
    var url = URLComponents(string: "\(serverUrl)/innovation-service/watermark")!
    url.queryItems = [URLQueryItem(name: "watermark_job_id", value: jobId)]
    
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
        let value = try self.decoder.decode(WatermarkResponse.self, from: data)
          completion(.success(value))
      } catch let e {
        completion(.failure(WisNetworkError.error(e)))
      }
    }
    task.resume()
  }

}

