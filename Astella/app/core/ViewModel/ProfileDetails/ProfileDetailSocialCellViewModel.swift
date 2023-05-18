//
//  ProfileDetailSocialCellViewModel.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/18/23.
//

import Foundation


final class ProfileDetailSocialCellViewModel {
    public let socialLink : URL
    public let social : String
    public let isEditing : Bool
    
    init(socialLink: URL, social: String, isEditing : Bool) {
        self.socialLink = socialLink
        self.social = social
        self.isEditing = isEditing
    }
    
}
