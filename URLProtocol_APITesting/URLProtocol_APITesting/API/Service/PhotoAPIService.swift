//
//  PhotoAPIService.swift
//  URLProtocol_APITesting
//
//  Created by Habibur Rahman on 1/3/25.
//

import Foundation

class PhotoAPIService {
    
    private typealias GetPhotoAPIResponse = [Photo]
    typealias SingleFetchResult = (data: [Photo]?, error: Error?)

    let httpClient: HTTPClient
    let url: URL
   // let urlPath = "https://picsum.photos/v2/list?limit=50"

    init(session: URLSession, url : URL) {
        self.httpClient = URLSessionHTTPClient(session: session)
        self.url = url
    }

    func getPhotos() async -> SingleFetchResult {
        let result = await httpClient.getAPIResponse(from: url)

        switch result {
        case let .success(data):
            do {
                let photoList: GetPhotoAPIResponse = try JsonParser().parse(from: data.data)
                return (photoList, nil)

            } catch {
                return (nil, error)
            }
        case let .failure(error):
            return (nil, error)
        }
    }
}
