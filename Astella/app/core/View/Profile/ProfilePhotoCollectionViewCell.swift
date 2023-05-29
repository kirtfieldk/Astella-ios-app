//
//  ProfilePictureCollectionViewCell.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/4/23.
//

import UIKit


final class ProfilePhotoCollectionViewCell : UICollectionViewCell {
    static let cellIdentifier = "ProfilePictureCollectionViewCell"
    private var viewModel : ProfilePhotoCellViewModel?

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
    
    private let uploadPhotoBtn : UIButton = {
        let btn = UIButton()
        let image = UIImage(systemName: "plus.circle")
        btn.setImage(image, for: .normal)
        btn.tintColor = .black
        btn.configuration = .tinted()
        btn.addTarget(self, action: #selector(uploadImage), for: .touchDown)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let removeImageBtn : UIButton = {
        let btn = UIButton()
        let image = UIImage(systemName: "x.square")
        btn.setImage(image, for: .normal)
        btn.tintColor = .systemRed
        btn.configuration = .borderedTinted()
        btn.addTarget(self, action: #selector(removeImage), for: .touchDown)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override init(frame : CGRect) {
        super.init(frame : frame)
        contentView.layer.masksToBounds = false
        ///Using content view helps with safe area
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func configure(viewModel : ProfilePhotoCellViewModel) {
        self.viewModel = viewModel
        self.viewModel?.delegate = self
        print("configured ProfilePhotoCollectionViewCell")
        imageView.image = viewModel.imageUrl
        if !viewModel.editing {
            contentView.addSubviews(imageView)
            addPhotoConstraints()
        } else {
            contentView.addSubviews(imageView, uploadPhotoBtn, removeImageBtn)
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(tapGestureRecognizer)
            addEmptyConstraints()
            backgroundColor = .systemGray
        }
        
    }
    
    func addPhotoConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
        ])
    }
    
    func addEmptyConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.bottomAnchor.constraint(equalTo: uploadPhotoBtn.topAnchor),
            uploadPhotoBtn.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            uploadPhotoBtn.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            uploadPhotoBtn.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            uploadPhotoBtn.heightAnchor.constraint(equalToConstant: 30),
            
            removeImageBtn.topAnchor.constraint(equalTo: contentView.topAnchor),
            removeImageBtn.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)


        ])
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
    }
    
    @objc
    private func uploadImage() {
        popupImagePicker()
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        popupImagePicker()
    }
    
    private func popupImagePicker() {
        guard let parent = findViewController() else {return}
        let vc = UIImagePickerController()
        vc.delegate = viewModel
        vc.sourceType = .photoLibrary
        vc.allowsEditing = true
        parent.present(vc, animated: true)
    }
    
    func getImage() -> UIImage? {
        return imageView.image
    }
    
    @objc
    func removeImage() {
        guard let viewModel = viewModel else {return}
        viewModel.imageUrl = nil
        viewModel.isEmpty = true
        imageView.image = nil
        
    }
    
}


extension ProfilePhotoCollectionViewCell : ProfilePhotoCellViewModelDelegate {
    func refreshImage(image : UIImage) {
        imageView.image = image
    }
    
    
}
