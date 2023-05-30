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
    
    @IBOutlet private weak var progressView: UIProgressView!
    @IBOutlet private weak var webView: WKWebView!
    
    weak var delegate: WebViewViewControllerDelegate?  = nil
    
    @IBAction func didTapBackButton2(_ sender: UIButton) {
        delegate?.webViewViewControllerDidCancel(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("addObserver()")
        webView.addObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            options: .new,
            context: nil)
        

    }
    
    override  func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        print("removeObserver()")
        
        webView.removeObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            context: nil)
        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        webView.navigationDelegate = self
        
        let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
        
        var urlComponents = URLComponents(string: UnsplashAuthorizeURLString)!  //1
        urlComponents.queryItems = [
           URLQueryItem(name: "client_id", value: AccessKey),                  //2
           URLQueryItem(name: "redirect_uri", value: RedirectURI),             //3
           URLQueryItem(name: "response_type", value: "code"),                 //4
           URLQueryItem(name: "scope", value: AccessScope)                     //5
         ]
        let url = urlComponents.url!
        
        updateProgress()
        
        let request = URLRequest(url: url)
        webView.load(request)
        
    }
    
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            
            updateProgress()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

    private func updateProgress() {
        print("webView.estimatedProgress = \(webView.estimatedProgress)")
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
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
