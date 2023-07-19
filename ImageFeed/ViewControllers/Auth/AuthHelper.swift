//
//  AuthHelper.swift
//  ImageFeed
//
//  Created by Vitaly Alekseev on 12.07.2023.
//

import Foundation

protocol AuthHelperProtocol {
    func authRequest() -> URLRequest?
    func code(from url: URL) -> String?
}

class AuthHelper: AuthHelperProtocol {
    let configuration: AuthConfiguration
    
    init(configuration: AuthConfiguration = .standard) {
        self.configuration = configuration
    }
    
    func authURL() -> URL? {
        //let UnsplashAuthorizeURLString = Consts.DefaultBaseURL.absoluteString + "/oauth/authorize"
        
        var urlComponents = URLComponents(string: Consts.UnsplashAuthorizeURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Consts.AccessKey),
            URLQueryItem(name: "redirect_uri", value: Consts.RedirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Consts.AccessScope)
        ]
        
        //urlComponents.url
        
        return  urlComponents.url // URLRequest(url: url)
    }
    
    func authRequest() -> URLRequest? {
        guard let url = authURL() else { return nil}
        return URLRequest(url: url)
    }
    
    func code(from url: URL) -> String? {
        if let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
} 
