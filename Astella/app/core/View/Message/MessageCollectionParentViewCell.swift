//
//  MessageCollectionParentViewCell.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/9/23.
//

import UIKit

class MessageCollectionParentViewCell : UICollectionViewCell {
    private var viewModel : MessageCellViewViewModel?
    private let iconImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
//        imageView.image = UIImage(systemName: "globe.americas")
        
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
    
    private let content : UITextView = {
       let content = UITextView()
        content.textAlignment = .left
        content.font = .systemFont(ofSize: 18, weight: .light)
        content.contentMode = .scaleAspectFit
        content.translatesAutoresizingMaskIntoConstraints = false
        content.backgroundColor = .cyan
        content.layer.borderWidth = 2
        content.isEditable = false
        content.gestureRecognizers = nil
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(upvoteMessage))
        tapRecognizer.numberOfTapsRequired = 2;
        content.addGestureRecognizer(tapRecognizer)
        content.contentInset = UIEdgeInsets(top: 2, left: 10, bottom: 2, right: 0)
        return content
    }()
    
    private let userSignature : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .tertiarySystemBackground
        return view
    }()
    
    private let upvoteArea : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let upvoteBtn : UIButton = {
        let btn = UIButton()
        let img = UIImage(systemName: "heart.fill")
        btn.setImage(img, for: .normal)
        btn.addTarget(self, action: #selector(upvoteMessage), for: .touchDown)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let upvoteCtn : UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.contentMode = .scaleAspectFit
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    
    override init(frame : CGRect) {
        super.init(frame : frame)
        print("STARTUP")
        contentView.layer.masksToBounds = true

        ///Using content view helps with safe area
        contentView.addSubviews(content, userSignature, upvoteArea)
        upvoteArea.addSubviews(upvoteBtn, upvoteCtn)
        userSignature.addSubviews(iconImageView, nameLabel)
        addConstraints()
        setUpLayers()
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
            iconImageView.bottomAnchor.constraint(equalTo: userSignature.bottomAnchor),


            nameLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor),
            nameLabel.rightAnchor.constraint(equalTo: userSignature.rightAnchor),
            nameLabel.topAnchor.constraint(equalTo: userSignature.topAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: userSignature.bottomAnchor),

            
            content.topAnchor.constraint(equalTo: topAnchor),
            content.leftAnchor.constraint(equalTo: leftAnchor, constant: 25),
            content.bottomAnchor.constraint(equalTo: upvoteArea.topAnchor),
            content.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.60),
            
            upvoteArea.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.20),
            upvoteArea.rightAnchor.constraint(equalTo: rightAnchor, constant: 0),
            upvoteArea.bottomAnchor.constraint(equalTo: userSignature.topAnchor),
            upvoteArea.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.60),
            
            upvoteBtn.rightAnchor.constraint(equalTo: upvoteCtn.leftAnchor),
            upvoteBtn.bottomAnchor.constraint(equalTo: upvoteArea.bottomAnchor),
            upvoteBtn.topAnchor.constraint(equalTo: upvoteArea.topAnchor),
            
            upvoteCtn.rightAnchor.constraint(equalTo: upvoteArea.rightAnchor),
            upvoteCtn.bottomAnchor.constraint(equalTo: upvoteArea.bottomAnchor),
            upvoteCtn.topAnchor.constraint(equalTo: upvoteArea.topAnchor),

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
        upvoteCtn.text = nil
    }
    
    public func configuration(with viewModel : MessageCellViewViewModel) {
        nameLabel.text = viewModel.message.user.username
        content.text = viewModel.message.content
        upvoteCtn.text = String(describing : (viewModel.message.up_votes))
        self.viewModel = viewModel
//        viewModel.fetchUserAvatar {[weak self] result in
//            switch result {
//            case .success(let data):
//                DispatchQueue.main.async {
//                    let image = UIImage(data: data)
//                    self?.iconImageView.image = image
//                }
//            case .failure(let error):
//                print(String(describing: error))
//                break
//            }
//        }
        
    }
    
    //MARK: - Upvote
    @objc
    func upvoteMessage() {
        guard let viewModel = viewModel else {return}
        viewModel.upvoteMessage {[weak self] resp in
            switch resp {
            case .success(let res):
                let msg = res.data[0]
                DispatchQueue.main.async {
                    self?.upvoteBtn.tintColor = .red
                    self?.upvoteCtn.text = String(describing: msg.up_votes)
                }
            case .failure(let err):
                print(String(describing: err))
                        
            }
        }
    }
}
