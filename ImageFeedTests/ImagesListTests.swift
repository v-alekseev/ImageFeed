//
//  ImagesList.swift
//  ImageFeedTests
//
//  Created by Vitaly Alekseev on 14.07.2023.
//

import Foundation



import XCTest
@testable import ImageFeed

class ImagesListTests: XCTestCase {
    
    func testViewControllerCallsFetchPhotos() {
        //given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        let presenter = ImagesListPresenterSpy(ImagesListServiceStub())
        viewController.presenter = presenter

        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.isDidfetchPhotosCalled) //behaviour verification
    }
    
    func testPresenterReturnCountPhoto() {
        //given
        
        let presenter = ImagesListPresenter(ImagesListServiceStub())

        //when
        let photosCount = presenter.getPhotoCount()
        
        //then
        XCTAssertTrue(photosCount == 5) //behaviour verification
    }
    
    func testPresenterReturnNewIndexes() {
        //given
        
        let presenter = ImagesListPresenter(ImagesListServiceStub())

        //when
        let newIndexes1 = presenter.getNewIndexes()
        let newIndexes2 = presenter.getNewIndexes()
        
        //then
        XCTAssertTrue(newIndexes1 == 0..<5)
        XCTAssertTrue(newIndexes2 == nil)
    }
    
    func testPresenterReturnPhoto() {
        //given
        let isoDate = "2023-04-28T12:46:16Z"
        let dateFormatter = ISO8601DateFormatter()
        let date = dateFormatter.date(from:isoDate)!
        
        let u1 = URL(string: "https://images.unsplash.com/photo-1682685797741-f0213d24418c?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTQyNzZ8MXwxfGFsbHw1MXx8fHx8fDJ8fDE2ODkzNTM1OTd8&ixlib=rb-4.0.3&q=80&w=200")
        let u2 = URL(string: "https://images.unsplash.com/photo-1682685797741-f0213d24418c?crop=entropy&cs=srgb&fm=jpg&ixid=M3w0NTQyNzZ8MXwxfGFsbHw1MXx8fHx8fDJ8fDE2ODkzNTM1OTd8&ixlib=rb-4.0.3&q=85")
        
        let presenter = ImagesListPresenter(ImagesListServiceStub())

        //when
        let photo = presenter.photo(0)
        
        //then
        XCTAssertTrue(photo.id == "vrbQpGoN8fw")
        XCTAssertTrue(photo.isLiked == false)
        XCTAssertTrue(photo.createdAt == date)
        XCTAssertTrue(photo.thumbImageURL == u1 )
        XCTAssertTrue(photo.largeImageURL == u2 )
        XCTAssertTrue(photo.size == CGSize(width: 8192, height: 5464))
        XCTAssertTrue(photo.welcomeDescription == "A beautiful and ancient spring fed canyon which weaves its way through 400-meter-tall towers of granite, sandstone and basalt, before plunging into the Gulf of Aqaba | Shiʻb Mūsá – NEOM, Saudi Arabia.")
    }
    
    func testDateFormater() {
        //given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        let presenter = ImagesListPresenter(ImagesListServiceStub())
        viewController.presenter = presenter

        //when
        let date = presenter.photo(0).createdAt
        let dateString = viewController.dateFormatter.string(from:  date!)
        
        //then
        XCTAssertTrue(dateString == "28 апреля 2023 г.")
    }
}

class ImagesListServiceStub: ImagesListServiceProtocol {
    var photos: [Photo] = []
    
    init(){
        do {
            let data = Data(photosData.utf8)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .iso8601
            let photosList = try decoder.decode([PhotoResult].self, from: data)
            for item in photosList {
                    self.photos.append(Photo(item))
            }
        } catch {
            print(error)
        }
    }
    
    func fetchPhotosNextPage() {
        return
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<String, Error>) -> Void) {
        return
    }
}

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol?
    var isDidfetchPhotosCalled = false
    let imageListService: ImagesListServiceProtocol

    init(_ imageService: ImagesListServiceProtocol){
        imageListService = imageService //as! ImagesListService
    }
    
    func getPhotoCount() -> Int {
        return 0
    }
    
    func getNewIndexes() -> Range<Int>? {
        return 4..<10
    }
    
    func photo(_ index: Int) -> Photo {
       
        return imageListService.photos[index]
    }
    
    func fetchPhotosNextPage() {
        isDidfetchPhotosCalled =  true
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<String, Error>) -> Void) {
        
    }
}


// Stub data
var photosData =     """
[
{
    "id": "vrbQpGoN8fw",
    "slug": "vrbQpGoN8fw",
    "created_at": "2023-04-28T12:46:16Z",
    "updated_at": "2023-07-13T22:38:08Z",
    "promoted_at": null,
    "width": 8192,
    "height": 5464,
    "color": "#594026",
    "blur_hash": "LTFE_qWB01%2?aM|9Zxuozoen$kB",
    "description": "A beautiful and ancient spring fed canyon which weaves its way through 400-meter-tall towers of granite, sandstone and basalt, before plunging into the Gulf of Aqaba | Shiʻb Mūsá – NEOM, Saudi Arabia.",
    "alt_description": "a man standing in a canyon with the sun shining through the rocks",
    "breadcrumbs": [],
    "urls": {
        "raw": "https://images.unsplash.com/photo-1682685797741-f0213d24418c?ixid=M3w0NTQyNzZ8MXwxfGFsbHw1MXx8fHx8fDJ8fDE2ODkzNTM1OTd8\\u0026ixlib=rb-4.0.3",
        "full": "https://images.unsplash.com/photo-1682685797741-f0213d24418c?crop=entropy\\u0026cs=srgb\\u0026fm=jpg\\u0026ixid=M3w0NTQyNzZ8MXwxfGFsbHw1MXx8fHx8fDJ8fDE2ODkzNTM1OTd8\\u0026ixlib=rb-4.0.3\\u0026q=85",
        "regular": "https://images.unsplash.com/photo-1682685797741-f0213d24418c?crop=entropy\\u0026cs=tinysrgb\\u0026fit=max\\u0026fm=jpg\\u0026ixid=M3w0NTQyNzZ8MXwxfGFsbHw1MXx8fHx8fDJ8fDE2ODkzNTM1OTd8\\u0026ixlib=rb-4.0.3\\u0026q=80\\u0026w=1080",
        "small": "https://images.unsplash.com/photo-1682685797741-f0213d24418c?crop=entropy\\u0026cs=tinysrgb\\u0026fit=max\\u0026fm=jpg\\u0026ixid=M3w0NTQyNzZ8MXwxfGFsbHw1MXx8fHx8fDJ8fDE2ODkzNTM1OTd8\\u0026ixlib=rb-4.0.3\\u0026q=80\\u0026w=400",
        "thumb": "https://images.unsplash.com/photo-1682685797741-f0213d24418c?crop=entropy\\u0026cs=tinysrgb\\u0026fit=max\\u0026fm=jpg\\u0026ixid=M3w0NTQyNzZ8MXwxfGFsbHw1MXx8fHx8fDJ8fDE2ODkzNTM1OTd8\\u0026ixlib=rb-4.0.3\\u0026q=80\\u0026w=200",
        "small_s3": "https://s3.us-west-2.amazonaws.com/images.unsplash.com/small/photo-1682685797741-f0213d24418c"
    },
    "links": {
        "self": "https://api.unsplash.com/photos/vrbQpGoN8fw",
        "html": "https://unsplash.com/photos/vrbQpGoN8fw",
        "download": "https://unsplash.com/photos/vrbQpGoN8fw/download?ixid=M3w0NTQyNzZ8MXwxfGFsbHw1MXx8fHx8fDJ8fDE2ODkzNTM1OTd8",
        "download_location": "https://api.unsplash.com/photos/vrbQpGoN8fw/download?ixid=M3w0NTQyNzZ8MXwxfGFsbHw1MXx8fHx8fDJ8fDE2ODkzNTM1OTd8"
    },
    "likes": 49,
    "liked_by_user": false,
    "current_user_collections": [],
    "sponsorship": {
        "impression_urls": ["https://secure.insightexpressai.com/adServer/adServerESI.aspx?script=false\\u0026bannerID=11515705\\u0026rnd=[timestamp]\\u0026redir=https://secure.insightexpressai.com/adserver/1pixel.gif", "https://secure.insightexpressai.com/adServer/adServerESI.aspx?script=false\\u0026bannerID=11515908\\u0026rnd=[timestamp]\\u0026redir=https://secure.insightexpressai.com/adserver/1pixel.gif"],
        "tagline": "Made to Change",
        "tagline_url": "https://www.neom.com/en-us?utm_source=unsplash\\u0026utm_medium=referral",
        "sponsor": {
            "id": "mYizSrdJkkU",
            "updated_at": "2023-07-14T16:25:24Z",
            "username": "neom",
            "name": "NEOM",
            "first_name": "NEOM",
            "last_name": null,
            "twitter_username": "neom",
            "portfolio_url": "http://www.neom.com",
            "bio": "Located in the northwest of Saudi Arabia, NEOM’s diverse climate offers both sun-soaked beaches and snow-capped mountains. NEOM’s unique location will provide residents with enhanced livability while protecting 95% of the natural landscape.",
            "location": "NEOM, Saudi Arabia",
            "links": {
                "self": "https://api.unsplash.com/users/neom",
                "html": "https://unsplash.com/it/@neom",
                "photos": "https://api.unsplash.com/users/neom/photos",
                "likes": "https://api.unsplash.com/users/neom/likes",
                "portfolio": "https://api.unsplash.com/users/neom/portfolio",
                "following": "https://api.unsplash.com/users/neom/following",
                "followers": "https://api.unsplash.com/users/neom/followers"
            },
            "profile_image": {
                "small": "https://images.unsplash.com/profile-1679489218992-ebe823c797dfimage?ixlib=rb-4.0.3\\u0026crop=faces\\u0026fit=crop\\u0026w=32\\u0026h=32",
                "medium": "https://images.unsplash.com/profile-1679489218992-ebe823c797dfimage?ixlib=rb-4.0.3\\u0026crop=faces\\u0026fit=crop\\u0026w=64\\u0026h=64",
                "large": "https://images.unsplash.com/profile-1679489218992-ebe823c797dfimage?ixlib=rb-4.0.3\\u0026crop=faces\\u0026fit=crop\\u0026w=128\\u0026h=128"
            },
            "instagram_username": "discoverneom",
            "total_collections": 7,
            "total_likes": 0,
            "total_photos": 202,
            "accepted_tos": true,
            "for_hire": false,
            "social": {
                "instagram_username": "discoverneom",
                "portfolio_url": "http://www.neom.com",
                "twitter_username": "neom",
                "paypal_email": null
            }
        }
    },
    "topic_submissions": {},
    "user": {
        "id": "mYizSrdJkkU",
        "updated_at": "2023-07-14T16:25:24Z",
        "username": "neom",
        "name": "NEOM",
        "first_name": "NEOM",
        "last_name": null,
        "twitter_username": "neom",
        "portfolio_url": "http://www.neom.com",
        "bio": "Located in the northwest of Saudi Arabia, NEOM’s diverse climate offers both sun-soaked beaches and snow-capped mountains. NEOM’s unique location will provide residents with enhanced livability while protecting 95% of the natural landscape.",
        "location": "NEOM, Saudi Arabia",
        "links": {
            "self": "https://api.unsplash.com/users/neom",
            "html": "https://unsplash.com/it/@neom",
            "photos": "https://api.unsplash.com/users/neom/photos",
            "likes": "https://api.unsplash.com/users/neom/likes",
            "portfolio": "https://api.unsplash.com/users/neom/portfolio",
            "following": "https://api.unsplash.com/users/neom/following",
            "followers": "https://api.unsplash.com/users/neom/followers"
        },
        "profile_image": {
            "small": "https://images.unsplash.com/profile-1679489218992-ebe823c797dfimage?ixlib=rb-4.0.3\\u0026crop=faces\\u0026fit=crop\\u0026w=32\\u0026h=32",
            "medium": "https://images.unsplash.com/profile-1679489218992-ebe823c797dfimage?ixlib=rb-4.0.3\\u0026crop=faces\\u0026fit=crop\\u0026w=64\\u0026h=64",
            "large": "https://images.unsplash.com/profile-1679489218992-ebe823c797dfimage?ixlib=rb-4.0.3\\u0026crop=faces\\u0026fit=crop\\u0026w=128\\u0026h=128"
        },
        "instagram_username": "discoverneom",
        "total_collections": 7,
        "total_likes": 0,
        "total_photos": 202,
        "accepted_tos": true,
        "for_hire": false,
        "social": {
            "instagram_username": "discoverneom",
            "portfolio_url": "http://www.neom.com",
            "twitter_username": "neom",
            "paypal_email": null
        }
    }
}
    ,
{
    "id": "ZQEGu9fBQzM",
    "slug": "a-white-light-house-sitting-on-top-of-a-lush-green-field-ZQEGu9fBQzM",
    "created_at": "2023-07-13T09:33:39Z",
    "updated_at": "2023-07-13T22:39:38Z",
    "promoted_at": "2023-07-13T17:48:01Z",
    "width": 3024,
    "height": 4032,
    "color": "#f3d9d9",
    "blur_hash": "L~LgR$flWAay~Vayofj[Rlj@jtjt",
    "description": null,
    "alt_description": "a white light house sitting on top of a lush green field",
    "breadcrumbs": [],
    "urls": {
        "raw": "https://images.unsplash.com/photo-1689240766231-6d9b33f1a899?ixid=M3w0NTQyNzZ8MHwxfGFsbHw1Mnx8fHx8fDJ8fDE2ODkzNTM1OTd8\\u0026ixlib=rb-4.0.3",
        "full": "https://images.unsplash.com/photo-1689240766231-6d9b33f1a899?crop=entropy\\u0026cs=srgb\\u0026fm=jpg\\u0026ixid=M3w0NTQyNzZ8MHwxfGFsbHw1Mnx8fHx8fDJ8fDE2ODkzNTM1OTd8\\u0026ixlib=rb-4.0.3\\u0026q=85",
        "regular": "https://images.unsplash.com/photo-1689240766231-6d9b33f1a899?crop=entropy\\u0026cs=tinysrgb\\u0026fit=max\\u0026fm=jpg\\u0026ixid=M3w0NTQyNzZ8MHwxfGFsbHw1Mnx8fHx8fDJ8fDE2ODkzNTM1OTd8\\u0026ixlib=rb-4.0.3\\u0026q=80\\u0026w=1080",
        "small": "https://images.unsplash.com/photo-1689240766231-6d9b33f1a899?crop=entropy\\u0026cs=tinysrgb\\u0026fit=max\\u0026fm=jpg\\u0026ixid=M3w0NTQyNzZ8MHwxfGFsbHw1Mnx8fHx8fDJ8fDE2ODkzNTM1OTd8\\u0026ixlib=rb-4.0.3\\u0026q=80\\u0026w=400",
        "thumb": "https://images.unsplash.com/photo-1689240766231-6d9b33f1a899?crop=entropy\\u0026cs=tinysrgb\\u0026fit=max\\u0026fm=jpg\\u0026ixid=M3w0NTQyNzZ8MHwxfGFsbHw1Mnx8fHx8fDJ8fDE2ODkzNTM1OTd8\\u0026ixlib=rb-4.0.3\\u0026q=80\\u0026w=200",
        "small_s3": "https://s3.us-west-2.amazonaws.com/images.unsplash.com/small/photo-1689240766231-6d9b33f1a899"
    },
    "links": {
        "self": "https://api.unsplash.com/photos/a-white-light-house-sitting-on-top-of-a-lush-green-field-ZQEGu9fBQzM",
        "html": "https://unsplash.com/photos/a-white-light-house-sitting-on-top-of-a-lush-green-field-ZQEGu9fBQzM",
        "download": "https://unsplash.com/photos/ZQEGu9fBQzM/download?ixid=M3w0NTQyNzZ8MHwxfGFsbHw1Mnx8fHx8fDJ8fDE2ODkzNTM1OTd8",
        "download_location": "https://api.unsplash.com/photos/ZQEGu9fBQzM/download?ixid=M3w0NTQyNzZ8MHwxfGFsbHw1Mnx8fHx8fDJ8fDE2ODkzNTM1OTd8"
    },
    "likes": 35,
    "liked_by_user": false,
    "current_user_collections": [],
    "sponsorship": null,
    "topic_submissions": {},
    "user": {
        "id": "5Htorhw7QzY",
        "updated_at": "2023-07-14T16:08:01Z",
        "username": "hiresayan",
        "name": "sayan Nath",
        "first_name": "sayan",
        "last_name": "Nath",
        "twitter_username": null,
        "portfolio_url": null,
        "bio": null,
        "location": null,
        "links": {
            "self": "https://api.unsplash.com/users/hiresayan",
            "html": "https://unsplash.com/@hiresayan",
            "photos": "https://api.unsplash.com/users/hiresayan/photos",
            "likes": "https://api.unsplash.com/users/hiresayan/likes",
            "portfolio": "https://api.unsplash.com/users/hiresayan/portfolio",
            "following": "https://api.unsplash.com/users/hiresayan/following",
            "followers": "https://api.unsplash.com/users/hiresayan/followers"
        },
        "profile_image": {
            "small": "https://images.unsplash.com/profile-fb-1641820924-aaf1c643f216.jpg?ixlib=rb-4.0.3\\u0026crop=faces\\u0026fit=crop\\u0026w=32\\u0026h=32",
            "medium": "https://images.unsplash.com/profile-fb-1641820924-aaf1c643f216.jpg?ixlib=rb-4.0.3\\u0026crop=faces\\u0026fit=crop\\u0026w=64\\u0026h=64",
            "large": "https://images.unsplash.com/profile-fb-1641820924-aaf1c643f216.jpg?ixlib=rb-4.0.3\\u0026crop=faces\\u0026fit=crop\\u0026w=128\\u0026h=128"
        },
        "instagram_username": null,
        "total_collections": 0,
        "total_likes": 0,
        "total_photos": 262,
        "accepted_tos": true,
        "for_hire": true,
        "social": {
            "instagram_username": null,
            "portfolio_url": null,
            "twitter_username": null,
            "paypal_email": null
        }
    }
}

    ,

{
    "id": "LBLkHlooL7U",
    "slug": "a-green-car-parked-in-a-parking-garage-LBLkHlooL7U",
    "created_at": "2023-07-12T14:05:28Z",
    "updated_at": "2023-07-14T12:41:34Z",
    "promoted_at": "2023-07-13T17:40:01Z",
    "width": 4502,
    "height": 6746,
    "color": "#40260c",
    "blur_hash": "LDByvm-.o2f%~nxtWBocDkaeNZso",
    "description": null,
    "alt_description": "a green car parked in a parking garage",
    "breadcrumbs": [],
    "urls": {
        "raw": "https://images.unsplash.com/photo-1689170652466-1bfee78f78b1?ixid=M3w0NTQyNzZ8MHwxfGFsbHw1M3x8fHx8fDJ8fDE2ODkzNTM1OTd8\\u0026ixlib=rb-4.0.3",
        "full": "https://images.unsplash.com/photo-1689170652466-1bfee78f78b1?crop=entropy\\u0026cs=srgb\\u0026fm=jpg\\u0026ixid=M3w0NTQyNzZ8MHwxfGFsbHw1M3x8fHx8fDJ8fDE2ODkzNTM1OTd8\\u0026ixlib=rb-4.0.3\\u0026q=85",
        "regular": "https://images.unsplash.com/photo-1689170652466-1bfee78f78b1?crop=entropy\\u0026cs=tinysrgb\\u0026fit=max\\u0026fm=jpg\\u0026ixid=M3w0NTQyNzZ8MHwxfGFsbHw1M3x8fHx8fDJ8fDE2ODkzNTM1OTd8\\u0026ixlib=rb-4.0.3\\u0026q=80\\u0026w=1080",
        "small": "https://images.unsplash.com/photo-1689170652466-1bfee78f78b1?crop=entropy\\u0026cs=tinysrgb\\u0026fit=max\\u0026fm=jpg\\u0026ixid=M3w0NTQyNzZ8MHwxfGFsbHw1M3x8fHx8fDJ8fDE2ODkzNTM1OTd8\\u0026ixlib=rb-4.0.3\\u0026q=80\\u0026w=400",
        "thumb": "https://images.unsplash.com/photo-1689170652466-1bfee78f78b1?crop=entropy\\u0026cs=tinysrgb\\u0026fit=max\\u0026fm=jpg\\u0026ixid=M3w0NTQyNzZ8MHwxfGFsbHw1M3x8fHx8fDJ8fDE2ODkzNTM1OTd8\\u0026ixlib=rb-4.0.3\\u0026q=80\\u0026w=200",
        "small_s3": "https://s3.us-west-2.amazonaws.com/images.unsplash.com/small/photo-1689170652466-1bfee78f78b1"
    },
    "links": {
        "self": "https://api.unsplash.com/photos/a-green-car-parked-in-a-parking-garage-LBLkHlooL7U",
        "html": "https://unsplash.com/photos/a-green-car-parked-in-a-parking-garage-LBLkHlooL7U",
        "download": "https://unsplash.com/photos/LBLkHlooL7U/download?ixid=M3w0NTQyNzZ8MHwxfGFsbHw1M3x8fHx8fDJ8fDE2ODkzNTM1OTd8",
        "download_location": "https://api.unsplash.com/photos/LBLkHlooL7U/download?ixid=M3w0NTQyNzZ8MHwxfGFsbHw1M3x8fHx8fDJ8fDE2ODkzNTM1OTd8"
    },
    "likes": 14,
    "liked_by_user": false,
    "current_user_collections": [],
    "sponsorship": null,
    "topic_submissions": {},
    "user": {
        "id": "fXqIs3schOs",
        "updated_at": "2023-07-14T13:51:02Z",
        "username": "ynwasso",
        "name": "Wassim Chouak",
        "first_name": "Wassim",
        "last_name": "Chouak",
        "twitter_username": "wasso666",
        "portfolio_url": null,
        "bio": "Instagram ynwasso. I have a Paypal link if u want to support me",
        "location": "Italy",
        "links": {
            "self": "https://api.unsplash.com/users/ynwasso",
            "html": "https://unsplash.com/@ynwasso",
            "photos": "https://api.unsplash.com/users/ynwasso/photos",
            "likes": "https://api.unsplash.com/users/ynwasso/likes",
            "portfolio": "https://api.unsplash.com/users/ynwasso/portfolio",
            "following": "https://api.unsplash.com/users/ynwasso/following",
            "followers": "https://api.unsplash.com/users/ynwasso/followers"
        },
        "profile_image": {
            "small": "https://images.unsplash.com/profile-1675437070298-a9519d3af977image?ixlib=rb-4.0.3\\u0026crop=faces\\u0026fit=crop\\u0026w=32\\u0026h=32",
            "medium": "https://images.unsplash.com/profile-1675437070298-a9519d3af977image?ixlib=rb-4.0.3\\u0026crop=faces\\u0026fit=crop\\u0026w=64\\u0026h=64",
            "large": "https://images.unsplash.com/profile-1675437070298-a9519d3af977image?ixlib=rb-4.0.3\\u0026crop=faces\\u0026fit=crop\\u0026w=128\\u0026h=128"
        },
        "instagram_username": "ynwasso",
        "total_collections": 0,
        "total_likes": 121,
        "total_photos": 478,
        "accepted_tos": true,
        "for_hire": true,
        "social": {
            "instagram_username": "ynwasso",
            "portfolio_url": null,
            "twitter_username": "wasso666",
            "paypal_email": null
        }
    }
}
    ,
{
    "id": "04OGzYiSdsA",
    "slug": "a-close-up-of-two-people-holding-hands-04OGzYiSdsA",
    "created_at": "2023-07-10T23:40:39Z",
    "updated_at": "2023-07-14T16:40:22Z",
    "promoted_at": "2023-07-13T17:24:01Z",
    "width": 2848,
    "height": 4288,
    "color": "#a68c73",
    "blur_hash": "L9GH;wt,.SVs|?NIx]x]yq.8xaS$",
    "description": null,
    "alt_description": "a close up of two people holding hands",
    "breadcrumbs": [],
    "urls": {
        "raw": "https://images.unsplash.com/photo-1689032400893-f577d09f67ee?ixid=M3w0NTQyNzZ8MHwxfGFsbHw1NHx8fHx8fDJ8fDE2ODkzNTM1OTd8\\u0026ixlib=rb-4.0.3",
        "full": "https://images.unsplash.com/photo-1689032400893-f577d09f67ee?crop=entropy\\u0026cs=srgb\\u0026fm=jpg\\u0026ixid=M3w0NTQyNzZ8MHwxfGFsbHw1NHx8fHx8fDJ8fDE2ODkzNTM1OTd8\\u0026ixlib=rb-4.0.3\\u0026q=85",
        "regular": "https://images.unsplash.com/photo-1689032400893-f577d09f67ee?crop=entropy\\u0026cs=tinysrgb\\u0026fit=max\\u0026fm=jpg\\u0026ixid=M3w0NTQyNzZ8MHwxfGFsbHw1NHx8fHx8fDJ8fDE2ODkzNTM1OTd8\\u0026ixlib=rb-4.0.3\\u0026q=80\\u0026w=1080",
        "small": "https://images.unsplash.com/photo-1689032400893-f577d09f67ee?crop=entropy\\u0026cs=tinysrgb\\u0026fit=max\\u0026fm=jpg\\u0026ixid=M3w0NTQyNzZ8MHwxfGFsbHw1NHx8fHx8fDJ8fDE2ODkzNTM1OTd8\\u0026ixlib=rb-4.0.3\\u0026q=80\\u0026w=400",
        "thumb": "https://images.unsplash.com/photo-1689032400893-f577d09f67ee?crop=entropy\\u0026cs=tinysrgb\\u0026fit=max\\u0026fm=jpg\\u0026ixid=M3w0NTQyNzZ8MHwxfGFsbHw1NHx8fHx8fDJ8fDE2ODkzNTM1OTd8\\u0026ixlib=rb-4.0.3\\u0026q=80\\u0026w=200",
        "small_s3": "https://s3.us-west-2.amazonaws.com/images.unsplash.com/small/photo-1689032400893-f577d09f67ee"
    },
    "links": {
        "self": "https://api.unsplash.com/photos/a-close-up-of-two-people-holding-hands-04OGzYiSdsA",
        "html": "https://unsplash.com/photos/a-close-up-of-two-people-holding-hands-04OGzYiSdsA",
        "download": "https://unsplash.com/photos/04OGzYiSdsA/download?ixid=M3w0NTQyNzZ8MHwxfGFsbHw1NHx8fHx8fDJ8fDE2ODkzNTM1OTd8",
        "download_location": "https://api.unsplash.com/photos/04OGzYiSdsA/download?ixid=M3w0NTQyNzZ8MHwxfGFsbHw1NHx8fHx8fDJ8fDE2ODkzNTM1OTd8"
    },
    "likes": 5,
    "liked_by_user": false,
    "current_user_collections": [],
    "sponsorship": null,
    "topic_submissions": {},
    "user": {
        "id": "xLJaxOcdeZk",
        "updated_at": "2023-07-14T02:38:45Z",
        "username": "jesstef",
        "name": "Jessika Arraes",
        "first_name": "Jessika",
        "last_name": "Arraes",
        "twitter_username": null,
        "portfolio_url": "https://arraesfoto.com/",
        "bio": null,
        "location": null,
        "links": {
            "self": "https://api.unsplash.com/users/jesstef",
            "html": "https://unsplash.com/@jesstef",
            "photos": "https://api.unsplash.com/users/jesstef/photos",
            "likes": "https://api.unsplash.com/users/jesstef/likes",
            "portfolio": "https://api.unsplash.com/users/jesstef/portfolio",
            "following": "https://api.unsplash.com/users/jesstef/following",
            "followers": "https://api.unsplash.com/users/jesstef/followers"
        },
        "profile_image": {
            "small": "https://images.unsplash.com/profile-1605233021280-1f5e4fec5e52image?ixlib=rb-4.0.3\\u0026crop=faces\\u0026fit=crop\\u0026w=32\\u0026h=32",
            "medium": "https://images.unsplash.com/profile-1605233021280-1f5e4fec5e52image?ixlib=rb-4.0.3\\u0026crop=faces\\u0026fit=crop\\u0026w=64\\u0026h=64",
            "large": "https://images.unsplash.com/profile-1605233021280-1f5e4fec5e52image?ixlib=rb-4.0.3\\u0026crop=faces\\u0026fit=crop\\u0026w=128\\u0026h=128"
        },
        "instagram_username": "jessikaarraesfoto",
        "total_collections": 0,
        "total_likes": 19,
        "total_photos": 52,
        "accepted_tos": true,
        "for_hire": true,
        "social": {
            "instagram_username": "jessikaarraesfoto",
            "portfolio_url": "https://arraesfoto.com/",
            "twitter_username": null,
            "paypal_email": null
        }
    }
}
    ,
{
    "id": "HUDMeFYU23g",
    "slug": "a-bird-is-standing-in-the-middle-of-a-desert-HUDMeFYU23g",
    "created_at": "2023-07-10T22:16:46Z",
    "updated_at": "2023-07-14T12:41:35Z",
    "promoted_at": "2023-07-13T17:16:01Z",
    "width": 4000,
    "height": 6000,
    "color": "#c08c59",
    "blur_hash": "L8K]MqnjR+s.~BWWWVj[EMaybGay",
    "description": "Sand",
    "alt_description": "a bird is standing in the middle of a desert",
    "breadcrumbs": [],
    "urls": {
        "raw": "https://images.unsplash.com/photo-1689027176284-fe1ab3434e9d?ixid=M3w0NTQyNzZ8MHwxfGFsbHw1NXx8fHx8fDJ8fDE2ODkzNTM1OTd8\\u0026ixlib=rb-4.0.3",
        "full": "https://images.unsplash.com/photo-1689027176284-fe1ab3434e9d?crop=entropy\\u0026cs=srgb\\u0026fm=jpg\\u0026ixid=M3w0NTQyNzZ8MHwxfGFsbHw1NXx8fHx8fDJ8fDE2ODkzNTM1OTd8\\u0026ixlib=rb-4.0.3\\u0026q=85",
        "regular": "https://images.unsplash.com/photo-1689027176284-fe1ab3434e9d?crop=entropy\\u0026cs=tinysrgb\\u0026fit=max\\u0026fm=jpg\\u0026ixid=M3w0NTQyNzZ8MHwxfGFsbHw1NXx8fHx8fDJ8fDE2ODkzNTM1OTd8\\u0026ixlib=rb-4.0.3\\u0026q=80\\u0026w=1080",
        "small": "https://images.unsplash.com/photo-1689027176284-fe1ab3434e9d?crop=entropy\\u0026cs=tinysrgb\\u0026fit=max\\u0026fm=jpg\\u0026ixid=M3w0NTQyNzZ8MHwxfGFsbHw1NXx8fHx8fDJ8fDE2ODkzNTM1OTd8\\u0026ixlib=rb-4.0.3\\u0026q=80\\u0026w=400",
        "thumb": "https://images.unsplash.com/photo-1689027176284-fe1ab3434e9d?crop=entropy\\u0026cs=tinysrgb\\u0026fit=max\\u0026fm=jpg\\u0026ixid=M3w0NTQyNzZ8MHwxfGFsbHw1NXx8fHx8fDJ8fDE2ODkzNTM1OTd8\\u0026ixlib=rb-4.0.3\\u0026q=80\\u0026w=200",
        "small_s3": "https://s3.us-west-2.amazonaws.com/images.unsplash.com/small/photo-1689027176284-fe1ab3434e9d"
    },
    "links": {
        "self": "https://api.unsplash.com/photos/a-bird-is-standing-in-the-middle-of-a-desert-HUDMeFYU23g",
        "html": "https://unsplash.com/photos/a-bird-is-standing-in-the-middle-of-a-desert-HUDMeFYU23g",
        "download": "https://unsplash.com/photos/HUDMeFYU23g/download?ixid=M3w0NTQyNzZ8MHwxfGFsbHw1NXx8fHx8fDJ8fDE2ODkzNTM1OTd8",
        "download_location": "https://api.unsplash.com/photos/HUDMeFYU23g/download?ixid=M3w0NTQyNzZ8MHwxfGFsbHw1NXx8fHx8fDJ8fDE2ODkzNTM1OTd8"
    },
    "likes": 28,
    "liked_by_user": false,
    "current_user_collections": [],
    "sponsorship": null,
    "topic_submissions": {},
    "user": {
        "id": "Kn25w6V3nkM",
        "updated_at": "2023-07-13T17:20:22Z",
        "username": "karinatrinidad",
        "name": "karina trinidad",
        "first_name": "karina",
        "last_name": "trinidad",
        "twitter_username": null,
        "portfolio_url": null,
        "bio": null,
        "location": "Amsterdam, The Netherlands",
        "links": {
            "self": "https://api.unsplash.com/users/karinatrinidad",
            "html": "https://unsplash.com/@karinatrinidad",
            "photos": "https://api.unsplash.com/users/karinatrinidad/photos",
            "likes": "https://api.unsplash.com/users/karinatrinidad/likes",
            "portfolio": "https://api.unsplash.com/users/karinatrinidad/portfolio",
            "following": "https://api.unsplash.com/users/karinatrinidad/following",
            "followers": "https://api.unsplash.com/users/karinatrinidad/followers"
        },
        "profile_image": {
            "small": "https://images.unsplash.com/profile-1656859072019-ba8cda54c320image?ixlib=rb-4.0.3\\u0026crop=faces\\u0026fit=crop\\u0026w=32\\u0026h=32",
            "medium": "https://images.unsplash.com/profile-1656859072019-ba8cda54c320image?ixlib=rb-4.0.3\\u0026crop=faces\\u0026fit=crop\\u0026w=64\\u0026h=64",
            "large": "https://images.unsplash.com/profile-1656859072019-ba8cda54c320image?ixlib=rb-4.0.3\\u0026crop=faces\\u0026fit=crop\\u0026w=128\\u0026h=128"
        },
        "instagram_username": "minimal_amsterdam",
        "total_collections": 1,
        "total_likes": 7,
        "total_photos": 30,
        "accepted_tos": true,
        "for_hire": false,
        "social": {
            "instagram_username": "minimal_amsterdam",
            "portfolio_url": null,
            "twitter_username": null,
            "paypal_email": null
        }
    }
}

    ]
"""
