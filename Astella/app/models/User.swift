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
    let description : String
    let ig : String
    let twitter : String
    let tiktok : String
    let avatar_url : String
    let img_one : String
    let img_two : String
    let img_three : String

    static let usr = User(id: UUID(),
                          created: "2023-05-03 19:20:53.237084",
                          username: "KeithK",
                          description: "MyDESC",
                          ig: "",
                          twitter: "",
                          tiktok: "",
                          avatar_url: "",
                          img_one: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
                          img_two: "https://rickandmortyapi.com/api/character/avatar/2.jpeg",
                          img_three: "https://rickandmortyapi.com/api/character/avatar/3.jpeg")
}

struct EmptyBody : Codable {
    
}

struct AddUserToEventBody : Codable {
    let code : String
    let latitude : Double
    let longitude : Double
}
