//
//  ProfileView.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/5/23.
//

import UIKit



final class ProfileView : UIView {
    
    private let viewModel : ProfileViewModel
    public var collectionView : UICollectionView?
    
    private let nameLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 30, weight: .bold)
        return label
    }()
    
    private let settingButton : UIButton = {
        let btn = UIButton()
        let img = UIImage(systemName: "gear")
        btn.setImage(img, for: .normal)
        btn.addTarget(self, action: #selector(goToSettings), for: .touchDown)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    init(frame : CGRect, viewModel : ProfileViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        let collectionView = createCollectionView()
        self.collectionView = collectionView
        nameLabel.text = viewModel.getUserName()
        addSubviews(nameLabel, collectionView, settingButton)
        addConstraints()
    }

    // MARK: - INIT
    required init?(coder : NSCoder) {
        fatalError("Not Supported")
    }

    private func addConstraints() {
        guard let collectionView = collectionView else {return}
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor),
            nameLabel.leftAnchor.constraint(equalTo: leftAnchor),
            nameLabel.rightAnchor.constraint(equalTo: settingButton.leftAnchor),
            
            settingButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            settingButton.topAnchor.constraint(equalTo: topAnchor),
            settingButton.bottomAnchor.constraint(equalTo: collectionView.topAnchor),

            collectionView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    //MARK: - Register Cells
    private func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            return self.createSection(for : sectionIndex)
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        ///Input for our messageCell
        collectionView.register(
            ProfilePhotoCollectionViewCell.self,
            forCellWithReuseIdentifier: ProfilePhotoCollectionViewCell.cellIdentifier
        )
        collectionView.register(
            ProfileDetailCollectionCell.self,
            forCellWithReuseIdentifier: ProfileDetailCollectionCell.cellIdentifier
        )
        collectionView.register(
            ProfileDetailSocialCellView.self,
            forCellWithReuseIdentifier: ProfileDetailSocialCellView.cellIdentifier
        )
        return collectionView
    }
    
    private func createSection(for sectionIndex : Int) -> NSCollectionLayoutSection {
        let sectionTypes = viewModel.sections
        switch sectionTypes[sectionIndex]  {
        case .photos:
            return viewModel.createProfilePhotoSection()
        case .bio:
            return viewModel.createProfileBioSection()
        case .socials:
            return viewModel.createSocialsSection()
        }
        
    }
    
    @objc
    private func goToSettings() {
        viewModel.goToSettings()
    }

}
