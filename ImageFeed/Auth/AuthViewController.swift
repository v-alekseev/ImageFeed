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
    private let oAuth2Service: OAuth2Service = OAuth2Service()
    private var oAuth2TokenStorage = OAuth2TokenStorage()
    private weak var delegate: AuthViewControllerDelegate? = nil
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowWebView {
            let destinationViewController = segue.destination as! WebViewViewController
            destinationViewController.webViewDelegate = self  // WebViewViewControllerDelegate
           
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
        // TODO провести эксперимент позже, когда будет большой стек UIView
        //vc.dismiss(animated: true)  // WebViewViewController
    }
    
}
