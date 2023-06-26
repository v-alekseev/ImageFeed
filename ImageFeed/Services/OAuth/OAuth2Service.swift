//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Vitaly Alekseev on 02.06.2023.
//

import Foundation

class OAuth2Service {
    // Кажется его нужно сделать Singleton раз мы тут проверяем code и task // хотя может быть проблема с тем что вызвали из разных потоков. Надо подумать
    //    static let shared = TestSinglton()
    //    private init() {
    //    }
    
    private let networkClient = NetworkClient()
    private var task: URLSessionDataTask?
    private var lastCode: String?
    
    
    func fetchAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        // защита от повторного вызова функции fetchAuthToken
        if lastCode == code { return }
        task?.cancel()
        
        lastCode = code
        
        // подготавливаем запрос для получения токена https://unsplash.com/oauth/token
        guard let authRequest = createAuthUrl(code: code) else { return }
        
        task = networkClient.fetchAndParse(for: authRequest) { [weak self]  (result: Result<OAuthTokenResponseBody, Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let authResponce):
                self.task = nil
                completion(Result.success(authResponce.accessToken))
                
            case .failure(let error):
                self.task = nil
                completion(Result.failure(error))
            }
        }
    }
    
    private func createAuthUrl(code: String) -> URLRequest? {
        
        let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/token"
        
        var urlComponents = URLComponents(string: UnsplashAuthorizeURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Consts.AccessKey),
            URLQueryItem(name: "redirect_uri", value: Consts.RedirectURI),
            URLQueryItem(name: "client_secret", value: Consts.SecretKey),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        guard let url = urlComponents.url else { return nil}
        
        return URLRequest(url: url)
    }
    
    func createCodeRequestURL() -> URLRequest? {
        let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
        
        var urlComponents = URLComponents(string: UnsplashAuthorizeURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Consts.AccessKey),
            URLQueryItem(name: "redirect_uri", value: Consts.RedirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Consts.AccessScope)
        ]
        
        guard let url = urlComponents.url else { return nil}
        
        return URLRequest(url: url)
    }
}

