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
    
    //MARK: - POST MSG
    func postMessage(msg : String, completion: @escaping (Result<MessageListResponse, Error>) -> Void) {
        UserLocationManager.shared.getUserLocation {[weak self] location in
            guard let eventId = self?.eventId, let userId = UUID(uuidString: UserManager.shared.getUserId()) else { return }
            let coords = location.coordinate
            print("posted message - USERID: \(UserManager.shared.getUserId()) EventId: \(eventId.uuidString)")
            let req = RequestPostService(
                urlIds:
                    AstellaUrlIds(userId: UserManager.shared.getUserId(), eventId: eventId.uuidString, messageId: ""),
                endpoint: AstellaEndpoints.POST_MESSAGE_TO_EVENT,
                httpMethod: "POST",
                httpBody: PostMessageToEventBody(
                    content: msg, user_id: userId,
                    parent_id: self?.parentId,
                    event_id: eventId, upvotes: 0, pinned: false,
                    latitude: coords.latitude, longitude: coords.longitude),
                queryParameters: [])
            AstellaService.shared.execute(req, expecting: MessageListResponse.self, completion: completion) 
        }
    }
    
    public func getMessageThread(msg : Message, page : String, completion: @escaping (Result<MessageListResponse, Error>) -> Void) {
        guard let eventId = eventId else {return}
        let req = RequestGetService(
            urlIds: AstellaUrlIds(userId: UserManager.shared.getUserId(), eventId: eventId.uuidString, messageId: msg.id.uuidString),
                        endpoint: AstellaEndpoints.GET_MESSAGE_THREAD,
            queryParameters: [URLQueryItem(name: "page", value: page)])
        AstellaService.shared.execute(req, expecting: MessageListResponse.self, completion: completion)
    }
    
    //MARK: - PIN MSG
    public func pinMessage(messageId : UUID, completion: @escaping (Result<MessageListResponse, Error>) -> Void) {
        guard let eventId = eventId else {return}
        AstellaService.shared.execute(
            RequestPostService(urlIds: AstellaUrlIds(userId: UserManager.shared.getUserId(),
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
            RequestPostService(urlIds: AstellaUrlIds(userId: UserManager.shared.getUserId(),
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
            let coords = location.coordinate
            let point = LocationBody(latitude: coords.latitude, longitude: coords.longitude)
            guard let event = self?.eventId?.uuidString else {return}
            AstellaService.shared.execute(
                RequestPostService(urlIds: AstellaUrlIds(userId: UserManager.shared.getUserId(), eventId: event, messageId: messageId.uuidString),
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
            let coords = location.coordinate
            let point = LocationBody(latitude: coords.latitude, longitude: coords.longitude)
            guard let event = self?.eventId?.uuidString else {return}
            AstellaService.shared.execute(
                RequestPostService(urlIds: AstellaUrlIds(userId: UserManager.shared.getUserId(), eventId: event, messageId: messageId.uuidString),
                                   endpoint: AstellaEndpoints.UNLIKE_MESSAGE_IN_EVENT,
                httpMethod: "DELETE",
                httpBody: point,
                queryParameters: []),
                expecting: MessageListResponse.self,
                completion: completion)
        }
    }
}
