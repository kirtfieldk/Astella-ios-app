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
    let upvoted_by_user : Bool?
    let pinned : Bool
    let pinned_by_user : Bool?
    let latitude : Double
    let longitude : Double
    let replies : Int
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
