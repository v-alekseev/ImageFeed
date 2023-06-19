//
//  ProfileService.swift.swift
//  ImageFeed
//
//  Created by Vitaly Alekseev on 18.06.2023.
//

import Foundation


struct Profile{
    private var username: String
    private var first_name: String
    private var last_name: String
    
    var name: String {first_name + " " + last_name}
    var loginName: String {"@" + name}
    var bio: String
    
    init(data: ProfileResult){
        self.init(username: data.userName, first_name: data.firsName, last_name: data.lastName, bio: data.bio)
    }
    
    init(username: String?, first_name: String?, last_name: String?, bio: String?){
        self.username = username ?? "No information" // тут обязательно выводить загрушку т.к. имя пользователя должно быть обязательно
        self.first_name = first_name ?? ""  // тут значение по умолчанию пустая сторока, т.к. пользователь может просто не указать имя
        self.last_name = last_name ?? "" // тут значение по умолчанию пустая сторока, т.к. пользователь может просто не указать фамилию
        self.bio = bio ?? "No information" // тут обязательно выводить загрушку т.к. в интерфейсе это смотриться лучше чем просто пустота
    }
}

final class ProfileService {
    
    private let networkClient = NetworkClient()
    private var task: URLSessionDataTask?
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        // защита от повторного вызова функции fetchProfile
        task?.cancel()                                      // текущий запрс надо убить. (если он nil то функция не будет вызвана)
        
        // делаем POST запрос для получения токена https://unsplash.com/oauth/token
        let profileRequest = createGetProfileRequest(with: token)
        
        task = networkClient.fetch(request: profileRequest) { result in
            
            print("IMG \(#file)-\(#function)(\(#line)) isMainThread = \(Thread.isMainThread)")
            
            switch result {
            case .success(let data):
                do {
                    let profileResponce = try JSONDecoder().decode(ProfileResult.self, from: data)
                    DispatchQueue.main.async {
                        print("IMG \(#file)-\(#function)(\(#line)) isMainThread = \(Thread.isMainThread)")
                        print("IMG \(profileResponce)")
                        self.task = nil
                        completion(Result.success(Profile(data: profileResponce)))
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
    
    private func createGetProfileRequest(with  token: String) -> URLRequest {
        let UnsplashAuthorizeURLString = "https://api.unsplash.com/me"
        
        //var urlComponents = URLComponents(string: UnsplashAuthorizeURLString)!
        let url = URL(string: UnsplashAuthorizeURLString)// urlComponents.url!
        var request = URLRequest(url: url!)
        
        request.setValue("Bearer " + token, forHTTPHeaderField:"Authorization")
        
        return request
    }
    
}
