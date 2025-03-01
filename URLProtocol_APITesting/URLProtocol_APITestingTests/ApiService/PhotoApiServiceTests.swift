//
//  PhotoApiServiceTests.swift
//  URLProtocol_APITestingTests
//
//  Created by Habibur Rahman on 1/3/25.
//

import XCTest
@testable import URLProtocol_APITesting

final class PhotoApiServiceTests: XCTestCase {

    
    lazy var api: MockPhotoAPIService = {
         let httpClient = URLSessionHTTPClient(session: mockSession)
        return MockPhotoAPIService(session: mockSession, url: dummyURL)
     }()

     override func tearDown() {
         MockURLProtocol.resetStub()
         super.tearDown()
     }


    
    let successResponse = getSuccessResponse(with: dummyURL)
    
    func test_GetPhotos_SuccessWithValidData () async throws {
       
        let mockData = validPhotoListJson.data(using: .utf8)!
        api.stub(response: successResponse, data: mockData, error: nil)
        let exp = expectation(description: "waiting for completion")
        
        let result = await api.getPhotos()
        exp.fulfill()
        await fulfillment(of: [exp], timeout: 1.0)
        
        XCTAssertEqual(result.data?.count ?? 0, 1)
        XCTAssertEqual(result.data?[0].id, "41")
    }
    
    func test_GetPhotos_FailedWithError () async throws {
       
        let mockData = validPhotoListJson.data(using: .utf8)!
        api.stub(response: successResponse, data: mockData, error: error)
        let exp = expectation(description: "waiting for completion")
        
        let result = await api.getPhotos()
        exp.fulfill()
        await fulfillment(of: [exp], timeout: 1.0)
        
        XCTAssertNil(result.data)
        XCTAssertNotNil(result.error)
    }
    
    func test_GetRecipes_SuccessWithValidEmptyData () async throws {
     
        let mockData = validEmptyPhotoListJson.data(using: .utf8)!
        api.stub(response: successResponse, data: mockData, error: nil)
        let exp = expectation(description: "waiting for completion")
        
        let result = await api.getPhotos()
        exp.fulfill()
        await fulfillment(of: [exp], timeout: 1.0)
        
        XCTAssertEqual(result.data?.count ?? 0, 0)
    }
    
    func test_GetRecipes_FailedWithMalformedData () async throws {
        let mockData = inValidPhotoListJson.data(using: .utf8)!
        api.stub(response: successResponse, data: mockData, error: nil)
        let exp = expectation(description: "waiting for completion")
        
        let result = await api.getPhotos()
        exp.fulfill()
        await fulfillment(of: [exp], timeout: 1.0)
        
        XCTAssertEqual(result.data?.count ?? 0, 0)
        XCTAssertNotNil(result.error)
    }
}
