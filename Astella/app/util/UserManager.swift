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
        guard let userId = userId else {return "077a6b0d-6a83-4ca0-8e2d-eea7e156b4b5"}
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
