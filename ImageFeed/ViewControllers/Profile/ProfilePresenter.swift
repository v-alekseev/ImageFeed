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
    
    private var oAuth2TokenStorage = OAuthTokenStorage()
    
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
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        // Запрашиваем все данные из локального хранилища.
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            // Массив полученных записей удаляем из хранилища.
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }

}
