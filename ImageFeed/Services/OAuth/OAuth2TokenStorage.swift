//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Vitaly Alekseev on 02.06.2023.
//

import SwiftKeychainWrapper

import Foundation

final class OAuth2TokenStorage {
    
    var token: String? {
        
        get {
            let token: String? = KeychainWrapper.standard.string(forKey: "Auth token")
            return token 
        }
        
        set(newValue) {
            if newValue == nil {
                KeychainWrapper.standard.removeObject(forKey: "Auth token")
                return
            }
            KeychainWrapper.standard.set(newValue!, forKey: "Auth token")
        }
    }
    
}
