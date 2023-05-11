//
//  MessageDetailViewCell.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/11/23.
//

import UIKit

final class MessageDetailViewCell : MessageCollectionParentViewCell {
    static let cellIdentifier = "MessageDetailViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
