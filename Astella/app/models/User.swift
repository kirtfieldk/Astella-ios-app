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
    var youtube : String
    var snapchat : String
    var avatar_url : String
    var img_one : String
    var img_two : String
    var img_three : String
}

struct EmptyBody : Codable {
    
}

struct AddUserToEventBody : Codable {
    let code : String
    let latitude : Double
    let longitude : Double
}
