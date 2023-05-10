//
//  MessageCellView.swift
//  Astella
//
//  Created by Keith Kirtfield on 4/30/23.
//

import UIKit

final class MessageCollectionViewCell : MessageCollectionParentViewCell {
    static let cellIdentifier = "MessageCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
