//
//  ProfileService.swift.swift
//  ImageFeed
//
//  Created by Vitaly Alekseev on 18.06.2023.
//

import Foundation


final class ProfileService {
    
    private let networkClient = NetworkClient()
    private var task: URLSessionDataTask?
    private var profile = Profile.shared
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        
        // защита от повторного вызова функции fetchProfile
        task?.cancel()
        
        // подготавливаем запрос для получения  данных профайла https://api.unsplash.com/me
        let profileRequest = createGetProfileRequest(with: token)
        task = networkClient.fetchAndParse(for: profileRequest) { [weak self]  (result: Result<ProfileResult, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let profileResponce):
                self.task = nil
                self.profile.setData(data: profileResponce)
                completion(Result.success(self.profile))
                
            case .failure(let error):
                self.task = nil
                completion(Result.failure(error))
            }
        }
    }
    
    private func createGetProfileRequest(with  token: String) -> URLRequest {
        let UnsplashAuthorizeURLString = "https://api.unsplash.com/me"
        let url = URL(string: UnsplashAuthorizeURLString)
        var request = URLRequest(url: url!)
        
        request.setValue("Bearer " + token, forHTTPHeaderField:"Authorization")
        
        return request
    }
    
}
