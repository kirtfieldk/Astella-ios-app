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
    public weak var delegate :ProfileDetailCellViewModelDelegate?
    
    init(usr : User, isEditing : Bool) {
        self.usr = usr
        self.isEditing = isEditing
    }
    
    public func grabInputValue() -> String {
        guard let delegate = delegate else {return ""}
        return delegate.grabInputValue()
    }
    
}

protocol ProfileDetailCellViewModelDelegate : AnyObject {
    func grabInputValue() -> String
}
