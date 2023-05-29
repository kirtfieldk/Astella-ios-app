//
//  DataExtension.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/26/23.
//

import Foundation


extension Data {
    
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}
