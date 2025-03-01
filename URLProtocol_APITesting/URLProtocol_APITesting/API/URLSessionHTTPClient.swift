//
//  URLSessionHTTPClient.swift
//  URLProtocol_APITesting
//
//  Created by Habibur Rahman on 1/3/25.
//

import Foundation

public class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession

    public init(session: URLSession) {
        self.session = session
    }

    struct UnexpectedValuesRepresentation: Error {}

    public func getAPIResponse(from url: URL) async -> HTTPClient.Result {
        do {
            let result = try await session.data(from: url)
            if let response = result.1 as? HTTPURLResponse {
                return .success((result.0, response))
            } else {
                return .failure(UnexpectedValuesRepresentation())
            }
        } catch {
            return .failure(error)
        }
    }
}
