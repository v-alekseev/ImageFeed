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


public protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    func load(request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
}

final class WebViewViewController: UIViewController & WebViewViewControllerProtocol {
    
    var presenter: WebViewPresenterProtocol? // TODO ??? weak ??? в этом случае presenter становиться nil  во viewDidLoad
    
    @IBOutlet private weak var progressView: UIProgressView!
    @IBOutlet private weak var webView: WKWebView!
    
    weak var webViewDelegate: WebViewViewControllerDelegate?  = nil
    
//    private var oAuth2Service = OAuth2Service()
    
    
    
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    @IBAction func didTapBackButton2(_ sender: UIButton) {
        webViewDelegate?.webViewViewControllerDidCancel(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self  // WKNavigationDelegate
        
        
        //self.presenter?.didUpdateProgressValue(self.webView.estimatedProgress) // перенесли в presenter
        
        
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] _, _ in
                 guard let self = self,
                       let presenter = self.presenter else { return }
                 //self.updateProgress()
                presenter.didUpdateProgressValue(self.webView.estimatedProgress)
             })
        
//        guard let request = oAuth2Service.createCodeRequestURL() else { return }
//        webView.load(request)
        if presenter == nil { print("IMG presenter = nil") }
        presenter?.viewDidLoad()
        
    }
    
    func load(request: URLRequest) {
        webView.load(request)
    }
    
    
//    private func updateProgress() {
//        progressView.progress = Float(webView.estimatedProgress)
//        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
//    }
    
    
    func setProgressValue(_ newValue: Float) {
        progressView.progress = newValue
    }

    func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
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
        
        if  let url = navigationAction.request.url {
            return presenter?.code(from: url)
        } else {
            return nil
        }
        
//
//        if
//            let url = navigationAction.request.url,
//            let urlComponents = URLComponents(string: url.absoluteString),
//            urlComponents.path == "/oauth/authorize/native",
//            let items = urlComponents.queryItems,
//            let codeItem = items.first(where: { $0.name == "code" })
//        {
//            return codeItem.value
//        } else {
//            return nil
//        }
    }
}
