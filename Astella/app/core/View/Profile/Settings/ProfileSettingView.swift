//
//  ProfileSettingView.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/18/23.
//

import UIKit

final class ProfileSettingView : UIView {
    private let viewModel : ProfileSettingViewModel
    public var collectionView : UICollectionView?
    
    init(frame: CGRect, viewModel : ProfileSettingViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        let collectionView = createCollectionView()
        self.collectionView = collectionView
        addSubview(collectionView)
        addConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addConstraint() {
        guard let collectionView = collectionView else {return}
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),

        ])
    }
    
    private func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            return self.createSection(for : sectionIndex)
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(
            ProfileSettingViewCellCollectionViewCell.self,
            forCellWithReuseIdentifier: ProfileSettingViewCellCollectionViewCell.cellIdentifier
        )
        return collectionView
    }
    
    private func createSection(for sectionIndex : Int) -> NSCollectionLayoutSection {
        let sectionTypes = viewModel.sections
        switch sectionTypes[sectionIndex]  {
        case .editProfile:
            return viewModel.createSettingRowSection()
        }
    }
}
