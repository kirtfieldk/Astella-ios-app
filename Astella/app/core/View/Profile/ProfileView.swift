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
    
    
    init(frame : CGRect, viewModel : ProfileViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        let collectionView = createCollectionView()
        self.collectionView = collectionView
        //Do not need view since we are already in view
        addSubviews(collectionView)
//        setupCollectionView()
        addConstraints()
    }

    // MARK: - INIT
    required init?(coder : NSCoder) {
        fatalError("Not Supported")
    }

    private func addConstraints() {
        guard let collectionView = collectionView else {return}
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
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

        return collectionView
    }
    
    private func createSection(for sectionIndex : Int) -> NSCollectionLayoutSection {
        let sectionTypes = viewModel.sections
        switch sectionTypes[sectionIndex]  {
        case .photos:
            return viewModel.createProfilePhotoSection()
        case .bio:
            return viewModel.createProfileBioSection()
        }
        
    }
    
    ///Set the data source, for this project the data will come from view models
//    private func setupCollectionView() {
//        guard let collectionView = collectionView else {return}
//        print("Created collectionView")
//        collectionView.delegate = viewModel
//        collectionView.dataSource = viewModel
//
//    }
}
