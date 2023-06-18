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

        print("IMG \(#file)-\(#function)(\(#line)) isMainThread = \(Thread.isMainThread)")
        // 1 - проверяем что есть активный запрос task != nil
        // 2 - проверяем code == lastCode
        
        print("IMG \(#file)-\(#function)(\(#line)) task = \(String(describing: task)); lastCode = \(lastCode); code = \(code)")
        
        // защита от повторного вызова функции fetchAuthToken
        if lastCode == code { return }                      // тот же код пришел. Не делаем повторный запрос
        task?.cancel()                                      // текущий запрс надо убить. (если он nil то функция не будет вызвана)

        lastCode = code
        
        // делаем POST запрос для получения токена https://unsplash.com/oauth/token
        let authUrl = createAuthUrl(code: code)
        
        task = networkClient.fetch(url: authUrl) { result in
           
            print("IMG \(#file)-\(#function)(\(#line)) isMainThread = \(Thread.isMainThread)")
            
            //self.task = nil  // устанавливам признак того что таск завершен  //  //Thread.isMainThread = false тут !!!!!!!
            
            switch result {
            case .success(let data):
                do {
                    let authResponce = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                    DispatchQueue.main.async {
                        print("IMG \(#file)-\(#function)(\(#line)) isMainThread = \(Thread.isMainThread)")
                        self.task = nil
                        completion(Result.success(authResponce.access_token))
                    }
                } catch {
                    DispatchQueue.main.async {
                        print("IMG \(#file)-\(#function)(\(#line)) isMainThread = \(Thread.isMainThread)")
                        self.task = nil
                        completion(Result.failure(error))
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print("IMG \(#file)-\(#function)(\(#line)) isMainThread = \(Thread.isMainThread)")
                    self.task = nil
                    completion(Result.failure(error))
                }
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

