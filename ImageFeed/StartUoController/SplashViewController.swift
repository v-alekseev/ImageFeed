//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Vitaly Alekseev on 03.06.2023.
//

import Foundation
import UIKit


final class SplashViewController: UIViewController {
    private let ShowImageListViewSegueIdentifier = "ShowImageListView"
    private let ShowAuthViewSegueIdentifier = "ShowAuthView"
    private let oAuth2TokenStorage = OAuth2TokenStorage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SplashViewController viewDidLoad")
        
        oAuth2TokenStorage.token = ""
        print("\(#function)(\(#line)) oAuth2TokenStorage.token = \(oAuth2TokenStorage.token)")
        print("\(#function)(\(#line)) oAuth2TokenStorage.code = \(oAuth2TokenStorage.code)")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("SplashViewController viewDidAppear")
        if oAuth2TokenStorage.token == "" {

            performSegue(withIdentifier: ShowAuthViewSegueIdentifier, sender: "")
        } else {
            performSegue(withIdentifier: ShowImageListViewSegueIdentifier, sender: "")
        }
        
    }
    
    // это нужно для белого шрифта в статус бар
    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case ShowImageListViewSegueIdentifier:
            
            let indexPath = sender as! String
            print("SplashViewController prepare ShowImageListViewSegueIdentifier + \(indexPath)")
        case ShowAuthViewSegueIdentifier:
            //let destinationViewController = segue.destination as! AuthViewController // 2
            //destinationViewController.delegate = self
            
            // Доберёмся до первого контроллера в навигации. Мы помним, что в программировании отсчёт начинается с 0?
             guard
                 let navigationController = segue.destination as? UINavigationController,
                 let viewController = navigationController.viewControllers[0] as? AuthViewController
                 //TODO переделать вызов navigationController.viewControllers.first
             else { fatalError("Failed to prepare for \(ShowAuthViewSegueIdentifier)") }
             
            viewController.delegate = self
            
            
            let indexPath = sender as! String
            print("SplashViewController prepare ShowAuthViewSegueIdentifier + \(indexPath)")
        default:
            super.prepare(for: segue, sender: sender)
        }
    }
    
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        print("SplashViewController/authViewController code = \(code)")
    }
    
    
}
