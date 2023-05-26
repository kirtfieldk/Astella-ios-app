//
//  UserManager.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/17/23.
//

import Foundation


final class UserManager : NSObject {
    static let shared = UserManager()
    public var user : User?
    
    public func setUser(user : User) {
        self.user = user
    }
    
    func getUserId() -> String {
        return "db212c03-8d8a-4d36-9046-ab60ac5b250d"
    }
}
