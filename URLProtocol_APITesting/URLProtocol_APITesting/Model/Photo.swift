//
//  Photo.swift
//  URLProtocol_APITesting
//
//  Created by Habibur Rahman on 1/3/25.
//

import Foundation

class Photo: Codable {
    let id, author: String?
    let width, height: Int?
    let url, downloadURL: String?

    enum CodingKeys: String, CodingKey {
        case id, author, width, height, url
        case downloadURL = "download_url"
    }
}
