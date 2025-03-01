//
//  MockURLProtocol.swift
//  URLProtocol_APITestingTests
//
//  Created by Habibur Rahman on 1/3/25.
//

import Foundation

class MockURLProtocol: URLProtocol {
    static var responseData: Data?
    static var response: URLResponse?
    static var error: Error?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    static func resetStub() {
        self.responseData = nil
        self.response = nil
        self.error = nil
    }

    static func stubRequest(response: HTTPURLResponse?, data: Data?, error: Error?) {
        self.responseData = data
        self.response = response
        self.error = error
    }

    override func startLoading() {
        
        if let error = MockURLProtocol.error {
            client?.urlProtocol(self, didFailWithError: error)
        } else {
            if let response = MockURLProtocol.response {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            if let data = MockURLProtocol.responseData {
                client?.urlProtocol(self, didLoad: data)
            }
            else{
                client?.urlProtocol(self, didLoad: Data())
            }
            client?.urlProtocolDidFinishLoading(self)
        }
    }

    override func stopLoading() {}
}
