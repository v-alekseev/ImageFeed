//
//  ProfileImageServiceModel.swift
//  ImageFeed
//
//  Created by Vitaly Alekseev on 20.06.2023.
//

import Foundation

struct UserResult: Codable {
    var profile_image: ProfileImage
}

struct ProfileImage: Codable{
    var small: String
}


// GET /users/:username
//{
//  "id": "pXhwzz1JtQU",
//  "updated_at": "2016-07-10T11:00:01-05:00",
//  "username": "jimmyexample",
//  "name": "James Example",
//  "first_name": "James",
//  "last_name": "Example",
//  "instagram_username": "instantgrammer",
//  "twitter_username": "jimmy",
//  "portfolio_url": null,
//  "bio": "The user's bio",
//  "location": "Montreal, Qc",
//  "total_likes": 20,
//  "total_photos": 10,
//  "total_collections": 5,
//  "followed_by_user": false,
//  "followers_count": 300,
//  "following_count": 25,
//  "downloads": 225974,
//  "social": {
//    "instagram_username": "instantgrammer",
//    "portfolio_url": "",
//    "twitter_username": "jimmy"
//  },
//  "profile_image": {
//    "small": "https://images.unsplash.com/face-springmorning.jpg?q=80&fm=jpg&crop=faces&fit=crop&h=32&w=32",
//    "medium": "https://images.unsplash.com/face-springmorning.jpg?q=80&fm=jpg&crop=faces&fit=crop&h=64&w=64",
//    "large": "https://images.unsplash.com/face-springmorning.jpg?q=80&fm=jpg&crop=faces&fit=crop&h=128&w=128"
//  },
//  "badge": {
//    "title": "Book contributor",
//    "primary": true,
//    "slug": "book-contributor",
//    "link": "https://book.unsplash.com"
//  },
//  "links": {
//    "self": "https://api.unsplash.com/users/jimmyexample",
//    "html": "https://unsplash.com/jimmyexample",
//    "photos": "https://api.unsplash.com/users/jimmyexample/photos",
//    "likes": "https://api.unsplash.com/users/jimmyexample/likes",
//    "portfolio": "https://api.unsplash.com/users/jimmyexample/portfolio"
//  }
//}
