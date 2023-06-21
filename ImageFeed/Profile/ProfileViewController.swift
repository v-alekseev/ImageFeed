//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Vitaly Alekseev on 15.05.2023.
//

import Foundation
import UIKit


final class ProfileViewController: UIViewController {
    
    private var profileImageView: UIImageView?
    private var exitButton: UIButton?
    private var nameLabel: UILabel?
    private var idLabel: UILabel?
    private var descriptionLabel: UILabel?
    
    private var oAuth2TokenStorage = OAuth2TokenStorage()
    
    private var profileImageService =  ProfileImageService()
    
    private var profile = Profile.shared
    
    
    @IBAction private func buttonExitTapped(_ sender: UIButton) {
        print("IMG Button tapped!")
    }
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageView = addProfileImage(UIImage(named: "Photo-1"))
        exitButton = addButtonExit()
        nameLabel = addNamelabel()
        idLabel = addIdlabel()
        descriptionLabel = addDescriptionlabel()
        
        
        updateProfileDetails(profile: profile)
        
        profileImageServiceObserver = NotificationCenter.default    // 2
            .addObserver(
                forName: ProfileImageService.DidChangeNotification, // 3
                object: nil,                                        // 4
                queue: .main                                        // 5
            ) { [weak self] _ in
                print("IMG addObserver closer")
                guard let self = self else { return }
                self.updateAvatar()                                 // 6
            }
        
        updateAvatar()
        
    }
    
    private func updateAvatar() {                                   // 8
        print("IMG updateAvatar")
        guard
            let profileImageURL = profile.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        // TODO [Sprint 11] Обновить аватар, используя Kingfisher
        print("IMG updateAvatar \(url)")
    }
    
    private func updateProfileDetails(profile: Profile){
        nameLabel?.text = profile.name
        idLabel?.text = profile.loginName
        descriptionLabel?.text = profile.bio
    }
    
    private func addProfileImage(_ image: UIImage?) -> UIImageView? {
        
        guard let image = image else { return nil}
        
        let profileView = UIImageView()
        profileView.translatesAutoresizingMaskIntoConstraints = false
        profileView.image = image
        profileView.layer.masksToBounds = true
        profileView.layer.cornerRadius = 16
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
