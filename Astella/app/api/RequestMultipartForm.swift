//
//  HttpReqMultipartForm.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/26/23.
//

import UIKit


final class RequestMultipartForm : ObservableObject {
    private struct constants {
        static let BASE_URL = "http://0.0.0.0:9000/api/v1/"
    }
    
    private let urlIds : AstellaUrlIds
    private let endpoint : AstellaEndpoints
    let httpMethod : String
    private let paramMap : [String : String]
    private let paramFileMap : [String : UIImage?]
    public let boundary = "Boundary-\(UUID().uuidString)"

    
    private var urlString : String {
        var urlString = constants.BASE_URL + endpoint.rawValue
        if urlIds.eventId != "" {
            urlString += urlIds.eventId 
        }
        if urlIds.userId != "" {
            urlString += urlIds.userId
        }
        if urlIds.messageId != "" {
            urlString += urlIds.messageId
        }
        
        return urlString
    }
    
    public var url : URL? {
        return URL(string: urlString)
    }
    
    init(urlIds: AstellaUrlIds, endpoint: AstellaEndpoints, httpMethod: String, paramMap : [String : String], paramFileMap : [String : UIImage?]) {
        self.urlIds = urlIds
        self.endpoint = endpoint
        self.httpMethod = httpMethod
        self.paramMap = paramMap
        self.paramFileMap = paramFileMap
    }
    
    public func createMultipartFormData() -> Data {
        var data = Data()
        let lineBreak = "\r\n"
        let fromName = "astella"
        
        data.append("--\(boundary + lineBreak)")
        data.append("Content-Disposition: form-data; name=\"fromName\"\(lineBreak + lineBreak)")
        data.append("\(fromName + lineBreak)")
        for (key, value) in paramMap {
            data.append("--\(boundary + lineBreak)")
            data.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak)\(lineBreak)")
            data.append(value)
            data.append(lineBreak)
        }
        
        for (key, value) in paramFileMap {
            guard let value = value, let imageData = value.pngData() else {continue}
            data.append("--\(boundary + lineBreak)")
            data.append("Content-Disposition: form-data; name=\"\(key).png\"; filename=\"\(key).png\"\(lineBreak)")
            data.append("Content-Type: image/png\(lineBreak + lineBreak)")
            data.append(imageData)
            data.append(lineBreak)
        }
        data.append("--\(boundary)--\(lineBreak)")
        
        return data
    }
}
