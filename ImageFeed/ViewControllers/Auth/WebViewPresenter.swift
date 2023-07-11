//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Vitaly Alekseev on 11.07.2023.
//

import Foundation
import UIKit

public protocol WebViewPresenterProtocol: AnyObject{
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
}

final class WebViewPresenter: WebViewPresenterProtocol {
    weak var view: WebViewViewControllerProtocol?
    private var oAuth2Service = OAuth2Service()
    
    func viewDidLoad() {
        guard let request = oAuth2Service.createCodeRequestURL() else { return }
        view?.load(request: request)
        didUpdateProgressValue(0) // set progressbar to 0 position
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
           let newProgressValue = Float(newValue)
           view?.setProgressValue(newProgressValue)
           
           let shouldHideProgress = shouldHideProgress(for: newProgressValue)
           view?.setProgressHidden(shouldHideProgress)
    }
       
    private func shouldHideProgress(for value: Float) -> Bool {
           abs(value - 1.0) <= 0.0001
    }
    
    func code(from url: URL) -> String? {
        if
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
}
