//
//  UserCollectionViewViewModel.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/3/23.
//

import UIKit

///View model logic for Display Brief overview of user
///Icon + username
final class UserCollectionViewCellViewModel {
    private let user : User
    private var isLoading : Bool = false

    init(user : User) {
        self.user = user
    }
    
    
}
