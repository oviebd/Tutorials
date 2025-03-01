//
//  HTTPClient.swift
//  URLProtocol_APITesting
//
//  Created by Habibur Rahman on 1/3/25.
//

import Foundation


public protocol HTTPClient {
    typealias Result = Swift.Result<(data : Data, urlResponse : HTTPURLResponse),Error>
    func getAPIResponse(from url: URL) async -> HTTPClient.Result
}
