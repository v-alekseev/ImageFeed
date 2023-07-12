//
//  Constants.swift
//  ImageFeed
//
//  Created by Vitaly Alekseev on 28.05.2023.
//

import Foundation

struct Consts {
    static let AccessKey = "kQncukwl6OJc8oxwgH--UOaWVMixnOS5aiLjkKVXT0g"
    static let SecretKey = "T3lIYNWcbXfnDVJxmnqhr7IAiCCf09r4aujz6xA-ZmU"
    static let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let AccessScope =  "public+read_user+write_likes"
    static let DefaultBaseURL = URL(string: "https://api.unsplash.com")!
    static let photosPerPage = 5
    static let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}



struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: Consts.AccessKey,
                                 secretKey: Consts.SecretKey,
                                 redirectURI: Consts.RedirectURI,
                                 accessScope: Consts.AccessScope,
                                 authURLString: Consts.UnsplashAuthorizeURLString,
                                 defaultBaseURL: Consts.DefaultBaseURL)
    }
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
    
}
