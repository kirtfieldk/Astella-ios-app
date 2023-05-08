//
//  UsersCollectionViewCell.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/3/23.
//

import UIKit

final class UserCollectionViewCell : UICollectionViewCell {
    static let cellIdentifier = "UserCollectionViewCell"
    
    //Called each time cell is dequed, best way is to background fetch
    public func configure(with viewModel : UserCollectionViewCellViewModel) {
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemRed
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    private func setUpConstrains() {
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
}
