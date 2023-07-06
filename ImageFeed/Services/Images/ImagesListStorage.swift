//
//  ImagesListStorage.swift
//  ImageFeed
//
//  Created by Vitaly Alekseev on 27.06.2023.
//

import Foundation
import CoreGraphics

class Photo {
    
    private (set) var id: String
    private (set) var size: CGSize
    private (set) var createdAt: Date?
    private (set) var welcomeDescription: String?
    private (set) var thumbImageURL: URL
    private (set) var largeImageURL: URL
    private (set) var isLiked: Bool
    
    init(_ data: PhotoResult) {
        self.id = data.id
        self.size = CGSize(width: data.width, height: data.height)
        self.createdAt = data.createdAt
        self.welcomeDescription = data.description
        self.thumbImageURL = data.urls.thumb
        self.largeImageURL = data.urls.full
        self.isLiked = data.likedByUser
    }
    
}
