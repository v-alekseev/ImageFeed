//
//  ProfileStorage.swift
//  ImageFeed
//
//  Created by Vitaly Alekseev on 20.06.2023.
//

import Foundation

class Profile{
    static let shared = Profile()
    
    private var first_name: String
    private var last_name: String
    
    var username: String
    var name: String {first_name + " " + last_name}
    var loginName: String {"@" + name}
    var bio: String
    
    var avatarURL: String? 
    
    private init() {
        username = ""
        first_name = ""
        last_name = ""
        bio = ""
        avatarURL = ""
        
        self.setData(username: nil, first_name: nil, last_name: nil, bio: nil)
    }
    
    func setData(data: ProfileResult){
        self.setData(username: data.userName, first_name: data.firsName, last_name: data.lastName, bio: data.bio)
    }
    
    func setData(username: String?, first_name: String?, last_name: String?, bio: String?){
        self.username = username ?? "No information" // тут обязательно выводить загрушку т.к. имя пользователя должно быть обязательно
        self.first_name = first_name ?? ""  // тут значение по умолчанию пустая сторока, т.к. пользователь может просто не указать имя
        self.last_name = last_name ?? "" // тут значение по умолчанию пустая сторока, т.к. пользователь может просто не указать фамилию
        self.bio = bio ?? "No information" // тут обязательно выводить загрушку т.к. в интерфейсе это смотриться лучше чем просто пустота
    }
    
    
}
