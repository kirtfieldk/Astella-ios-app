//
//  MessageCellViewViewModel.swift
//  Astella
//
//  Created by Keith Kirtfield on 4/30/23.
//

import Foundation

final class MessageCellViewViewModel {
    var message : Message
    let eventId : UUID
    // MARK: - Init
    init(
        message : Message,
        eventId : UUID
    ) {
        self.message = message
        self.eventId = eventId
    }
    
    public func fetchUserAvatar(completion : @escaping (Result<Data, Error>) -> Void) {
        guard let url =  URL(string: message.user.avatar_url)  else {
            completion(.failure(URLError(.badURL)))
            return
        }
        ImageManager.shared.downloadImage(url, completion: completion)
    }
    
    //Need to upvote message
    public func upvoteMessage(completion: @escaping (Result<MessageListResponse, Error>) -> Void) {
        UserLocationManager.shared.getUserLocation {[weak self] location in
            let point = LocationBody(latitude: 53.020485, longitude: -8.128898)
            guard let messageId = self?.message.id.uuidString else {return}
            guard let event = self?.eventId.uuidString else {return}
            AstellaService.shared.execute(
                RequestPostService(urlIds: AstellaUrlIds(userId: "db212c03-8d8a-4d36-9046-ab60ac5b250d", eventId: event, messageId: messageId),
                endpoint: AstellaEndpoints.LIKE_MESSAGE_IN_EVENT,
                httpMethod: "POST",
                httpBody: point,
                queryParameters: []),
                expecting: MessageListResponse.self,
                completion: completion)
        }
    }
        

}
