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
        label.textColor = .black
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.contentMode = .scaleAspectFit
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let divider : UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //Called each time cell is dequed, best way is to background fetch
    func configuration(viewModel : UserCollectionViewCellViewModel) {
        nameLabel.text = viewModel.user.username
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.masksToBounds = true
        contentView.addSubviews(nameLabel, divider)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    override func prepareForReuse() {
        nameLabel.text = nil
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            divider.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            divider.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            divider.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            divider.heightAnchor.constraint(equalToConstant: 1),


        ])
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
