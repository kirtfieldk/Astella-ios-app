//
//  MessageCellView.swift
//  Astella
//
//  Created by Keith Kirtfield on 4/30/23.
//

import UIKit

final class MessageCollectionViewCell : UICollectionViewCell {
    static let cellIdentifier = "MessageCollectionViewCell"
    private let iconImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "globe.americas")
        
        return imageView
    }()
    
    private let nameLabel : UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.contentMode = .scaleAspectFit
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let content : UILabel = {
       let content = UILabel()
        content.textAlignment = .left
        content.font = .systemFont(ofSize: 18, weight: .light)
        content.contentMode = .scaleAspectFit
        content.translatesAutoresizingMaskIntoConstraints = false
        return content
    }()
    
    private let userSignature : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .tertiarySystemBackground
        return view
    }()
    // MARK: - Init
    
    override init(frame : CGRect) {
        super.init(frame : frame)
        print("STARTUP")
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .secondarySystemBackground
        ///Using content view helps with safe area
        contentView.addSubviews(content, userSignature)
        userSignature.addSubviews(iconImageView, nameLabel)
        addConstraints()
    }
    
    func setUpLayers() {
        contentView.layer.cornerRadius = 10
        contentView.layer.shadowRadius = 5
        contentView.layer.shadowColor = UIColor.label.cgColor
        contentView.layer.shadowOpacity = 0.2
        contentView.layer.shadowOffset = CGSize(width: -4, height: 4)
    }
    
    required init?(coder : NSCoder) {
        fatalError("Not Supported")
    }
    //MARK: - Constraint
    private func addConstraints() {
        NSLayoutConstraint.activate([
            userSignature.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            userSignature.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            userSignature.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            userSignature.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.20),

            iconImageView.heightAnchor.constraint(equalToConstant: 30),
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
            iconImageView.topAnchor.constraint(equalTo: userSignature.topAnchor, constant: 0),
            iconImageView.leftAnchor.constraint(equalTo: userSignature.leftAnchor, constant: 0),
            
            nameLabel.leftAnchor.constraint(equalTo: userSignature.leftAnchor),
            nameLabel.rightAnchor.constraint(equalTo: userSignature.rightAnchor),
            nameLabel.topAnchor.constraint(equalTo: userSignature.topAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: userSignature.bottomAnchor),

            
            

        ])
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setUpLayers()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        nameLabel.text = nil
        content.text = nil
    }
    
    public func configuration(with viewModel : MessageCellViewViewModel) {
        nameLabel.text = viewModel.message.user.username
        content.text = viewModel.message.content
        print(viewModel.message.content)
        viewModel.fetchUserAvatar {[weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    self?.iconImageView.image = image
                }
            case .failure(let error):
                print(String(describing: error))
                break
            }
        }
        
    }
    
    func upvoteMessage() {
        
    }
    
}
