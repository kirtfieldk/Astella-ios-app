//
//  MessageCellView.swift
//  Astella
//
//  Created by Keith Kirtfield on 4/30/23.
//

import UIKit

final class MessageCellView : UICollectionViewCell {
    static let cellIdentifier = "MessageCellView"
    private let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
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
    // MARK: - Init
    
    override init(frame : CGRect) {
        super.init(frame : frame)
        contentView.backgroundColor = .secondarySystemBackground
        ///Using content view helps with safe area
        contentView.addSubviews(imageView, nameLabel, content)
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
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            content.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            content.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 2),
            content.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2),
            content.heightAnchor.constraint(equalToConstant: 30),
            nameLabel.topAnchor.constraint(equalTo: content.bottomAnchor, constant: 5),
            nameLabel.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 10),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            imageView.topAnchor.constraint(equalTo: content.bottomAnchor, constant: -2),
            imageView.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: -2),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
//            imageView.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 0.2)
            

        ])
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setUpLayers()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
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
                    self?.imageView.image = image
                }
            case .failure(let error):
                print(String(describing: error))
                break
            }
        }
        
    }
    
}
