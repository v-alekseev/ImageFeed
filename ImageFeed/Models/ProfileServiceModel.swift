//
//  ProfileServiceModel.swift
//  ImageFeed
//
//  Created by Vitaly Alekseev on 18.06.2023.
//

import Foundation


struct ProfileResult: Codable {
    var username: String?
    var firstName: String?
    var lastName: String?
    var bio: String?
}
