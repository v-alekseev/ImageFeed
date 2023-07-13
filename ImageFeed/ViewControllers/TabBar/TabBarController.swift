//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Vitaly Alekseev on 22.06.2023.
//

import Foundation


import UIKit

final class TabBarController: UITabBarController {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let imagesListViewController = storyboard.instantiateViewController( withIdentifier: "ImagesListViewController" )
        
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "profile_Active"),
            selectedImage: nil
        )

        profileViewController.configure(ProfilePresenter())
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
