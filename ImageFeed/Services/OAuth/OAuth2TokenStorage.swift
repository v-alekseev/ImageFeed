//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Vitaly Alekseev on 02.06.2023.
//

import Foundation

final class OAuth2TokenStorage {
    
    var token: String? {
        
        get {
            return UserDefaults.standard.string(forKey: "authToken")
        }
        
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: "authToken")
        }
    }
    
}
