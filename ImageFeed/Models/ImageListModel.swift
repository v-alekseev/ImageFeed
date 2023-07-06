//
//  ImageListModel.swift
//  ImageFeed
//
//  Created by Vitaly Alekseev on 27.06.2023.
//

import Foundation
import CoreGraphics

struct LikeResult: Codable {
    var photo: PhotoResult
}

struct PhotoResult: Codable {
    var id: String
    var width: Int
    var height: Int
    var createdAt: Date?
    var description: String?
    var likes: Int
    var likedByUser: Bool
    var urls: UrlsResult
}

struct UrlsResult: Codable {
    var full: URL
    var thumb: URL
}

