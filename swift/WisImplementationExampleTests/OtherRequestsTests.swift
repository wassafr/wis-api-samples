//
//  WisImplementationExampleTests.swift
//  WisImplementationExampleTests
//
//  Created by Bertrand VILLAIN on 19/10/2021.
//

import XCTest
@testable import WisImplementationExample

class WisImplementationExampleTests: XCTestCase {

  let service = WisService()
  var token: Token?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
      guard let token = UserDefaults.standard.string(forKey: "Token"),
            let refreshToken = UserDefaults.standard.string(forKey: "RefreshToken") else { return }
      self.token = Token(token: token, expireTime: 3600, refreshToken: refreshToken)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
  
  // MARK: Congestion 🚘
  
  func testCongestion() throws {
    let exp = expectation(description: "Refresh failed")
    guard let token = token else {
      fatalError("Run Test login first ☝️")
    }
    let image = #imageLiteral(resourceName: "congestion")
    service.congestionCreateJob(token: token, image: image, congestionLine: [Point(x: 0, y: 0), Point(x: 1, y: 1)]) { result in
      switch result {
      case .success(let response):
        print("Congestion Job ID -> \(response) ✅")
        sleep(3)
        self.service.congestionGetJobStatus(token: token, jobId: response) { result in
          switch result {
          case .success(let response):
            XCTAssertNotNil(response)
          case .failure(let error):
            XCTFail()
            print("Error: \(error.message) ‼️")
          }
          exp.fulfill()
        }
        XCTAssertNotNil(response)
      case .failure(let error):
        XCTFail()
        print("Error: \(error.message) ‼️")
        exp.fulfill()
      }
    }
    
    waitForExpectations(timeout: 5, handler: nil)
  }
  
  // MARK: Soiling 🛣
  
  func testSoiling() throws {
    let exp = expectation(description: "Soiling failed")
    guard let token = token else {
      fatalError("Run Test login first ☝️")
    }
    let image = #imageLiteral(resourceName: "congestion")
    service.soilingCreateJob(token: token, image: image, soilingArea: [Point(x: 0, y: 0), Point(x: 1, y: 1), Point(x: 2, y: 2)]) { result in
      switch result {
      case .success(let response):
        print("Soiling Job ID -> \(response) ✅")
        sleep(3)
        self.service.soilingGetJobStatus(token: token, jobId: response) { result in
          switch result {
          case .success(let response):
            XCTAssertNotNil(response)
          case .failure(let error):
            XCTFail()
            print("Error: \(error.message) ‼️")
          }
          exp.fulfill()
        }
        
        XCTAssertNotNil(response)
      case .failure(let error):
        XCTFail()
        print("Error: \(error.message) ‼️")
        exp.fulfill()
      }
    }
    
    waitForExpectations(timeout: 5, handler: nil)
  }

  
  // MARK: Anonymization 👤
  
  func testAnonymization() throws {
    let exp = expectation(description: "Anonymization failed")
    guard let token = token else {
      fatalError("Run Test login first ☝️")
    }
    let image = #imageLiteral(resourceName: "input_media")
    service.anonymizationCreateJob(token: token, image: image, activationBlurFaces: true, outputDetections: true, includedArea: nil) { result in
      switch result {
      case .success(let response):
        print("Anonymization Job ID -> \(response) ✅")
        sleep(3)
        self.service.anonymizationGetJobStatus(token: token, jobId: response) { result in
          switch result {
          case .success(let response):
            XCTAssertNotNil(response.outputJson)
            XCTAssertNotNil(response.outputMedia)
            UserDefaults.standard.set(response.outputJson!, forKey: "anonymization_output_media")
            print("\(response.outputJson!) 📁")
            usleep(100)
          case .failure(let error):
            XCTFail()
            print("Error: \(error.message) ‼️")
          }
          exp.fulfill()
        }
      case .failure(let error):
        XCTFail()
        print("Error: \(error.message) ‼️")
        exp.fulfill()
      }
    }
    
    waitForExpectations(timeout: 5, handler: nil)
  }
  
  // MARK: Watermark 🌆
  
  func testWatermark() throws {
    let exp = expectation(description: "WatermarkCreateJob failed")
    guard let token = token else {
      fatalError("Run Test login first ☝️")
    }
    let image = #imageLiteral(resourceName: "input_media")
    let watermarkImage = #imageLiteral(resourceName: "input_watermark")
    service.watermarkCreateJob(token: token, inputImage: image, watermarkImage: watermarkImage, transparency: 0.5, ratio: 1, positionPreset: .upperRight) { result in
      switch result {
      case .success(let response):
        print("Watermark Job ID -> \(response) ✅")
        sleep(4)
        self.service.watermarkGetJobStatus(token: token, jobId: response) { result in
          switch result {
          case .success(let response):
            XCTAssertNotNil(response.outputImageUrl)
          case .failure(let error):
            XCTFail()
            print("Error: \(error.message) ‼️")
          }
          exp.fulfill()
        }
      case .failure(let error):
        XCTFail()
        print("Error: \(error.message) ‼️")
        exp.fulfill()
      }
    }
    
    waitForExpectations(timeout: 6, handler: nil)
  }
  
  
  // MARK: Detection 🚲 🚶🏻‍♂️
  
  func testDetection() throws {
    let exp = expectation(description: "DetectionCreateJob failed")
    guard let token = token else {
      fatalError("Run Test login first ☝️")
    }
    let image = #imageLiteral(resourceName: "VAP")
    service.vehiclePedestrianDetectionCreateJob(token: token, image: image, expectedClassNames: [.pedestrian, .car]
                               , detectionArea: [Point(x: 0, y: 0), Point(x: 0.3, y: 0.3), Point(x: 0.9, y: 0.9)]) { result in
      switch result {
      case .success(let response):
        print("Detection Job ID -> \(response) ✅")
        sleep(3)
        self.service.vehiclePedestrianDetectionGetJobStatus(token: token, jobId: response) { result in
          switch result {
          case .success(let response):
            XCTAssertNotNil(response.objectCounting)
          case .failure(let error):
            XCTFail()
            print("Error: \(error.message) ‼️")
          }
          exp.fulfill()
        }
      case .failure(let error):
        XCTFail()
        print("Error: \(error.message) ‼️")
        exp.fulfill()
      }
    }
    
    waitForExpectations(timeout: 5, handler: nil)
  }
  
  
  // MARK: Orientation
  
  func testOrientation() throws {
    let exp = expectation(description: "OrientationCreateJob failed")
    guard let token = token else {
      fatalError("Run Test login first ☝️")
    }
    let image = #imageLiteral(resourceName: "VAP")
    service.orientationCreateJob(token: token, image: image) { result in
      switch result {
      case .success(let response):
        print("Detection Job ID -> \(response) ✅")
        sleep(3)
        self.service.orientationGetJobStatus(token: token, jobId: response) { result in
          switch result {
          case .success(let orientationResponse):
            XCTAssertNotNil(orientationResponse.label)
          case .failure(let error):
            XCTFail()
            print("Error: \(error.message) ‼️")
          }
          exp.fulfill()
        }
      case .failure(let error):
        XCTFail()
        print("Error: \(error.message) ‼️")
        exp.fulfill()
      }
    }
    
    waitForExpectations(timeout: 5, handler: nil)
  }
  
  // MARK: Faces Attributes
  
  func testFacesAttributes() throws {
    let exp = expectation(description: "FacesAttributesCreateJob failed")
    guard let token = token else {
      fatalError("Run Test login first ☝️")
    }
    let image = #imageLiteral(resourceName: "faces_attributes")
    service.facesAttributesCreateJob(token: token, image: image) { result in
      switch result {
      case .success(let response):
        print("Faces Attributes Job ID -> \(response) ✅")
        sleep(3)
        self.service.facesAttributesGetJobStatus(token: token, jobId: response) { result in
          switch result {
          case .success(let response):
            XCTAssertNotNil(response)
          case .failure(let error):
            XCTFail()
            print("Error: \(error.message) ‼️")
          }
          exp.fulfill()
        }
      case .failure(let error):
        XCTFail()
        print("Error: \(error.message) ‼️")
        exp.fulfill()
      }
    }
    
    waitForExpectations(timeout: 5, handler: nil)
  }

  
  // MARK: Retrieve file result
  
  func testRetrieveFileResult() throws {
    let exp = expectation(description: "RetrieveFileResult failed")
    guard let token = token,
    let outputMediaUrl = UserDefaults.standard.string(forKey: "anonymization_output_media") else {
      fatalError("Run Test login first and Congestion Test to get a file url to retrieve ☝️")
    }
    
    service.retrieveFile(token: token, fileName: outputMediaUrl) { result in
      switch result {
      case .success(let response):
        XCTAssertNotNil(response)
      case .failure(let error):
        XCTFail()
        print("Error: \(error.message) ‼️")
      }
      exp.fulfill()
    }
    
    waitForExpectations(timeout: 5, handler: nil)
  }
  
}
  
