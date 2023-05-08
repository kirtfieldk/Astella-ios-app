//
//  CityListResponse.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/1/23.
//

import Foundation

struct CityListResponse : Hashable, Codable {
    let info : InfoResponse
    let data : [Event]
}
