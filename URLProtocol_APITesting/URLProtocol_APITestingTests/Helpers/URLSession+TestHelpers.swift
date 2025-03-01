//
//  URLSession+TestHelpers.swift
//  URLProtocol_APITestingTests
//
//  Created by Habibur Rahman on 1/3/25.
//

import Foundation

var mockSession: URLSession = {
    let configuration = URLSessionConfiguration.ephemeral
    configuration.protocolClasses = [MockURLProtocol.self]
    return URLSession(configuration: configuration)
}()


func getSuccessResponse(with url: URL) -> HTTPURLResponse {
    return HTTPURLResponse(
        url: url,
        statusCode: 200,
        httpVersion: nil,
        headerFields: nil
    )!
}

