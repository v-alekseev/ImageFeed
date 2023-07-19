//
//  ProfileView.swift
//  ImageFeedTests
//
//  Created by Vitaly Alekseev on 13.07.2023.
//

import Foundation


import XCTest
@testable import ImageFeed

class ProfileViewTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        //given
      //  let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = ProfileViewController () //storyboard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
        let presenter = ProfilePresenterSpy()
        viewController.configure(presenter)

        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled) //behaviour verification
    }
    
    func testPresenterCallsUpdateProfileAndAvatarOnViewDidLoad() {
        //given
      //  let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = ProfileViewControllerSpy() //storyboard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
        let presenter = ProfilePresenter()
        viewController.presenter = presenter
        presenter.view = viewController

        //when
        presenter.viewDidLoad()
        
        //then
        XCTAssertTrue(viewController.viewDidUpdateAvatarCalled) //behaviour verification
        XCTAssertTrue(viewController.viewDidUpdateProfileDetailsCalled) //behaviour verification
    }
    
    func testPresenterCallsUpdateAndAvatar() {
        //given
      //  let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = ProfileViewControllerSpy() //storyboard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
        let presenter = ProfilePresenter()
        viewController.presenter = presenter
        presenter.view = viewController

        //when
        presenter.didUpdateAvatar()
        
        //then
        XCTAssertTrue(viewController.viewDidUpdateAvatarCalled) //behaviour verification
    }
    
    func testPresenterClearSessionData() {
        //given
      //  let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let oAuth2TokenStorage = OAuthTokenStorage()
        let viewController = ProfileViewControllerSpy() //storyboard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
        let presenter = ProfilePresenter()
        viewController.presenter = presenter
        presenter.view = viewController

        //when
        presenter.clearSessionData()
        
        //then
        XCTAssertTrue(oAuth2TokenStorage.token == nil)
        XCTAssertTrue(HTTPCookieStorage.shared.cookies?.count == 0)
        
    }
}

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    var viewDidLoadCalled: Bool = false
    
    private var oAuth2TokenStorage = OAuthTokenStorage()
    
    func clearSessionData() {
    }
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didUpdateAvatar() {
    }
}


final class ProfileViewControllerSpy: UIViewController & ProfileViewControllerProtocol {
    
    var presenter: ProfilePresenterProtocol?
    var viewDidUpdateProfileDetailsCalled: Bool = false
    var viewDidUpdateAvatarCalled: Bool = false

//    func configure(_ presenter: ProfilePresenterProtocol) {
//        self.presenter = presenter
//        presenter.view = self
//
//    }
    
    func updateAvatar() {

        viewDidUpdateAvatarCalled = true
    }
    
    func updateProfileDetails() {
        viewDidUpdateProfileDetailsCalled = true
    }
}

