//
//  OAuthTokenResponseBodyModel.swift
//  ImageFeed
//
//  Created by Vitaly Alekseev on 02.06.2023.
//

import Foundation


struct OAuthTokenResponseBody: Codable  {
    var accessToken: String
    var tokenType: String
    var scope: String
    var createdAt: Int64
}

