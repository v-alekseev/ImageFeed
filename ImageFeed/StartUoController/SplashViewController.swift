//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Vitaly Alekseev on 03.06.2023.
//

import Foundation
import UIKit

import ProgressHUD


final class SplashViewController: UIViewController {
    private let ShowImageListViewSegueIdentifier = "ShowImageListView"
    private let ShowAuthViewSegueIdentifier = "ShowAuthView"
    
    private let oAuth2TokenStorage = OAuth2TokenStorage()
    private let oAuth2Service = OAuth2Service()
    
    private let profileService = ProfileService()
    //private let profileImageService = ProfileImageService()
    
    private var profile = Profile.shared
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("IMG Token = \(String(describing: oAuth2TokenStorage.token))")
        // Если токен получали ранее, то переходим в библиотеку изображений. Если нет, то на экран авторизации
        
        if let token = oAuth2TokenStorage.token {
            self.fetchProfile(token: token)
        } else {
            performSegue(withIdentifier: ShowAuthViewSegueIdentifier, sender: "")
        }
        
    }
    
    // это нужно для белого шрифта в статус бар
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == ShowAuthViewSegueIdentifier {
            // Доберёмся до первого контроллера в навигации. Мы помним, что в программировании отсчёт начинается с 0?
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers.first as? AuthViewController
            else { fatalError("Failed to prepare for \(ShowAuthViewSegueIdentifier)") }
            
            viewController.delegate = self
            
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func switchToTabBarController() {
        // Получаем экземпляр `Window` приложения
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        
        // Cоздаём экземпляр нужного контроллера из Storyboard с помощью ранее заданного идентификатора.
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        
        // Установим в `rootViewController` полученный контроллер
        window.rootViewController = tabBarController
    }
    
    
    private func fetchAuthToken(code: String) {
        
        oAuth2Service.fetchAuthToken(code: code) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let token):
                // Сохраним токен в UserDefaults
                self.oAuth2TokenStorage.token = token
                print("IMG \(#file)-\(#function)(\(#line)) token = \(token)")
                
                self.fetchProfile(token: token)
                
            case .failure(let error):
                print("IMG \(#file)-\(#function)(\(#line)) Error = \(error)")
                self.oAuth2TokenStorage.token = nil // нужно обнулять. если токен отзовут, мы никогда не сможем попасть обратно на экран авторизации
                self.showErrorAlert()
            }
        }
    }
    
    private func fetchProfile(token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                // profile уже инициализирован. тут его обрабатывать не надо
                self.fetchProfileImage(username: profile.username)
                UIBlockingProgressHUD.dismiss()
                self.switchToTabBarController() // TODO - переключимся на flow библиотеки изображений
                
            case .failure:
                UIBlockingProgressHUD.dismiss()
                self.showErrorAlert()
            }
        }
        
    }
    private func fetchProfileImage(username: String) {
        ProfileImageService.shared.fetchProfileImageURL(username: username) {  [weak self] result in
            //guard let self = self else { return }
            switch result {
            case .success(let url):
                print("IMG avatar url = \(url)")
                break
            case .failure(let error):
                print("IMG Error loading. Error: \(error)")
                //self.showErrorAlert() // тут не нужен алерт, не загрузили аватарку и ладно
                break
            }
        }
        
    }
    
    private func showErrorAlert() {
        let alert = UIAlertController(title: "Что-то пошло не так(", message: "Не удалось войти в систему", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}
extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        self.fetchAuthToken(code: code)
    }
    
}
