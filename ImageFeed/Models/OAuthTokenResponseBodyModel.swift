//
//  OAuthTokenResponseBodyModel.swift
//  ImageFeed
//
//  Created by Vitaly Alekseev on 02.06.2023.
//

import Foundation


struct OAuthTokenResponseBody: Codable  {
    var access_token: String
    var token_type: String
    var refresh_token: String
    var scope: String
    var created_at: Int64
}

