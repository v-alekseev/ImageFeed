//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Vitaly Alekseev on 15.05.2023.
//

import Foundation
import UIKit
import Kingfisher



// выносим в презентер
// 1 - очистка токена self.oAuth2TokenStorage.token = nil
//     очистка данных браузера private func cleanWebData() {
// 2 - Загрузка картинки profileImageView?.kf.setImage(with: url, options: [.processor(processor)])
// 3 - profile  private var profile = Profile.shared  перенести в presenter
//
// тесты
// 1 - вызывется clearSessionData()
// 2 - вызывается обновление картинки


public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    func updateProfileDetails()
    func updateAvatar()
}

final class ProfileViewController: UIViewController & ProfileViewControllerProtocol {
    
    private var exitButton: UIButton?
    private var profileImageView: UIImageView?
    private var nameLabel: UILabel?
    private var idLabel: UILabel?
    private var descriptionLabel: UILabel?
    
    var presenter: ProfilePresenterProtocol?
    
    private var profile = Profile.shared
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    
    @IBAction private func buttonExitTapped(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Пока, пока!", message: "Вы уверены что хотите выйти?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Выхожу точно", style: .default) { [weak self] _ in
            guard let self = self else { return }
            // очищаем токен и сессионные данные
            self.presenter?.clearSessionData()
            // Переключаемся на SplashScreen
            self.switchToSplashScreen()
            
            self.dismiss(animated: true)
        })
        alert.addAction(UIAlertAction(title: "Я, пожалуй, останусь", style: .default))
        
        self.present(alert, animated: true)
        
    }
    
    private func switchToSplashScreen() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        window.rootViewController = SplashViewController()
        window.makeKeyAndVisible()
    }
    
    func configure(_ presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
        presenter.view = self
        
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
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.DidChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] pr in
                guard let self = self else { return }
                self.presenter?.didUpdateAvatar()
            }
        presenter?.viewDidLoad()
    }
    
    func updateAvatar() {
        guard
            let profileImageURL = profile.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        
        let processor = RoundCornerImageProcessor(cornerRadius: 61)
        profileImageView?.kf.setImage(with: url, options: [.processor(processor)])
    }
    
    func updateProfileDetails() {
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
        button.accessibilityIdentifier = "LogoutButton"
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
        label.accessibilityIdentifier = "NameLastname"
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
        label.accessibilityIdentifier = "username"
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
