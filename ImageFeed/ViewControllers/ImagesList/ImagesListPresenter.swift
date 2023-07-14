//
//  ImagesListPresenterProtocol.swift
//  ImageFeed
//
//  Created by Vitaly Alekseev on 13.07.2023.
//

import Foundation
import UIKit


public protocol ImagesListPresenterProtocol: AnyObject{
    var view: ImagesListViewControllerProtocol? { get set }

    init(_ imageService: ImagesListServiceProtocol)
    
    func getPhotoCount() -> Int
    func getNewIndexes() -> Range<Int>?
    func photo(_ index: Int) -> Photo
    
    func fetchPhotosNextPage()
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<String, Error>) -> Void)
    
    //func configure(_ imageService: ImagesListServiceProtocol)
}


final class ImagesListPresenter: ImagesListPresenterProtocol {
    
    weak var view: ImagesListViewControllerProtocol?
    
    private var currentImageListSize: Int = 0
    private var imageListService: ImagesListServiceProtocol //= ImagesListService()
    
    init(_ imageService: ImagesListServiceProtocol){
        imageListService = imageService //as! ImagesListService
    }
    
    func getPhotoCount() -> Int {
        return imageListService.photos.count
    }
    
    private func getAddedRows() -> Int {
        return imageListService.photos.count - currentImageListSize
    }
    
    func getNewIndexes() -> Range<Int>? {
        let addRows = getAddedRows() //imageListService.photos.count - currentImageListSize
        if addRows <= 0 { return nil }
        
        let indexs = (currentImageListSize..<getPhotoCount())
        currentImageListSize = getPhotoCount() //imageListService.photos.count
        
        return indexs
    }
    

    func photo(_ index: Int) -> Photo {
        return imageListService.photos[index]
    }

    func fetchPhotosNextPage() {
        imageListService.fetchPhotosNextPage()
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<String, Error>) -> Void) {
        
        imageListService.changeLike(photoId: photoId, isLike: isLike) { result in
            switch result {
            case .success(_):
                completion(Result.success(""))
                break
            case .failure(let error):
                completion(Result.failure(error))
                break
            }
        }
    }
}
