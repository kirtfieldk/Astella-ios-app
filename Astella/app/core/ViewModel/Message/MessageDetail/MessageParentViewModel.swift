//
//  MessageParentViewModel.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/11/23.
//

import UIKit

class MessageParentViewModel : NSObject {
    private let eventId : UUID?
    private var parentId : UUID?
    
    init(eventId : UUID) {
        self.eventId = eventId
        self.parentId = nil
        super.init()
    }
    
    public func setParentId(parentId : UUID) {
        self.parentId = parentId
    }
    
    func postMessage(msg : String, completion: @escaping (Result<MessageListResponse, Error>) -> Void) {
        UserLocationManager.shared.getUserLocation {[weak self] location in
            guard let eventId = self?.eventId else { return }
            guard let userId = UUID(uuidString: "db212c03-8d8a-4d36-9046-ab60ac5b250d") else {return}
            let req = RequestPostService(
                urlIds:
                    AstellaUrlIds(userId: "db212c03-8d8a-4d36-9046-ab60ac5b250d", eventId: eventId.uuidString, messageId: ""),
                endpoint: AstellaEndpoints.POST_MESSAGE_TO_EVENT,
                httpMethod: "POST",
                httpBody: PostMessageToEventBody(
                    content: msg, user_id: userId,
                    parent_id: self?.parentId,
                    event_id: eventId, upvotes: 0, pinned: false,
                    latitude: 53.020485, longitude: -8.128898),
                queryParameters: [])
            AstellaService.shared.execute(req, expecting: MessageListResponse.self, completion: completion) 
        }
    }
    
    //MARK: - PIN MSG
    public func pinMessage(messageId : UUID, completion: @escaping (Result<MessageListResponse, Error>) -> Void) {
        guard let eventId = eventId else {return}
        AstellaService.shared.execute(
            RequestPostService(urlIds: AstellaUrlIds(userId: "db212c03-8d8a-4d36-9046-ab60ac5b250d",
                                                     eventId: eventId.uuidString,
                                                     messageId: messageId.uuidString),
                               endpoint: AstellaEndpoints.PIN_MESSAGE,
            httpMethod: "POST",
            httpBody: EmptyBody(),
            queryParameters: []),
            expecting: MessageListResponse.self,
            completion: completion)
    }
    
    public func unpinMessage(messageId : UUID, completion: @escaping (Result<MessageListResponse, Error>) -> Void) {
        guard let eventId = eventId else {return}
        AstellaService.shared.execute(
            RequestPostService(urlIds: AstellaUrlIds(userId: "db212c03-8d8a-4d36-9046-ab60ac5b250d",
                                                     eventId: eventId.uuidString, messageId:  messageId.uuidString),
                               endpoint: AstellaEndpoints.UNPIN_MESSAGE,
            httpMethod: "DELETE",
            httpBody: EmptyBody(),
            queryParameters: []),
            expecting: MessageListResponse.self,
            completion: completion)
    }
    // MARK: - LIKE MSG
    public func upvoteMessage(messageId : UUID, completion: @escaping (Result<MessageListResponse, Error>) -> Void) {
        UserLocationManager.shared.getUserLocation {[weak self] location in
            guard let eventId = self?.eventId else {return}
            let point = LocationBody(latitude: 53.020485, longitude: -8.128898)
            guard let event = self?.eventId?.uuidString else {return}
            AstellaService.shared.execute(
                RequestPostService(urlIds: AstellaUrlIds(userId: "db212c03-8d8a-4d36-9046-ab60ac5b250d", eventId: event, messageId: messageId.uuidString),
                                   endpoint: AstellaEndpoints.LIKE_MESSAGE_IN_EVENT,
                httpMethod: "POST",
                httpBody: point,
                queryParameters: []),
                expecting: MessageListResponse.self,
                completion: completion)
        }
    }
    
    public func downvoteMessage(messageId : UUID, completion: @escaping (Result<MessageListResponse, Error>) -> Void) {
        UserLocationManager.shared.getUserLocation {[weak self] location in
            let point = LocationBody(latitude: 53.020485, longitude: -8.128898)
            guard let event = self?.eventId?.uuidString else {return}
            AstellaService.shared.execute(
                RequestPostService(urlIds: AstellaUrlIds(userId: "db212c03-8d8a-4d36-9046-ab60ac5b250d", eventId: event, messageId: messageId.uuidString),
                                   endpoint: AstellaEndpoints.UNLIKE_MESSAGE_IN_EVENT,
                httpMethod: "DELETE",
                httpBody: point,
                queryParameters: []),
                expecting: MessageListResponse.self,
                completion: completion)
        }
    }
}
