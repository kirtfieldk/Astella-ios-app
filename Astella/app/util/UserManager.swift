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
    public var userId : String?
    
    public func setUser(user : User) {
        self.user = user
    }
    
    func getUserId() -> String {
        guard let userId = userId else {return "db212c03-8d8a-4d36-9046-ab60ac5b250d"}
        return userId
    }
    
    func setUserId(userId : String) {
        self.userId = userId
    }
    
    public func getUser(completion : @escaping(Result<UserListResponse, Error>) -> Void) {
        let req = RequestGetService(urlIds: AstellaUrlIds(userId: UserManager.shared.getUserId(), eventId: "", messageId: ""), endpoint: AstellaEndpoints.GET_USER, queryParameters: [])
        AstellaService.shared.execute(req, expecting: UserListResponse.self, completion: completion) 
    }
}
