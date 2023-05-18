//
//  ProfileSocialLinksCellView.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/17/23.
//

import UIKit

final class ProfileSocialLinksCellView : UICollectionViewCell {
    static let cellIdentifier = "EventCreateMapViewCell"
    
    private var btn : UIButton = {
       let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private var socialInput : UITextField = {
       let input = UITextField()
        
        return input
    }()
    
    public func configuration(isEditing : Bool, url : String, social : String) {
        if isEditing {
            addSubviews(socialInput)
        } else {
            addSubviews(btn)
        }
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
    }
}
