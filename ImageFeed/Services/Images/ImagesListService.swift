//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Vitaly Alekseev on 27.06.2023.
//

import Foundation




class ImagesListService {
    
    private (set) var photos: [Photo] = []
    
    private var lastLoadedPage: Int = 0
    private var nextPage: Int  {
        get {
            return lastLoadedPage + 1
        }
    }
    
    static let DidImageListChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private let networkClient = NetworkClient()
    private var task: URLSessionDataTask?
    private let oAuth2TokenStorage = OAuth2TokenStorage()
    
    func fetchPhotosNextPage() { //(completion: @escaping (Result<String, Error>) -> Void ) {
        
        if task != nil { return } // если уже идет загрузка, ее не прерываем
   
        guard let token = oAuth2TokenStorage.token else { return }
        
        // подготавливаем запрос для получения ссылки на аватар https://api.unsplash.com/photos
        guard let photosListRequest = createGetImagesListRequest(with: token) else { return }
        
        task = networkClient.fetchAndParse(for: photosListRequest) { [weak self]  (result: Result<[PhotoResult], Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let photosList):
                self.task = nil
                for item in photosList {
                        self.photos.append(Photo(item))
                }
                        
                print("IMG photosList = \(photosList.count)")
                print("IMG Photo = \(self.photos.count)")
                self.lastLoadedPage += 1
                
                NotificationCenter.default
                    .post(
                        name: ImagesListService.DidImageListChangeNotification,
                        object: self,
                        userInfo: nil)
                break
            case .failure(let error):
                self.task = nil
                print("IMG Error = \(error)")

                break
            }
        }
    }
    
    private func createGetImagesListRequest(with  token: String) -> URLRequest? {
        // GET /photos
        let UnsplashAuthorizeURLString = "https://api.unsplash.com/photos"
        
        guard var urlComponents =  URLComponents(string: UnsplashAuthorizeURLString) else { return nil}
    
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: String(describing: nextPage) ),
            URLQueryItem(name: "per_page", value: String(Consts.photosPerPage)),
        ]
        
        guard let url = urlComponents.url else { return nil}
        
        var request = URLRequest(url: url)
        request.setValue("Bearer " + token, forHTTPHeaderField:"Authorization")
        
        return request
    }
}


