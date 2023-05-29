//
//  User.swift
//  Astella
//
//  Created by Keith Kirtfield on 4/29/23.
//

import Foundation


struct User : Hashable, Codable, Identifiable {
    let id : UUID
    let created : String
    let username : String
    var description : String
    var ig : String
    var twitter : String
    var tiktok : String
    var avatar_url : String
    var img_one : String
    var img_two : String
    var img_three : String

    static let usr = User(id: UUID(),
                          created: "2023-05-03 19:20:53.237084",
                          username: "KeithK",
                          description: "MyDESC",
                          ig: "igTwi",
                          twitter: "Twitter",
                          tiktok: "TikTok",
                          avatar_url: "",
                          img_one: "img_one.png",
                          img_two: "img_two.png",
                          img_three: "img_three.png")
}

struct EmptyBody : Codable {
    
}

struct AddUserToEventBody : Codable {
    let code : String
    let latitude : Double
    let longitude : Double
}
