//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Vitaly Alekseev on 02.06.2023.
//

import Foundation

class OAuth2Service {
    
    let networkClient = NetworkClient()
    
    func fetchAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        // делаем POST запрос для получения токена https://unsplash.com/oauth/token
        let authUrl = createAuthUrl(code: code)

        networkClient.fetch(url: authUrl) { result in
                switch result {
                case .success(let data):
                        do {
                            // преобразуем полученный json из API к типу OAuthTokenResponseBody
                            let authResponce = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                            completion(Result.success(authResponce.access_token))
                        } catch {
                            completion(Result.failure(error))
                        }
                case .failure(let error):
                    completion(Result.failure(error))
                    }
        }
    }
    
    private func createAuthUrl(code: String) -> URL {
        
        let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/token"
        
        var urlComponents = URLComponents(string: UnsplashAuthorizeURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Consts.AccessKey),
            URLQueryItem(name: "redirect_uri", value: Consts.RedirectURI),
            URLQueryItem(name: "client_secret", value: Consts.SecretKey),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
         ]
        
       return urlComponents.url!
    }
    
    func createCodeRequestURL() -> URL {
            let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
            
            var urlComponents = URLComponents(string: UnsplashAuthorizeURLString)!
            urlComponents.queryItems = [
                URLQueryItem(name: "client_id", value: Consts.AccessKey),
                URLQueryItem(name: "redirect_uri", value: Consts.RedirectURI),
                URLQueryItem(name: "response_type", value: "code"),
                URLQueryItem(name: "scope", value: Consts.AccessScope) 
             ]
        return urlComponents.url!
    }
}

