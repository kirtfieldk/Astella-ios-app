//
//  EventPasswordInputViewController.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/6/23.
//

import UIKit

final class EventPasswordInputViewModel {
    
    
    public let event : Event
    
    init(event : Event) {
        self.event = event
    }
    
    required init?(coder : NSCoder) {
        fatalError("Not Supported")
    }
    
    func submitPassword(password : String, completion : @escaping (Result<BooleanResponse, Error>) -> Void) {
        UserLocationManager.shared.getUserLocation {[weak self] location in
            guard let eventId = self?.event.id.uuidString else {return}
            let req = RequestPostService(
                urlIds: AstellaUrlIds(userId: "db212c03-8d8a-4d36-9046-ab60ac5b250d", eventId: eventId, messageId: ""),
                endpoint: AstellaEndpoints.ADD_USER_TO_EVENT,
                httpMethod: "POST",
                httpBody: AddUserToEventBody(code: password,
                                             latitude: 53.020485,
                                             longitude: -8.128898),
                queryParameters: [])
            AstellaService.shared.execute(req, expecting: BooleanResponse.self, completion: completion)
            
        }
    }
}
