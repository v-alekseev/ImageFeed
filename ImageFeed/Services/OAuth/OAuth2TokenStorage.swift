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
            print("IMG OAuth2TokenStorage get = \(String(describing: token))")
            return token // UserDefaults.standard.string(forKey: "authToken")
        }
        
        set(newValue) {
            //let token = newValue
            let result = KeychainWrapper.standard.set(newValue!, forKey: "Auth token")
            print("IMG OAuth2TokenStorage set(\(newValue!) = \(result)")
            //UserDefaults.standard.set(newValue, forKey: "authToken")
        }
    }
    
}
