//
//  ProfileSettingViewModel.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/18/23.
//

import UIKit

//MARK: - Protocol
protocol ProfileSettingViewModelDelegate : AnyObject {
    func pushToEditProfile()
}

final class ProfileSettingViewModel : NSObject {
    public var sections : [SectionTypes] = []
    public weak var delegate : ProfileSettingViewModelDelegate?
    enum SectionTypes {
        case editProfile(viewModel : [ProfileSettingCellViewModel])
    }

    override init() {
        super.init()
        setUpSections()
    }
    
    private func setUpSections() {
        sections = [
            .editProfile(viewModel: [ProfileSettingCellViewModel(setting: SettingTypes.editProfile)])
        ]
    }
    
    public func createSettingRowSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1))
        )
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 0,
            trailing: 0)
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(50)),
            subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}

extension ProfileSettingViewModel : UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = sections[section]
        switch sectionType {
        case .editProfile(let viewModel):
            return viewModel.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds.width
        
        return CGSize(width: bounds , height: ( UIScreen.main.bounds.height * 0.50 ))
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = sections[indexPath.section]
        switch sectionType {
        case .editProfile(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ProfileSettingViewCellCollectionViewCell.cellIdentifier,
                for: indexPath
            ) as? ProfileSettingViewCellCollectionViewCell else {
                fatalError("Unsupported cell")
            }
            let viewModel = viewModel[indexPath.row]
            viewModel.delegate = self
            cell.configure(viewModel: viewModel)
            return cell
        
        }
    }
}

extension ProfileSettingViewModel : ProfileSettingCellViewModelDelegate {
    func pushToEditProfile() {
        delegate?.pushToEditProfile()
    }
}
