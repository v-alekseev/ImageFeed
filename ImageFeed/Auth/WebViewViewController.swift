//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Vitaly Alekseev on 28.05.2023.
//

import Foundation
import UIKit
import WebKit


protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

final class WebViewViewController: UIViewController {
    
    @IBAction func didTapBackButton2(_ sender: UIButton) {
        delegate?.webViewViewControllerDidCancel(self)
    }

    @IBOutlet weak var webView2: WKWebView!
    
    weak var delegate: WebViewViewControllerDelegate?  = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView2.navigationDelegate = self
        
        let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
        
        var urlComponents = URLComponents(string: UnsplashAuthorizeURLString)!  //1
        urlComponents.queryItems = [
           URLQueryItem(name: "client_id", value: AccessKey),                  //2
           URLQueryItem(name: "redirect_uri", value: RedirectURI),             //3
           URLQueryItem(name: "response_type", value: "code"),                 //4
           URLQueryItem(name: "scope", value: AccessScope)                     //5
         ]
        let url = urlComponents.url!
        
        let request = URLRequest(url: url)
        webView2.load(request)
    }
    
                                          //6
}

extension WebViewViewController: WKNavigationDelegate {
    
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
         if let code = code(from: navigationAction) { //1
                //TODO: process code                     //2
                delegate?.webViewViewController(self, didAuthenticateWithCode: code)
             
                decisionHandler(.cancel) //3
          } else {
                decisionHandler(.allow) //4
            }
    }
    
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,                         //1
            let urlComponents = URLComponents(string: url.absoluteString),  //2
            urlComponents.path == "/oauth/authorize/native",                //3
            let items = urlComponents.queryItems,                           //4
            let codeItem = items.first(where: { $0.name == "code" })        //5
        {
            return codeItem.value                                           //6
        } else {
            return nil
        }
    }
}
