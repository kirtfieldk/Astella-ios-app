//
//  ProfilePictureCollectionViewCell.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/4/23.
//

import UIKit


final class ProfilePhotoCollectionViewCell : UICollectionViewCell {
    static let cellIdentifier = "ProfilePictureCollectionViewCell"

    var imageView : UIImageView = {
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
    
    override init(frame : CGRect) {
        super.init(frame : frame)
        contentView.layer.masksToBounds = false
        ///Using content view helps with safe area
        addSubviews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        contentView.addSubviews(imageView,nameLabel)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func configure(viewModel : ProfilePhotoCellViewModel) {
        viewModel.fetchImage {[weak self] data in
            switch data {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.imageView.image = UIImage(data: data)
                }
            case .failure(let err):
                print(String(describing: err))
                print("ERROR")
                break
            }
        }
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
        ])
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
    }
    
}
