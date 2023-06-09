//
//  Event.swift
//  Astella
//
//  Created by Keith Kirtfield on 4/29/23.
//

import Foundation


struct Event : Hashable, Codable, Identifiable {
    let id : UUID
    let name : String
    let is_public : Bool
    let end_time: String
    let code : String
    let created : String
    let description : String
    let location_info : LocationInfo
    let user_id : String
}

struct EventPost : Codable {
    let name : String
    let is_public : Bool
    let code : String
    let description : String
    let duration : Int
    let location_info : LocationInfoPost
    let user_id : String
}
