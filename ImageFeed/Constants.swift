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
    static let DefaultBaseURL = URL(string: "https://api.unsplash.com/")!
    static let photosPerPage = 5
}
