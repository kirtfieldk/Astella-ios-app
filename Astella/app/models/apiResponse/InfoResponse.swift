//
//  InfoResponse.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/2/23.
//

import Foundation


struct InfoResponse : Codable, Hashable {
    let page : Int
    let total : Int
    let count : Int
    let next : Bool
}
