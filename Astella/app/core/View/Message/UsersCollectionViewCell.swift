//
//  UsersCollectionViewCell.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/3/23.
//

import UIKit

final class UserCollectionViewCell : UICollectionViewCell {
    static let cellIdentifier = "UserCollectionViewCell"
    
    private let nameLabel : UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 28, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    //Called each time cell is dequed, best way is to background fetch
    public func configure(with viewModel : UserCollectionViewCellViewModel) {
        nameLabel.text = viewModel.user.username
//        nameLabel.text = viewModel.user.username
        contentView.layer.masksToBounds = true
        setUpLayers()

        addSubviews(nameLabel)

        addConstraints()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .systemRed
        contentView.addSubviews(nameLabel)

        addConstraints()
        setUpLayers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
    }
    
    func setUpLayers() {
        contentView.layer.cornerRadius = 10
        contentView.layer.shadowRadius = 5
        contentView.layer.shadowColor = UIColor.label.cgColor
        contentView.layer.shadowOpacity = 0.2
        contentView.layer.shadowOffset = CGSize(width: -4, height: 4)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setUpLayers()
    }
    
}
