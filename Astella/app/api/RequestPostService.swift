//
//  RequestService.swift
//  Astella
//
//  Created by Keith Kirtfield on 4/30/23.
//

import Foundation



class RequestPostService : ObservableObject {
    private struct constants {
        static let Base_URL = "http://0.0.0.0:9000/api/v1/"
    }
    private let urlIds : AstellaUrlIds
    public let endpoint : AstellaEndpoints
    public let httpMethod : String
    public var httpBody : Codable
    private let queryParameters: [URLQueryItem]
    
    private var urlString : String {
        var urlString = constants.Base_URL + endpoint.rawValue
        if urlIds.eventId != "" {
            urlString += urlIds.eventId + "/"
        }
        if urlIds.userId != "" {
            urlString += urlIds.userId + "/"
        }
        if urlIds.messageId != "" {
            urlString += urlIds.messageId 
        }
        
        if !queryParameters.isEmpty {
            urlString += "?"
                    let argumentString = queryParameters.compactMap({
                        guard let value = $0.value else { return nil }
                        return "\($0.name)=\(value)"
                    }).joined(separator: "&")

            urlString += argumentString
        }
        return urlString
    }
    
    
    
    public var url : URL? {
        return URL(string: urlString)
    }
    
    public init(urlIds: AstellaUrlIds, endpoint : AstellaEndpoints, httpMethod : String,
                httpBody : Codable, queryParameters : [URLQueryItem]) {
        self.urlIds = urlIds
        self.endpoint = endpoint
        self.httpMethod = httpMethod
        self.httpBody = httpBody
        self.queryParameters = queryParameters
    }
    
}
