//
//  ProfileBioCollectionCell.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/5/23.
//

import UIKit

final class ProfileBioCollectionCell : UICollectionViewCell {
    static let cellIdentifier = "ProfileBioCollectionCell"
    private let user : User
    
    init(user : User) {
        self.user = user
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(with ) {
        
    }
    
    
}
