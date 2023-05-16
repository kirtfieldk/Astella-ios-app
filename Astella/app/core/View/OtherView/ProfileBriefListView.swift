//
//  ProfileBriefListView.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/11/23.
//

import UIKit

final class ProfileBriefListView : UIView {
    let viewModel : ProfileBriefListViewModel
    var collectionView : UICollectionView?
    
    init(frame: CGRect, viewModel : ProfileBriefListViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        let collectionView = viewModel.buildCollectionView()
        self.collectionView = collectionView
        addSubviews(collectionView)
        
        addConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addConstrains() {
        guard let collectionView = collectionView else {return}
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
        ])
    }
    
}
