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
    
    weak var webViewDelegate: WebViewViewControllerDelegate?  = nil
    
    private var oAuth2Service = OAuth2Service()
    
    
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    @IBAction func didTapBackButton2(_ sender: UIButton) {
        webViewDelegate?.webViewViewControllerDidCancel(self)
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        webView.addObserver(
//            self,
//            forKeyPath: #keyPath(WKWebView.estimatedProgress),
//            options: .new,
//            context: nil)
//    }
//
//    override  func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//
//        webView.removeObserver(
//            self,
//            forKeyPath: #keyPath(WKWebView.estimatedProgress),
//            context: nil)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self  // WKNavigationDelegate
        
        updateProgress()
        
        
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
            options: [],
            changeHandler: { [weak self] _, _ in
                guard let self = self else { return }
                self.updateProgress()
            })
        
        webView.load(oAuth2Service.createCodeRequestURL())
        
        
    }
    
//    override func observeValue(
//        forKeyPath keyPath: String?,
//        of object: Any?,
//        change: [NSKeyValueChangeKey : Any]?,
//        context: UnsafeMutableRawPointer?
//    ) {
//        if keyPath == #keyPath(WKWebView.estimatedProgress) {
//            updateProgress()
//        } else {
//            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
//        }
//    }
    
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
    
    
}

extension WebViewViewController: WKNavigationDelegate {
    
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) {
            webViewDelegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
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
