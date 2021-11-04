//
//  VehiclePedestrianDetectionRequests.swift
//  WisImplementationExample
//
//  Created by Bertrand VILLAIN on 19/10/2021.
//

import UIKit

extension WisService {
  
  ///This route will start a job to detect all pedestrians, bicycles, cars, trucks, busses, motorcycles present on image.
  ///Each result will be associated with coordinates on original image and accuracy.

  func vehiclePedestrianDetectionCreateJob(token: Token, image: UIImage, expectedClassNames: [VehicleType], detectionArea: [Point], completion: @escaping (Result<String, WisNetworkError>) -> Void) {
    
    let formData = NSMutableData()

    var request = URLRequest(url: URL(string: "\(serverUrl)/innovation-service/vehicles-pedestrians-detection")!, timeoutInterval: Double.infinity)
    let boundary = "Boundary-\(UUID().uuidString)"
    request.addValue("Bearer \(token.token)", forHTTPHeaderField: "Authorization")
    request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    
    if let pngData = image.pngData() {
      formData.append(self.convertFileData(fieldName: "input_media", fileName: "image.png", mimeType: "image/png", fileData: pngData, using: boundary))
    }
    formData.appendString(self.convertFormField(named: "expected_class_names", value: try! encoder.encode(expectedClassNames), using: boundary))
    formData.appendString(self.convertFormField(named: "detection_area", value: try! encoder.encode(detectionArea), using: boundary))

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
  ///In case of success, the response will contains a list of pedestrians and vehicles detected with their position on images and their accuracy score.
  func vehiclePedestrianDetectionGetJobStatus(token: Token, jobId: String, completion: @escaping (Result<DetectionResponse, WisNetworkError>) -> Void) {
    
    var url = URLComponents(string: "\(serverUrl)/innovation-service/vehicles-pedestrians-detection")!
    url.queryItems = [URLQueryItem(name: "vehicle_pedestrian_detection_job_id", value: jobId)]
    
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
        let value = try self.decoder.decode(DetectionResponse.self, from: data)
        completion(.success(value))        
      } catch let e {
        completion(.failure(WisNetworkError(from: data, response: response, error: e)))
      }
    }
    task.resume()
  }
  
}
