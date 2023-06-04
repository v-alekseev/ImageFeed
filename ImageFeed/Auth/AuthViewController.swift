//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Vitaly Alekseev on 28.05.2023.
//

import Foundation
import UIKit


protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}

final class AuthViewController: UIViewController {
    
    let ShowWebView: String = "ShowWebView"
    let oAuth2Service: OAuth2Service = OAuth2Service()
    var oAuth2TokenStorage = OAuth2TokenStorage()
    weak var delegate: AuthViewControllerDelegate? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("\(#function)(\(#line)) oAuth2TokenStorage.token = \(oAuth2TokenStorage.token)")
        print("\(#function)(\(#line)) oAuth2TokenStorage.code = \(oAuth2TokenStorage.code)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowWebView {
            let destinationViewController = segue.destination as! WebViewViewController
            destinationViewController.webViewDelegate = self  // WebViewViewControllerDelegate
           
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
}

extension AuthViewController:  WebViewViewControllerDelegate {
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
                
        print("\(#function)(\(#line)) code = \(code)")
        oAuth2TokenStorage.code = code
        // уведомляем  SplashViewController о том что получили Code
        delegate?.authViewController(self, didAuthenticateWithCode: code)
        
        oAuth2Service.fetchAuthToken(code: code) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let token):
                    self.oAuth2TokenStorage.token = token
                    print("\(#function)(\(#line)) access_token = \(token)")
                    
                    self.switchToTabBarController()
                    
                case .failure(let error):
                    //TODO подумать над показом ошибки. На данный момент в задании это не оговорено, но кажется нужно хотябы алерт показать
                    self.oAuth2TokenStorage.token = ""
                    print("\(#function)(\(#line)) Error = \(error.localizedDescription)")
                }
                return
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        
        self.dismiss(animated: true)  // AuthViewController
        print("\(#function)(\(#line)) ")
        // TODO провести эксперимент позже, когда будет большой стек UIView
        //vc.dismiss(animated: true)  // WebViewViewController
    }
    
}
