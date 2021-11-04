//
//  IdentityTests.swift
//  WisImplementationExampleTests
//
//  Created by Bertrand VILLAIN on 20/10/2021.
//

import Foundation

import XCTest
@testable import WisImplementationExample

class IdentityTests: XCTestCase {

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
  
  
  // MARK: Identity 👤 ➡️ 👨🏻
  
  func testIdentity() throws {
    let exp = expectation(description: "FacesAttributesCreateJob failed")
    guard let token = token else {
      fatalError("Run Test login first ☝️")
    }
    
    service.identityCreateJob(token: token, images: [#imageLiteral(resourceName: "anonymization"), #imageLiteral(resourceName: "identity2")]) { result in
      switch result {
      case .success(let response):
        XCTAssertNotNil(response)
        print("Identity Job ID -> \(response) ✅")
        sleep(3)
        self.service.identityGetJobStatus(token: token, jobId: response) { result in
          switch result {
          case .success(let response):
            UserDefaults.standard.set(response.identityId, forKey: "identity_id")
            usleep(100)
            XCTAssertNotNil(response.identityId)
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
  

  /// Search

  func testIdentitySearch() throws {
    let exp = expectation(description: "IdentitySearchCreateJob failed")
    guard let token = token else {
      fatalError("Run Test login first ☝️")
    }
    
    let image = #imageLiteral(resourceName: "identity1")
    service.identitySearchCreateJob(token: token, image: image, maxResults: 2) { result in
      switch result {
      case .success(let response):
        XCTAssertNotNil(response)
        print("Identity Search Job ID -> \(response) ✅")
        sleep(3)

        self.service.identitySearchGetJobStatus(token: token, jobId: response) { result in
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
    
    waitForExpectations(timeout: 10, handler: nil)
  }
  
  
  /// Recognition

  func testIdentityRecognize() throws {
    let exp = expectation(description: "IdentitySearchCreateJob failed")
    guard let token = token else {
      fatalError("Run Test login first ☝️")
    }
    
    service.identityCreateJob(token: token, images: [#imageLiteral(resourceName: "anonymization"), #imageLiteral(resourceName: "identity2")]) { result in
      switch result {
      case .success(let response):
        XCTAssertNotNil(response)
        sleep(5)
        self.service.identityGetJobStatus(token: token, jobId: response) { result in
          switch result {
          case .success(let identityResponse):
            let image = #imageLiteral(resourceName: "identity1")
            XCTAssertNotNil(identityResponse.identityId)
            print("Identity ID -> \(identityResponse.identityId!) ✅")
            self.service.identityCreateRecognizeJob(token: token, image: image, identityId: identityResponse.identityId!) { result in
              switch result {
              case .success(let recognizeJobId):
                XCTAssertNotNil(recognizeJobId)
                print("Identity Recognize Job ID -> \(recognizeJobId) ✅")
                sleep(3)
                self.service.identityRecognizeGetJobStatus(token: token, jobId: recognizeJobId) { result in
                  switch result {
                  case .success(let response):
                    XCTAssertNotNil(response.results)
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
          case .failure(let error):
            XCTFail()
            print("Error: \(error.message) ‼️")
            exp.fulfill()
          }
        }
      case .failure(let error):
        XCTFail()
        print("Error: \(error.message) ‼️")
        exp.fulfill()
      }
    }
    
    waitForExpectations(timeout: 10, handler: nil)
  }
  
  func testIdentityCreateAddImageJob() throws {
    let exp = expectation(description: "IdentityCreateAddImageJob failed")
    guard let token = token else {
            fatalError("Run Test login first ☝️")
          }
    
    service.identityCreateJob(token: token, images: [#imageLiteral(resourceName: "anonymization"), #imageLiteral(resourceName: "identity2")]) { result in
      switch result {
      case .success(let response):
        XCTAssertNotNil(response)
        print("Identity Job ID -> \(response) ✅")
        sleep(3)
        self.service.identityGetJobStatus(token: token, jobId: response) { result in
          switch result {
          case .success(let identityResponse):
            XCTAssertNotNil(identityResponse.identityId)
            print("Identity ID -> \(identityResponse.identityId!) ✅")

            let image = #imageLiteral(resourceName: "identity1")
            self.service.identityCreateAddImageJob(token: token, images: [image], identityId: identityResponse.identityId!) { result in
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
      case .failure(let error):
        XCTFail()
        print("Error: \(error.message) ‼️")
        exp.fulfill()
      }
    }
    

    
    waitForExpectations(timeout: 8, handler: nil)
  }
  
  func testIdentityDeleteIdentities() throws {
    let exp = expectation(description: "IdentityDeleteIdentities failed")
    guard let token = token else {
      fatalError("Run Test login first ☝️")
    }
    
    
    service.identityCreateJob(token: token, images: [#imageLiteral(resourceName: "anonymization"), #imageLiteral(resourceName: "identity2")]) { result in
      switch result {
      case .success(let response):
        XCTAssertNotNil(response)
        print("Identity Job ID -> \(response) ✅")
        sleep(3)
        self.service.identityGetJobStatus(token: token, jobId: response) { result in
          switch result {
          case .success(let identityResponse):
            XCTAssertNotNil(identityResponse.identityId)
            print("Identity ID -> \(identityResponse.identityId!) ✅")

            self.service.identityDeleteIdentities(token: token, identityIds: [identityResponse.identityId!]) { result in
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
      case .failure(let error):
        XCTFail()
        print("Error: \(error.message) ‼️")
        exp.fulfill()
      }
    }
    
    waitForExpectations(timeout: 5, handler: nil)
  }
  
}
  
