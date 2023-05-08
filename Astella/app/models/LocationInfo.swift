//
//  LocationInfo.swift
//  Astella
//
//  Created by Keith Kirtfield on 4/29/23.
//

import Foundation


struct LocationInfo : Hashable, Codable, Identifiable {
    let id : UUID
    let top_left_lat : Double
    let top_left_lon : Double
    let top_right_lat: Double
    let top_right_lon : Double
    let bottom_left_lat : Double
    let bottom_left_lon : Double
    let bottom_right_lat : Double
    let bottom_right_lon : Double
    
}
