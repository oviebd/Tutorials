//
//  URLSessionHTTPClientTests.swift
//  URLProtocol_APITestingTests
//
//  Created by Habibur Rahman on 1/3/25.
//

import Foundation
@testable import URLProtocol_APITesting
import XCTest

final class URLSessionHTTPClientTests: XCTestCase {
  
    func test_GetResponse_SuccessWithSuccessResponse() async {
        let httpClient = makeSUT()
        let url = dummyURL
        let response = getSuccessResponse(with: url)
        MockURLProtocol.stubRequest(response: response, data: Data(), error: nil)

        let exp = expectation(description: "waiting for completion")
        let result = await httpClient.getAPIResponse(from: url)
        exp.fulfill()
        await fulfillment(of: [exp], timeout: 1.0)
        switch result {
        case let .success(data):
            XCTAssertNotNil(data)
        case .failure:
            XCTFail("Expected success insted get error")
        }
    }

    func test_GetResponse_FailedWithError() async {
        let httpClient = makeSUT()
        let url = dummyURL
        let response = getSuccessResponse(with: url)

        MockURLProtocol.stubRequest(response: response, data: Data(), error: error)
        let exp = expectation(description: "waiting for completion")
        let result = await httpClient.getAPIResponse(from: url)
        exp.fulfill()
        await fulfillment(of: [exp], timeout: 1.0)

        switch result {
        case let .success(data):
            XCTFail("Expected Failed insted get \(data)")
        case let .failure(fetchedError):
            XCTAssertEqual(error.domain, (fetchedError as NSError).domain)
            XCTAssertEqual(error.code, (fetchedError as NSError).code)
        }
    }

    func test_GetResponse_SuccessWithEmptyData() async {
        let httpClient = makeSUT()
        let url = dummyURL
        let response = getSuccessResponse(with: url)
        let exp = expectation(description: "waiting for completion")
        MockURLProtocol.stubRequest(response: response, data: nil, error: nil)

        let result = await httpClient.getAPIResponse(from: url)
        exp.fulfill()
        await fulfillment(of: [exp], timeout: 1.0)

        switch result {
        case let .success(data):
            XCTAssertEqual(data.data.count, 0)
        case .failure:
            XCTFail("Expected success insted get \(error)")
        }
    }

    // Helpers
    func makeSUT() -> HTTPClient {
        return URLSessionHTTPClient(session: mockSession)
    }
}
