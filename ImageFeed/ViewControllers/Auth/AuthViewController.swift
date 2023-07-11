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
    
    private let ShowWebView: String = "ShowWebView"
    private var oAuth2TokenStorage = OAuth2TokenStorage()
    weak var delegate: AuthViewControllerDelegate? 
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowWebView {
            // Переходим на ViewController для открытия WebView авторизации
            let destinationViewController = segue.destination as! WebViewViewController
            destinationViewController.webViewDelegate = self  // WebViewViewControllerDelegate
            
            let webViewPresenter = WebViewPresenter()
            destinationViewController.presenter = webViewPresenter
            webViewPresenter.view = destinationViewController
            
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
}

extension AuthViewController:  WebViewViewControllerDelegate {
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        // уведомляем  SplashViewController о том что получили Code        
        delegate?.authViewController(self, didAuthenticateWithCode: code)
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        self.dismiss(animated: true)  // AuthViewController
    }
    
}
