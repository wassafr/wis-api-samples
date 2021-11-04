//
//  AuthenticationTests.swift
//  WisImplementationExampleTests
//
//  Created by Bertrand VILLAIN on 20/10/2021.
//

import XCTest
@testable import WisImplementationExample

class AuthenticationTests: XCTestCase {

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

  func testLogin() throws {
    weak var exp = expectation(description: "Login failed ")
  
    service.login(clientId: <#client_id#>, secretId: <#secret_id#>) { result in
      switch result {
      case .success(let newToken):
        UserDefaults.standard.set(newToken.refreshToken, forKey: "RefreshToken")
        UserDefaults.standard.set(newToken.token, forKey: "Token")
        print("Token -> \"\(newToken.token)\" 🪙\nRefreshToken -> \"\(newToken.refreshToken)\" 🔄")
        usleep(100)
        XCTAssertNotNil(newToken)
      case .failure(let error):
        XCTFail("No token")
        print("Error: \(error.message) ‼️")
      }
      exp?.fulfill()
    }
    
    waitForExpectations(timeout: 5, handler: nil)
  }
  
  func testRefreshToken() throws {
    var exp = expectation(description: "Refresh failed")
    guard let token = self.token else {
      fatalError("Run testLogin before ☝️")
    }
    service.refreshToken(token: token) { result in
      switch result {
      case .success(let newToken):
        UserDefaults.standard.set(newToken.refreshToken, forKey: "RefreshToken")
        UserDefaults.standard.set(newToken.token, forKey: "Token")
        usleep(100)
        XCTAssertNotNil(newToken)
      case .failure(let error):
        XCTFail()
        print("Error: \(error.message) ‼️")
      }
      exp.fulfill()
    }
    
    waitForExpectations(timeout: 5, handler: nil)
  }
  
  func testLogout() throws {
    weak var exp = expectation(description: "Logout failed")
   guard let token = token else {
     fatalError("Run Test login first ☝️")
   }
    service.logout(token: token) { result in
      switch result {
      case .success(let newToken):
        XCTAssertNotNil(newToken)
      case .failure(let error):
        XCTFail()
        print("Error: \(error.message) ‼️")
      }
      exp?.fulfill()
    }
    
    waitForExpectations(timeout: 5, handler: nil)
  }
  
}
  
