//
//  ProfileStorage.swift
//  ImageFeed
//
//  Created by Vitaly Alekseev on 20.06.2023.
//

import Foundation


class Profile: CustomStringConvertible{
    static let shared = Profile()
    
    private var firstName: String
    private var lastName: String
    
    var username: String
    var name: String {firstName + " " + lastName}
    var loginName: String {"@" + username}
    var bio: String
    
    var avatarURL: String?
    
    var description: String {
        return String("\(username)| \(name)| \(loginName)| \(String(describing: avatarURL))| \(bio)")
    }
    
    private init() {
        username = ""
        firstName = ""
        lastName = ""
        bio = ""
        avatarURL = ""
        
        self.setData(username: nil, firstName: nil, lastName: nil, bio: nil)
    }
    
    func setData(data: ProfileResult){
        self.setData(username: data.username, firstName: data.firstName, lastName: data.lastName, bio: data.bio)
    }
    
    func setData(username: String?, firstName: String?, lastName: String?, bio: String?){
        self.username = username ?? "No information" // тут обязательно выводить загрушку т.к. имя пользователя должно быть обязательно
        self.firstName = firstName ?? ""  // тут значение по умолчанию пустая сторока, т.к. пользователь может просто не указать имя
        self.lastName = lastName ?? "" // тут значение по умолчанию пустая сторока, т.к. пользователь может просто не указать фамилию
        self.bio = bio ?? "No information" // тут обязательно выводить загрушку т.к. в интерфейсе это смотриться лучше чем просто пустота
    }
    
    
}
