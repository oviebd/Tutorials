//
//  Constants.swift
//  URLProtocol_APITestingTests
//
//  Created by Habibur Rahman on 1/3/25.
//

import Foundation

let dummyURL = URL(string: "https://www.dummyUrl.com")!
let error = NSError(domain: "Error", code: 0)


let validPhotoListJson = """
    [
        {
            "id": "41",
            "author": "Nithya Ramanujam",
            "width": 1280,
            "height": 805,
            "url": "https://unsplash.com/photos/fTKetYpEKNQ",
            "download_url": "https://picsum.photos/id/41/1280/805"
        }
    ]
"""

let validEmptyPhotoListJson = """
    [ ]
"""

//Make Id string to Int and width int t string
let inValidPhotoListJson = """
    [
        {
            "id": 41,
            "author": "Nithya Ramanujam",
            "width": "1280",
            "height": 805,
            "url": "https://unsplash.com/photos/fTKetYpEKNQ",
            "download_url": "https://picsum.photos/id/41/1280/805"
        }
    ]
"""
