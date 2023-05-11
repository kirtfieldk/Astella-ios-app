//
//  MessageCellViewViewModel.swift
//  Astella
//
//  Created by Keith Kirtfield on 4/30/23.
//

import Foundation

final class MessageCellViewViewModel : MessageParentViewModel{
    var message : Message
    let eventId : UUID
    public var upvotedByUser : Bool?
    public var pinnedByUser : Bool?
    // MARK: - Init
    init(
        message : Message,
        eventId : UUID
    ) {
        self.message = message
        self.eventId = eventId
        super.init(eventId: eventId)
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
        super.upvoteMessage(messageId: message.id, completion: completion)
    }
    
    public func downvoteMessage(completion: @escaping (Result<MessageListResponse, Error>) -> Void) {
        super.downvoteMessage(messageId: message.id, completion: completion)

    }
    
    public func pinMessage(completion: @escaping (Result<MessageListResponse, Error>) -> Void) {
        super.pinMessage(messageId: message.id, completion: completion)
    }
    
    public func unpinMessage(completion: @escaping (Result<MessageListResponse, Error>) -> Void) {
        super.unpinMessage(messageId: message.id, completion: completion)
    }
        

}
