//
//  MockPhotoAPIService.swift
//  URLProtocol_APITestingTests
//
//  Created by Habibur Rahman on 1/3/25.
//

@testable import URLProtocol_APITesting
import XCTest

class MockPhotoAPIService : PhotoAPIService {
    
    func stub(response: HTTPURLResponse?, data: Data?, error: Error?){
        MockURLProtocol.stubRequest(response: response, data: data, error: error)
    }
}

