//
//  ProfileImageServiceModel.swift
//  ImageFeed
//
//  Created by Vitaly Alekseev on 20.06.2023.
//

import Foundation

struct UserResult: Codable {
    var profileImage: ProfileImage
}

struct ProfileImage: Codable{
    var small: String
}
