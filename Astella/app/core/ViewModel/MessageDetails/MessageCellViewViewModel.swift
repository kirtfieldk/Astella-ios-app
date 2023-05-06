//
//  MessageCellViewViewModel.swift
//  Astella
//
//  Created by Keith Kirtfield on 4/30/23.
//

import Foundation

final class MessageCellViewViewModel {
    let message : Message
    // MARK: - Init
    init(
        message : Message
    ) {
        self.message = message
    }
    
    public func fetchUserAvatar(completion : @escaping (Result<Data, Error>) -> Void) {
        guard let url =  URL(string: message.user.avatar_url)  else {
            completion(.failure(URLError(.badURL)))
            return
        }
        ImageManager.shared.downloadImage(url, completion: completion) 
        
    }

}
