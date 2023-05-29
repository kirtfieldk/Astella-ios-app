//
//  ProfileDetailSocialCellViewModel.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/18/23.
//

import Foundation


final class ProfileDetailSocialCellViewModel {
    public let socialLink : URL?
    public let social : SocialMediaTypes
    public let isEditing : Bool
    public weak var delegate : ProfileDetailSocialCellViewModelDelegate?
    public var socialString : String?
    
    init(socialLink: URL?, social: SocialMediaTypes, isEditing : Bool, socialString : String?) {
        self.socialLink = socialLink
        self.social = social
        self.isEditing = isEditing
        self.socialString = socialString
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
