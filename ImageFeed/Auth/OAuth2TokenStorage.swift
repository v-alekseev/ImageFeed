//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Vitaly Alekseev on 02.06.2023.
//

import Foundation

final class OAuth2TokenStorage {
    
    var token: String {
        
        get {
            guard let value = UserDefaults.standard.string(forKey: "authToken") else {return ""}
            return value
        }
        
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: "authToken")
        }
    }
    
    var code: String {
        
        get {
            guard let value = UserDefaults.standard.string(forKey: "code") else {return ""}
            return value
        }
        
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: "code")
        }
    }
    
}
