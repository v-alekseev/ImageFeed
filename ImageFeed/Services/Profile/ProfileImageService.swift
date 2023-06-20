//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Vitaly Alekseev on 20.06.2023.
//

import Foundation

//enum ParseError: Error {
//    case imageUrlMissed
//}

final class ProfileImageService {
    
    static let shared = ProfileImageService()
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    
    private let networkClient = NetworkClient()
    private var task: URLSessionDataTask?
    private var profile = Profile.shared
    private let oAuth2TokenStorage = OAuth2TokenStorage()
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        print("IMG fetchProfileImageURL (1)")
        // защита от повторного вызова функции fetchProfile
        task?.cancel()                                      // текущий запрс надо убить. (если он nil то функция не будет вызвана)
        
        guard let token = oAuth2TokenStorage.token else { return }
        
        // делаем POST запрос для получения токена https://unsplash.com/oauth/token
        let userInfoRequest = createGetUserRequest(with: token, user: profile.username)
        task = networkClient.fetch(request: userInfoRequest) { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                do {
                    let userInfoResponce = try JSONDecoder().decode(UserResult.self, from: data)
                    DispatchQueue.main.async {
                        self.task = nil
                        
                        self.profile.avatarURL = userInfoResponce.profile_image.small
                        
                        completion(Result.success(userInfoResponce.profile_image.small))
                        
                        NotificationCenter.default
                            .post(
                                name: ProfileImageService.DidChangeNotification,
                                object: self,
                                userInfo: ["URL": userInfoResponce.profile_image.small])
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.task = nil
                        completion(Result.failure(error))
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.task = nil
                    completion(Result.failure(error))
                }
            }
        }
        
    }
    
    
    private func createGetUserRequest(with  token: String, user: String) -> URLRequest {
        
        // GET /users/:username
        let UnsplashAuthorizeURLString = "https://api.unsplash.com/users/" + user
        
        let url = URL(string: UnsplashAuthorizeURLString)// urlComponents.url!
        var request = URLRequest(url: url!)
        
        request.setValue("Bearer " + token, forHTTPHeaderField:"Authorization")
        
        return request
    }
}
