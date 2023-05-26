//
//  ProfileDetailSocialCellView.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/18/23.
//

import UIKit


final class ProfileDetailSocialCellView : UICollectionViewCell {
    static let cellIdentifier = "ProfileDetailSocialCellView"
    
    private let socialButton : UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.borderColor = UIColor.black.cgColor
        btn.layer.borderWidth = 1
        return btn
    }()
    
    private let label : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private let socialInput : UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        
        return field
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configuration(viewModel : ProfileDetailSocialCellViewModel) {
        viewModel.delegate = self
        if (viewModel.isEditing) {
            backgroundColor = UIColor(red: 21 / 255, green: 43 / 255, blue: 56 / 255, alpha: 1)
            label.text = viewModel.social.rawValue
            socialInput.text = viewModel.socialLink.absoluteString
            addSubviews(socialInput, label)
            addInputConstraint()
        } else {
            socialButton.setTitle(viewModel.social.rawValue, for: .normal)
            addSubview(socialButton)
            addBtnConstraint()
        }
        addColor(social: viewModel.social)
    }
    
    private func addColor(social : SocialMediaTypes) {
        switch social {
        case SocialMediaTypes.tiktok:
            label.backgroundColor = .black
            socialInput.backgroundColor = .black
            socialInput.textColor = .white
            label.textColor = .white
            socialButton.backgroundColor = .black
        case SocialMediaTypes.twitter:
            label.backgroundColor = .systemBlue
            socialInput.backgroundColor = .systemBlue
            socialButton.backgroundColor = .systemBlue
        case SocialMediaTypes.youtube:
            label.backgroundColor = .systemRed
            socialInput.backgroundColor = .systemRed
            socialButton.backgroundColor = .systemRed
        case SocialMediaTypes.instagram:
            label.backgroundColor = .systemPink
            socialInput.backgroundColor = .systemPink
            socialButton.backgroundColor = .systemPink
        case SocialMediaTypes.snapchat:
            label.backgroundColor = .systemYellow
            socialInput.backgroundColor = .systemYellow
            socialButton.backgroundColor = .systemYellow
        default:
            label.backgroundColor = .white
        }
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        socialButton.setTitle(nil, for: .normal)
        socialInput.text = nil
    }
    
    private func addBtnConstraint() {
        NSLayoutConstraint.activate([
            socialButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            socialButton.leftAnchor.constraint(equalTo: leftAnchor),
            socialButton.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }
    
    private func addInputConstraint() {
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            label.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
            label.widthAnchor.constraint(equalToConstant: 90),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),

            socialInput.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            socialInput.leftAnchor.constraint(equalTo: label.rightAnchor),
            socialInput.rightAnchor.constraint(equalTo: rightAnchor),
            socialInput.bottomAnchor.constraint(equalTo: bottomAnchor),

        ])
    }

}


extension ProfileDetailSocialCellView : ProfileDetailSocialCellViewModelDelegate {
    func grabInputValue() -> String {
        guard let txt = socialInput.text else {return ""}
        return txt
    }
}
