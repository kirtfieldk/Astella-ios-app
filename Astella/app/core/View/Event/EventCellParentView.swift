//
//  EventCellParentView.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/7/23.
//

import UIKit

class EventCellParentView : UICollectionViewCell {
    private let nameLabel : UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.contentMode = .scaleAspectFit
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel : UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.contentMode = .scaleAspectFit
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descLabel : UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.contentMode = .scaleAspectFit
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let publicLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.contentMode = .scaleAspectFit
        return label
    }()
    
    // MARK: - Init
    
    override init(frame : CGRect) {
        super.init(frame : frame)
        contentView.backgroundColor = .secondarySystemBackground
        ///Using content view helps with safe area
        contentView.addSubviews(nameLabel, dateLabel, descLabel, publicLabel)
        addConstraints()
    }
    
    func setUpLayers() {
        contentView.layer.shadowRadius = 5
        contentView.layer.shadowColor = UIColor.label.cgColor
        contentView.layer.shadowOpacity = 0.2
        contentView.layer.shadowOffset = CGSize(width: -4, height: 4)
    }
    
    required init?(coder : NSCoder) {
        fatalError("Not Supported")
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 2),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2),
            nameLabel.heightAnchor.constraint(equalToConstant: 30),
            dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            dateLabel.rightAnchor.constraint(equalTo: rightAnchor),
            publicLabel.leftAnchor.constraint(equalTo: leftAnchor),
            publicLabel.rightAnchor.constraint(equalTo: dateLabel.leftAnchor),
            publicLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            descLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor)
            
        ])
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setUpLayers()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        dateLabel.text = nil
        publicLabel.text = nil
    }
    
    public func configure(with viewModel : EventCellViewViewModel) {
        nameLabel.text = viewModel.event.name
        dateLabel.text = viewModel.event.created
        descLabel.text = viewModel.event.description
        if viewModel.isPublic {
            publicLabel.text = "Public"
            contentView.backgroundColor = .tertiaryLabel
        } else if viewModel.isMember {
            publicLabel.text = "Member"
            contentView.backgroundColor = .tertiaryLabel
        } else {
            publicLabel.text = "Private"
            contentView.backgroundColor = .gray
        }
    }
}
