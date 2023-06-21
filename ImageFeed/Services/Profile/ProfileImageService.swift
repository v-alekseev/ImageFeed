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
    private let oAuth2TokenStorage = OAuth2TokenStorage()
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        
        task?.cancel() // защита от повторного вызова функции fetchProfileImageURL
        
        guard let token = oAuth2TokenStorage.token else { return }
        
        // подготавливаем запрос для получения ссылки на аватар https://api.unsplash.com/users/
        let userInfoRequest = createGetUserRequest(with: token, user: profile.username)
        task = networkClient.fetchAndParse(for: userInfoRequest) { [weak self]  (result: Result<UserResult, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let userInfoResponce):
                self.task = nil
                self.profile.avatarURL = userInfoResponce.profile_image.small
                completion(Result.success(userInfoResponce.profile_image.small))
                
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.DidChangeNotification,
                        object: self,
                        userInfo: ["URL": userInfoResponce.profile_image.small])
                
            case .failure(let error):
                self.task = nil
                completion(Result.failure(error))
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
