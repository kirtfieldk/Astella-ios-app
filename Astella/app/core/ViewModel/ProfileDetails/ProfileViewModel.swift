//
//  File.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/4/23.
//

import UIKit


final class ProfileViewModel : NSObject{
    private let user : User?
    private var profilePhotoCellModels : [ProfilePhotoCellViewModel] = []
    var photoList : [URL] = []
    enum SectionTypes {
        case photos(viewModel : [ProfilePhotoCellViewModel])
        case bio(viewModel : ProfileDetailCellViewModel)
    }
    public var sections : [SectionTypes] = []

    init(user : User) {
        self.user = user
        super.init()
        buildPhotoArray()
        setUpSections()
    }
    
    private func buildPhotoArray() {
        guard let user = user else {return}
        guard let photoOne = URL(string: user.img_one) else {
            return
        }
        photoList.append(photoOne)
        guard let photoTwo = URL(string: user.img_two) else {
            return
        }
        photoList.append(photoTwo)
        guard let photoThree = URL(string: user.img_three) else {
            return
        }
        photoList.append(photoThree)
    }

    public func setUpSections() {
        guard let user = user else {return}
        sections = [
            .photos(viewModel: photoList.compactMap({
                return ProfilePhotoCellViewModel(imageUrl: $0)
            })),
            .bio(viewModel: .init(usr: user)),
        ]
    }
    
    //MARK: - Creating Sections
    public func createProfileBioSection() -> NSCollectionLayoutSection {
        print("created section")
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1))
        )
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 10,
            trailing: 0)
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(150)),
            subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    //Rows
    public  func createProfilePhotoSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        )
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 2,
            bottom: 2,
            trailing: 2)
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(0.60)),
            subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        //scroll horizontal
//        section.orthogonalScrollingBehavior = .continuous
        //Snaps to next card
        section.orthogonalScrollingBehavior = .groupPaging

        return section
    }
    
}


//MARK: - Delegate + DataSource
extension ProfileViewModel : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = sections[section]
        switch sectionType {
        case .photos(viewModel: let self):
            return self.count
        case .bio(viewModel: _):
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds.width
        
        return CGSize(width: bounds , height: ( UIScreen.main.bounds.height * 0.50 ))
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = sections[indexPath.section]
        switch sectionType {
        case .photos(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ProfilePhotoCollectionViewCell.cellIdentifier,
                for: indexPath
            ) as? ProfilePhotoCollectionViewCell else {
                fatalError("Unsupported cell")
            }
            cell.configure(viewModel: viewModel[indexPath.row])
            return cell
        case .bio(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ProfileDetailCollectionCell.cellIdentifier,
                for: indexPath
            ) as? ProfileDetailCollectionCell else {
                fatalError("Unsupported cell")
            }
            cell.configure(with: viewModel)
            return cell
        }
    }
    
}
