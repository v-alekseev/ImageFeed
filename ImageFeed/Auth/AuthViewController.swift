//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Vitaly Alekseev on 28.05.2023.
//

import Foundation
import UIKit


final class AuthViewController: UIViewController, WebViewViewControllerDelegate {
    
    let ShowWebView: String = "ShowWebView"
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowWebView {
            let destinationViewController = segue.destination as! WebViewViewController // 2
            destinationViewController.delegate = self
            
        } else {
            super.prepare(for: segue, sender: sender) // 6
        }
    }
    
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        //TODO: process code
        print("code = \(code)")
        
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        
        self.dismiss(animated: true)  // AuthViewController
        //vc.dismiss(animated: true)  // WebViewViewController
    }
    
}
