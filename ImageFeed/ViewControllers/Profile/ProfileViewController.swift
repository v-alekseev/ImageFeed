//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Vitaly Alekseev on 15.05.2023.
//

import Foundation
import UIKit
import Kingfisher
import WebKit


final class ProfileViewController: UIViewController {
  
    
    private var exitButton: UIButton?
    private var profileImageView: UIImageView?
    private var gradientProfileImageView: CALayer?
    private var nameLabel: UILabel?
    private var gradientNameLabel: CALayer?
    private var idLabel: UILabel?
    private var gradientIdLabel: CALayer?
    private var descriptionLabel: UILabel?
    private var gradientDescriptionLabel: CALayer?
    
    private var oAuth2TokenStorage = OAuth2TokenStorage()
    private var profile = Profile.shared
    
    private var animationLayers = Set<CALayer>()
    
    
    @IBAction private func buttonExitTapped(_ sender: UIButton) {
        // тут так же чистим и keychain
        oAuth2TokenStorage.token = nil
        // Очишаем куки и другие данные сессии
        cleanWebData()
        // Переключаемся на SplashScreen
        switchToSplashScreen()
        
        dismiss(animated: true)
        
    }

    private func cleanWebData() {
       // Очищаем все куки из хранилища.
       HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
       // Запрашиваем все данные из локального хранилища.
       WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
          // Массив полученных записей удаляем из хранилища.
          records.forEach { record in
             WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
          }
       }
    }
    
    private func switchToSplashScreen() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        window.rootViewController = SplashViewController()
        window.makeKeyAndVisible()

    }
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    override func viewWillAppear(_ animated: Bool) {
        gradientProfileImageView = addGradient(view: profileImageView)
        gradientNameLabel = addGradient(view: nameLabel)
        gradientIdLabel = addGradient(view: idLabel)
        gradientDescriptionLabel = addGradient(view: descriptionLabel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypBlack
        // верстка экрана
        profileImageView = addProfileImage(UIImage(named: "Photo-1"))
        exitButton = addButtonExit()
        nameLabel = addNamelabel()
        idLabel = addIdlabel()
        descriptionLabel = addDescriptionlabel()
       
        

        
        //animationLayers.insert(gradient)
    
        // Обновлнени еданных на экране
        self.updateProfileDetails(profile: profile)
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.DidChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] pr in
                print("IMG pr = \(pr)")
                guard let self = self else { return }
                self.updateAvatar()
            }
        
        self.updateAvatar()
        
    }
    
    private func addGradient(view: UIView?) -> CAGradientLayer {
        ///////////////////
        /// делаем градиент
        ///
        let gradient = CAGradientLayer()
        let viewSize = view?.frame.size
        print("IMG addGradient size = \(viewSize)")
        gradient.frame = CGRect(origin: .zero, size: viewSize! )
        gradient.locations = [0, 0.1, 0.3]
        gradient.colors = [
            UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1).cgColor,
            UIColor(red: 0.531, green: 0.533, blue: 0.553, alpha: 1).cgColor,
            UIColor(red: 0.431, green: 0.433, blue: 0.453, alpha: 1).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        //gradient.cornerRadius = 35
        gradient.masksToBounds = true

        
        
        let gradientChangeAnimation = CABasicAnimation(keyPath: "locations")
        gradientChangeAnimation.duration = 1.0
        gradientChangeAnimation.repeatCount = .infinity
        gradientChangeAnimation.fromValue = [0, 0.1, 0.3]
        gradientChangeAnimation.toValue = [0, 0.8, 1]
        gradient.add(gradientChangeAnimation, forKey: "locationsChange")
        
        view?.layer.addSublayer(gradient)
        
        return gradient
    }
    
    private func updateAvatar() { 
        guard
            let profileImageURL = profile.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        
        let processor = RoundCornerImageProcessor(cornerRadius: 61)
        profileImageView?.kf.setImage(with: url, options: [.processor(processor)])
        
        // Remove animation
        //self.gradientProfileImageView?.removeFromSuperlayer()
    }
    
    private func updateProfileDetails(profile: Profile){
        nameLabel?.text = profile.name
        idLabel?.text = profile.loginName
        descriptionLabel?.text = profile.bio
    }
}

// расширение для верстки экрана
extension ProfileViewController {
    private func addProfileImage(_ image: UIImage?) -> UIImageView? {
        
        guard let image = image else { return nil}
        
        let profileView = UIImageView()
        profileView.translatesAutoresizingMaskIntoConstraints = false
        profileView.image = image
        profileView.layer.masksToBounds = true
        profileView.layer.cornerRadius = 35
        view.addSubview(profileView)
        profileView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        profileView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        profileView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        profileView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        
        return profileView
    }
    
    private func addButtonExit() -> UIButton? {
        
        guard let profileImageView = profileImageView else { return nil}
        
        let button = UIButton()
        button.setImage(UIImage(named: "exit"), for: .normal)
        button.addTarget(self, action: #selector(self.buttonExitTapped), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .ypRed
        view.addSubview(button)
        button.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24).isActive = true
        
      

        return button
    }
    
    private func addNamelabel() -> UILabel? {
        guard let profileImageView = profileImageView else { return nil}
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Екатерина Новикова"
        label.textColor = .ypWhite
        label.font = UIFont.boldSystemFont(ofSize: 23.0)
        view.addSubview(label)
        label.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8).isActive = true
        label.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor).isActive = true
    
    
        return label
    }
    
    private func addIdlabel() -> UILabel? {
        guard let profileImageView = profileImageView else { return nil}
        guard let nameLabel = nameLabel else { return nil}
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "@ekaterina_nov"
        label.textColor = .ypGray
        label.font = UIFont.systemFont(ofSize: 13.0)
        view.addSubview(label)
        label.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        label.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor).isActive = true
        
        

        return label
    }
    
    private func addDescriptionlabel() -> UILabel? {
        guard let profileImageView = profileImageView else { return nil}
        guard let idLabel = idLabel else { return nil }
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Hello, world!"
        label.textColor = .ypWhite
        label.font = UIFont.systemFont(ofSize: 13.0)
        view.addSubview(label)
        label.numberOfLines = 10
        label.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: 8).isActive = true
        label.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor).isActive = true
        
        return label
    }
    
    
    
}
