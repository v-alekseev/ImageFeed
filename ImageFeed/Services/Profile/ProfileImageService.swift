//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Vitaly Alekseev on 20.06.2023.
//

import Foundation


final class ProfileImageService {
    
    static let shared = ProfileImageService()
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    
    private let networkClient = NetworkClient()
    private var task: URLSessionDataTask?
    private var profile = Profile.shared
    private let oAuthTokenStorage = OAuthTokenStorage()
    
    
    private init() {
        
    }
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        
        task?.cancel() // защита от повторного вызова функции fetchProfileImageURL
        
        guard let token = oAuthTokenStorage.token else { return }
        
        // подготавливаем запрос для получения ссылки на аватар https://api.unsplash.com/users/
        guard let userInfoRequest = createGetUserRequest(with: token, user: profile.username) else { return }
        task = networkClient.fetchAndParse(for: userInfoRequest) { [weak self]  (result: Result<UserResult, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let userInfoResponce):
                self.task = nil
                self.profile.avatarURL = userInfoResponce.profileImage.small
                completion(Result.success(userInfoResponce.profileImage.small))
                
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.DidChangeNotification,
                        object: self,
                        userInfo: ["URL": userInfoResponce.profileImage.small])
                
            case .failure(let error):
                self.task = nil
                completion(Result.failure(error))
            }
        }
    }
    
    
    private func createGetUserRequest(with  token: String, user: String) -> URLRequest? {
        // GET /users/:username
        let UnsplashAuthorizeURLString = Consts.DefaultAPIURL.absoluteString + "/users/" + user
        guard let url = URL(string: UnsplashAuthorizeURLString) else { return nil}
        var request = URLRequest(url: url)
        request.setValue("Bearer " + token, forHTTPHeaderField:"Authorization")
        
        return request
    }
}
