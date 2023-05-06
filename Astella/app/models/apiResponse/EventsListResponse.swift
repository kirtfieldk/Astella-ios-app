//
//  EventsByCityResponse.swift
//  Astella
//
//  Created by Keith Kirtfield on 4/30/23.
//

import Foundation


struct EventList : Codable, Hashable {
    let info : InfoResponse
    let data : [Event]
}
