//
//  ProfileBioCollectionCell.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/5/23.
//

import UIKit

final class ProfileDetailCollectionCell : UICollectionViewCell {
    static let cellIdentifier = "ProfileDetailCollectionCell"
    
    private let nameLabel : UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.contentMode = .scaleAspectFit
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.layer.masksToBounds = true
        textView.textColor = UIColor.black
        textView.textAlignment = NSTextAlignment.left
        textView.dataDetectorTypes = UIDataDetectorTypes.all
        textView.layer.shadowOpacity = 0.5
        textView.isEditable = false
        return textView
        
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(nameLabel, textView)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        nameLabel.text = nil
        textView.text = nil
    }
    func configure(with viewModel : ProfileDetailCellViewModel) {
        nameLabel.text = viewModel.usr.username
        textView.text = viewModel.usr.description

    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
//            nameLabel.bottomAnchor.constraint(equalTo: textView.topAnchor),
            nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
//            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//            textView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
//            textView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
        ])
    }
    
}
