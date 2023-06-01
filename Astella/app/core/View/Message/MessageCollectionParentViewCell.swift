//
//  MessageCollectionParentViewCell.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/9/23.
//

import UIKit

class MessageCollectionParentViewCell : UICollectionViewCell {
    private var viewModel : MessageCellViewViewModel?
    public weak var delegate : MessageCollectionParentViewCellDelegate?
    public weak var vcDelegate : MessageCollectionParentViewToVcCellDelegate?
    private let iconImageView : UIImageView = {
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
    
    private let responseCount : UILabel = {
        let label = UILabel()
        label.textColor = .black
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
        content.isEditable = false
        content.contentInset = UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0)
        content.isUserInteractionEnabled = true
        return content
    }()
    
    private let userSignature : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 55 / 255, green: 140 / 255, blue: 118 / 255, alpha: 0.9)
        return view
    }()
    
    private let divider : UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let mainContentView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
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
        btn.tintColor = .lightGray
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let pinBtn : UIButton = {
        let btn = UIButton()
        let img = UIImage(systemName: "pin.fill")
        btn.setImage(img, for: .normal)
        btn.tintColor = .lightGray
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let upvoteCtn : UIButton = {
        let btn = UIButton(configuration: .plain())
        btn.configuration?.buttonSize = .medium
        btn.tintColor = .black
        btn.contentMode = .scaleAspectFit
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    // MARK: - Init
    
    override init(frame : CGRect) {
        super.init(frame : frame)
        contentView.layer.masksToBounds = true
        translatesAutoresizingMaskIntoConstraints = false

        ///Using content view helps with safe area
        contentView.addSubviews(userSignature, mainContentView, divider)
        mainContentView.addSubviews(content, upvoteArea, pinBtn)
        upvoteArea.addSubviews(upvoteBtn, upvoteCtn)
        userSignature.addSubviews(iconImageView, nameLabel, responseCount)
        addConstraints()
        setUpLayers()
    }
    
    func setUpLayers() {
        contentView.layer.cornerRadius = 10
    }
    
    required init?(coder : NSCoder) {
        fatalError("Not Supported")
    }
    //MARK: - Constraint
    private func addConstraints() {
        NSLayoutConstraint.activate([
            userSignature.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            userSignature.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            userSignature.bottomAnchor.constraint(equalTo: divider.topAnchor),
            userSignature.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.20),

            iconImageView.heightAnchor.constraint(equalToConstant: 30),
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
            iconImageView.topAnchor.constraint(equalTo: userSignature.topAnchor, constant: 0),
            iconImageView.leftAnchor.constraint(equalTo: userSignature.leftAnchor, constant: 0),
            iconImageView.bottomAnchor.constraint(equalTo: userSignature.bottomAnchor),


            nameLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor),
            nameLabel.rightAnchor.constraint(equalTo: responseCount.leftAnchor),
            nameLabel.topAnchor.constraint(equalTo: userSignature.topAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: userSignature.bottomAnchor),
            
            responseCount.trailingAnchor.constraint(equalTo: userSignature.trailingAnchor),
            responseCount.bottomAnchor.constraint(equalTo: userSignature.bottomAnchor),
            responseCount.widthAnchor.constraint(equalToConstant: 90),

            mainContentView.topAnchor.constraint(equalTo: topAnchor),
            mainContentView.leftAnchor.constraint(equalTo: leftAnchor, constant: 5),
            mainContentView.rightAnchor.constraint(equalTo: rightAnchor, constant: -5),
            mainContentView.bottomAnchor.constraint(equalTo: userSignature.topAnchor),
            
            content.topAnchor.constraint(equalTo: mainContentView.topAnchor),
            content.leftAnchor.constraint(equalTo: mainContentView.leftAnchor, constant: 5),
            content.bottomAnchor.constraint(equalTo: upvoteArea.topAnchor),
            content.rightAnchor.constraint(equalTo: pinBtn.leftAnchor),
            
            pinBtn.rightAnchor.constraint(equalTo: mainContentView.rightAnchor,constant: -15),
            pinBtn.topAnchor.constraint(equalTo: mainContentView.topAnchor, constant: 10),
//            pinBtn.widthAnchor.constraint(equalToConstant: 150),
//            content.widthAnchor.constraint(equalToConstant: mainContentView.bounds.width * 0.90),
            
            upvoteArea.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.20),
            upvoteArea.rightAnchor.constraint(equalTo: mainContentView.rightAnchor, constant: 0),
            upvoteArea.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor),
            upvoteArea.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier:  0.60),
            
            upvoteBtn.rightAnchor.constraint(equalTo: upvoteCtn.leftAnchor),
            upvoteBtn.bottomAnchor.constraint(equalTo: upvoteArea.bottomAnchor),
            upvoteBtn.topAnchor.constraint(equalTo: upvoteArea.topAnchor),
            
            upvoteCtn.rightAnchor.constraint(equalTo: upvoteArea.rightAnchor, constant: -10),
            upvoteCtn.bottomAnchor.constraint(equalTo: upvoteArea.bottomAnchor),
            upvoteCtn.topAnchor.constraint(equalTo: upvoteArea.topAnchor),

//            divider.topAnchor.constraint(equalTo: contentView.bottomAnchor),
            divider.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            divider.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            divider.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//            divider.topAnchor.constraint(equalTo: userSignature.bottomAnchor),
            divider.heightAnchor.constraint(equalToConstant: 1),


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
        upvoteCtn.configuration?.title = nil
        upvoteBtn.tintColor = .lightGray
        pinBtn.tintColor = .lightGray
        responseCount.text = nil

    }
    
    public func configuration(with viewModel : MessageCellViewViewModel) {
        nameLabel.text = viewModel.message.user.username
        content.text = viewModel.message.content
        upvoteCtn.configuration?.title = String(describing : (viewModel.message.up_votes))
        self.viewModel = viewModel
        guard let upvoted = viewModel.message.upvoted_by_user else {return}
        self.viewModel?.upvotedByUser = upvoted
        if viewModel.message.replies > 0 {
            responseCount.text = "replies \(viewModel.message.replies)"
        }
        
        upvoteBtn.isEnabled = true
        upvoteBtn.addTarget(self, action: #selector(upvoteMessage), for: .touchUpInside)
        pinBtn.addTarget(self, action: #selector(pinMessage), for: .touchDown)
        pinBtn.isEnabled = true
        upvoteCtn.addTarget(self, action: #selector(redirectToUpvoteUserList), for: .touchDown)
        upvoteCtn.isEnabled = true
        
        if upvoted {
            upvoteBtn.tintColor = .red
        }
        guard let pinned = viewModel.message.pinned_by_user else {return}
        self.viewModel?.pinnedByUser = pinned
        if pinned {
            pinBtn.tintColor = .yellow
        }
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
    //MARK: - ProfileListRedirect
    @objc
    func redirectToUpvoteUserList() {
        guard let msg = viewModel?.message else {return}
        vcDelegate?.redirectToUpvoteUserList(msg: msg)
    }
    
    //MARK: - Upvote
    @objc
    func upvoteMessage() {
        guard let viewModel = viewModel, let upvotedByUser = viewModel.upvotedByUser else {return}
        if !upvotedByUser {
            viewModel.upvoteMessage {[weak self] resp in
                switch resp {
                case .success(let res):
                    let msg = res.data[0]
                    DispatchQueue.main.async {
                        self?.upvoteBtn.tintColor = .red
                        self?.upvoteCtn.configuration?.title = String(describing: msg.up_votes)
                        self?.viewModel?.upvotedByUser = true
                        self?.delegate?.updateMessage(msg: msg)
                    }
                case .failure(let err):
                    print(String(describing: err))
                    
                }
            }
        } else {
            viewModel.downvoteMessage {[weak self] resp in
                switch resp {
                case .success(let res):
                    let msg = res.data[0]
                    DispatchQueue.main.async {
                        self?.upvoteBtn.tintColor = .lightGray
                        self?.upvoteCtn.configuration?.title = String(describing: msg.up_votes)
                        self?.viewModel?.upvotedByUser = false
                        self?.delegate?.updateMessage(msg: msg)
                    }
                case .failure(let err):
                    print(String(describing: err))
                    
                }
            }

        }
    }
    
    // MARK: - Pin Messages
    @objc
    private func pinMessage() {
        guard let viewModel = viewModel, let upvotedByUser = viewModel.pinnedByUser else {return}
        if upvotedByUser {
            viewModel.unpinMessage {[weak self] result in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        self?.pinBtn.tintColor = .lightGray
                        self?.viewModel?.pinnedByUser = false
                        self?.delegate?.fetchPinMessages()
                        self?.delegate?.deletePin(msg: data.data[0])
                        self?.delegate?.updateMessage(msg: data.data[0])
                    }
                case .failure(let err):
                    print(String(describing: err))
                }
            }
        } else {
            viewModel.pinMessage {[weak self] result in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        self?.pinBtn.tintColor = .yellow
                        self?.viewModel?.pinnedByUser = true
                        self?.delegate?.fetchPinMessages()
                        self?.delegate?.updateMessage(msg: data.data[0])
                    }
                case .failure(let err):
                    print(String(describing: err))
                }
            }
        }
    }
}

//MARK: - Protocol
protocol MessageCollectionParentViewCellDelegate : AnyObject {
    func fetchPinMessages()
    func updateMessage(msg : Message)
    func deletePin(msg : Message)
}

//MARK: - Connect to VC
protocol MessageCollectionParentViewToVcCellDelegate : AnyObject {
    func redirectToUpvoteUserList(msg : Message)
}
