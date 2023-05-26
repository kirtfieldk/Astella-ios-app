//
//  ProfileDetailSocialCellViewModel.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/18/23.
//

import Foundation


final class ProfileDetailSocialCellViewModel {
    public let socialLink : URL
    public let social : SocialMediaTypes
    public let isEditing : Bool
    public weak var delegate : ProfileDetailSocialCellViewModelDelegate?
    
    init(socialLink: URL, social: SocialMediaTypes, isEditing : Bool) {
        self.socialLink = socialLink
        self.social = social
        self.isEditing = isEditing
    }
    
    //MARK: - INOUT param
    public func grabInputValue() -> String {
        guard let delegate = delegate else {return ""}
        return delegate.grabInputValue()
    }
}

protocol ProfileDetailSocialCellViewModelDelegate : AnyObject {
    func grabInputValue() -> String
}
