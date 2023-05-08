//
//  UserListResponse.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/2/23.
//

import Foundation


struct UserListResponse : Hashable, Codable {
    let info : InfoResponse
    let data : [User]
}
