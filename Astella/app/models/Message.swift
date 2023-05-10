//
//  Message.swift
//  Astella
//
//  Created by Keith Kirtfield on 4/29/23.
//

import Foundation

struct Message : Hashable, Codable, Identifiable {
    let id : UUID
    let content : String
    let user : User
    let event_id : UUID
    let created : String
    let parent_id : String
    let up_votes : Int
    let pinned : Bool
    let latitude : Double
    let longitude : Double
    
    static let msg = Message(id: UUID(), content: "Content 12", user: User.usr, event_id: UUID(uuidString: "ab77156d-e638-47cc-bee9-185b424b6600") ?? UUID(), created: "2023-05-03 14:20:53.237084", parent_id: "", up_votes: 20, pinned: true, latitude: 0.0, longitude: 0.0)
    
}

struct MessageFetchBody : Codable {
    let latitude : Float
    let longitude : Float
    let user_id : UUID
}


struct PostMessageToEventBody : Codable {
    let content : String
    let user_id : UUID
    let parent_id : UUID?
    let event_id : UUID
    let upvotes : Int
    let pinned : Bool
    let latitude : Double
    let longitude : Double

}
