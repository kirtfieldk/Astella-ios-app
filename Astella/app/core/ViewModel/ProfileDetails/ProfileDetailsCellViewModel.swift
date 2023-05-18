//
//  ProfileDetailsCellViewModel.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/5/23.
//

import Foundation


final class ProfileDetailCellViewModel {
    let usr : User
    let isEditing : Bool
    
    init(usr : User, isEditing : Bool) {
        self.usr = usr
        self.isEditing = isEditing
    }
}
