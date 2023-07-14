//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Vitaly Alekseev on 27.06.2023.
//

import Foundation

public protocol ImagesListServiceProtocol {
    var photos: [Photo] { get set }
    
    func fetchPhotosNextPage()
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<String, Error>) -> Void)
}

class ImagesListService: ImagesListServiceProtocol {
    
    var photos: [Photo] = []
    
    private var lastLoadedPage: Int = 0
    private var nextPage: Int  {
        get {
            return lastLoadedPage + 1
        }
    }
    
    static let DidImageListChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private let networkClient = NetworkClient()
    private var taskPagination: URLSessionDataTask?
    private var taskChangeLike: URLSessionDataTask?
    private let oAuth2TokenStorage = OAuth2TokenStorage()
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<String, Error>) -> Void) {
        taskChangeLike?.cancel() // если уже идет загрузка, прерываем ee
        guard let token = oAuth2TokenStorage.token else { return }
        
        // подготавливаем запрос для получения ссылки на аватар https://api.unsplash.com/photos
        guard let photoLikeRequest = createLikeRequest(with: token, photoId: photoId, like: isLike) else { return }
        
        taskChangeLike = networkClient.fetchAndParse(for: photoLikeRequest) { [weak self]  (result: Result<LikeResult, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let photosList):
                self.taskChangeLike = nil
                let newPhoto = Photo(photosList.photo)
                print("IMG Photo id = \(newPhoto.id) was \(isLike ? "liked" : "unliked")")
                // Поиск индекса элемента
                // TODO пробросить сюда тупо индекс массива, а не id  фото
                if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                    self.photos[index] = newPhoto
                    completion(Result.success(""))
                }
                break
            case .failure(let error):
                self.taskChangeLike = nil
                print("IMG Error = \(error)")
                completion(Result.failure(error))

                break
            }
        }
    }
    
    func fetchPhotosNextPage() { 
        
        if taskPagination != nil { return } // если уже идет загрузка, ее не прерываем
   
        guard let token = oAuth2TokenStorage.token else { return }
        
        // подготавливаем запрос для получения ссылки на аватар https://api.unsplash.com/photos
        guard let photosListRequest = createGetImagesListRequest(with: token) else { return }
        
        taskPagination = networkClient.fetchAndParse(for: photosListRequest) { [weak self]  (result: Result<[PhotoResult], Error>) in
            guard let self = self else {
                print("IMG fetchPhotosNextPage self = \(self)")
                return }
            switch result {
            case .success(let photosList):
                self.taskPagination = nil
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
                self.taskPagination = nil
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
    
    
    // подготавливаем запрос для  установки/снятия like https://api.unsplash.com/photos/\(photoId)/like (likr = true, set like, false delete like)
    private func createLikeRequest(with token: String, photoId: String, like: Bool)  -> URLRequest? {
        
        let UnsplashAuthorizeURLString = Consts.DefaultAPIURL.absoluteString + "/photos/\(photoId)/like"
        
        guard let url = URL(string: UnsplashAuthorizeURLString) else { return nil}
        
        var request = URLRequest(url: url)
        request.httpMethod = like ? "POST" : "DELETE"
        request.setValue("Bearer " + token, forHTTPHeaderField:"Authorization")
        
        return request
    }
    
}


