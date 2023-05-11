//
//  MessageCollectionPinnedViewCell.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/9/23.
//

import UIKit

final class MessageCollectionPinnedViewCell : MessageCollectionParentViewCell {
    static let cellIdentifier = "MessageCollectionPinnedViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
