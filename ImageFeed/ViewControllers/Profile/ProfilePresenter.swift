//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Vitaly Alekseev on 13.07.2023.
//

import Foundation
import UIKit
import WebKit

public protocol ProfilePresenterProtocol: AnyObject{
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func didUpdateAvatar()
    func clearSessionData()
}


final class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    
    private var oAuth2TokenStorage = OAuth2TokenStorage()
    
    func clearSessionData() {
        //  чистим keychain
        self.oAuth2TokenStorage.token = nil
        // Очишаем куки и другие данные сессии
        self.cleanWebData()
    }
    
    func viewDidLoad() {
        view?.updateProfileDetails()
        view?.updateAvatar()
    }
    
    func didUpdateAvatar() {
        view?.updateAvatar()
    }
    
    private func cleanWebData() {
        // Очищаем все куки из хранилища.
        print("IMG HTTPCookieStorage.shared.cookies?.count(1) = \(HTTPCookieStorage.shared.cookies?.count)")
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        print("IMG HTTPCookieStorage.shared.cookies?.count(2) = \(HTTPCookieStorage.shared.cookies?.count)")
        // Запрашиваем все данные из локального хранилища.
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            // Массив полученных записей удаляем из хранилища.
            print("IMG records.count(1) = \(records.count)")
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
            print("IMG records.count(2) = \(records.count)")
        }
        
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            // Массив полученных записей удаляем из хранилища.
            print("IMG records.count(2) = \(records.count)")
        }
    }

}
