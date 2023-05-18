//
//  File.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/4/23.
//

import UIKit


final class ProfileViewModel : NSObject{
    public let user : User?
    private let isEditing : Bool
    public weak var delegate : ProfileViewModelDelegate?
    var photoList : [URL] = []
    var socialMap : [String : URL] = [:]
    enum SectionTypes {
        case photos(viewModel : [ProfilePhotoCellViewModel])
        case bio(viewModel : ProfileDetailCellViewModel)
        case socials(viewModel : [ProfileDetailSocialCellViewModel])
    }
    public var sections : [SectionTypes] = []

    //MARK: - INIT PhotoArray SocialArray
    init(user : User, isEditing : Bool) {
        self.user = user
        self.isEditing = isEditing
        super.init()
        buildPhotoArray(images: [user.img_one, user.img_two, user.img_three])
        buildSocialArray()
        setUpSections()
    }
    
    private func buildPhotoArray(images : [String?]) {
        images.forEach { img in
            buildPhotoArray(img: img)
        }
    }
    
    private func buildPhotoArray(img : String?) {
        guard let img = img else {return}
        guard let photo = URL(string: img) else {
            return
        }
        photoList.append(photo)
    }
    //MARK: - Build social map
    private func buildSocialArray() {
        for media in SocialMediaTypes.allCases {
            switch media {
            case .twitter:
                buildSocialArray(social: media.rawValue, url: user?.twitter)
            case .instagram:
                buildSocialArray(social: media.rawValue, url: user?.ig)
            case .tiktok:
                buildSocialArray(social: media.rawValue, url: user?.tiktok)
            case .snapchat:
                buildSocialArray(social: media.rawValue, url: user?.twitter)
            case .youtube:
                buildSocialArray(social: media.rawValue, url: user?.twitter)
            }
        }
    }
    
    private func buildSocialArray(social : String, url : String?) {
        guard let url = url, let socialUrl = URL(string: url) else {return}
        socialMap[social] = socialUrl
    }

    public func setUpSections() {
        guard let user = user else {return}
        var userSocials : [ProfileDetailSocialCellViewModel] = []
        for (social, url) in socialMap {
            userSocials.append(ProfileDetailSocialCellViewModel(socialLink: url, social: social, isEditing: isEditing))
        }
        sections = [
            .photos(viewModel: photoList.compactMap({
                return ProfilePhotoCellViewModel(imageUrl: $0)
            })),
            .bio(viewModel: .init(usr: user, isEditing: isEditing)),
            .socials(viewModel: userSocials)
        ]
    }
    
    public func getUserName() -> String {
        guard let userName = user?.username else {
            return ""
        }
        return userName
    }
    
    public func goToSettings() {
        guard let user = user else {return}
        delegate?.goToSettings(user : user)
    }
    
    //MARK: - Creating Sections
    public func createProfileBioSection() -> NSCollectionLayoutSection {
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
                heightDimension: .absolute(185)),
            subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    public func createSocialsSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1))
        )
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 1,
            leading: 2,
            bottom: 1,
            trailing: 2)
        var group : NSCollectionLayoutGroup
        if isEditing {
            group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(50)),
                subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            return section
        } else {
            group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.24),
                    heightDimension: .absolute(50)),
                subitems: [item, item])
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPaging
            return section
        }
       
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
        case .socials(viewModel: let self):
            print(self.count)
            return self.count
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
        case .socials(viewModel: let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ProfileDetailSocialCellView.cellIdentifier,
                for: indexPath
            ) as? ProfileDetailSocialCellView else {
                fatalError("Unsupported cell")
            }
            cell.configuration(viewModel: viewModel[indexPath.row])
            return cell
        }
    }
    
}

protocol ProfileViewModelDelegate : AnyObject {
    func goToSettings(user : User)
}
