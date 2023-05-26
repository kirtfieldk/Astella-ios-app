//
//  File.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/4/23.
//

import UIKit


final class ProfileViewModel : NSObject{
    public let user : User?
    public let isEditing : Bool
    public weak var delegate : ProfileViewModelDelegate?

    var photoList : [UIImage?] = []
    var socialMap : [SocialMediaTypes : URL] = [:]
    private let noImg = UIImage(systemName: "person.bust")
    private var tiktok : String
    private var twitter : String
    private var youtube : String
    private var ig : String
    private var snapchat : String
    private var desc : String
    private let maxSize = 3
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
        self.tiktok = user.tiktok
        self.twitter = user.tiktok
        self.youtube = user.twitter
        self.desc = user.description
        self.ig = user.ig
        self.snapchat = user.twitter
        super.init()
        buildSocialArray()
        buildPhotoArray(images: [user.img_one, user.img_two, user.img_three])
        
    }
    
    //MARK: Image building Dispatch Group
    private func buildPhotoArray(images : [String]) {
        let group = DispatchGroup()
        var photos : [UIImage?] = []
        for img in images {
            guard let photo = URL(string: img) else {
                continue
            }
            group.enter()
            ImageManager.shared.downloadImage(photo) {result in
                defer {
                    group.leave()
                }
                switch result {
                case .success(let data):
                    print("Fetched photo \(img)")
                    photos.append(UIImage(data : data))
                case .failure(let err):
                    print(String(describing: err))
                }
            }

        }
        let currentSize = images.count
        for _ in currentSize...maxSize {
            photos.append(noImg)
        }
        group.notify(queue: .main) {
            self.photoList = photos
            self.setUpSections()
        }
    }
    
   
    
    //MARK: - Build social map
    private func buildSocialArray() {
        for media in SocialMediaTypes.allCases {
            switch media {
            case .twitter:
                buildSocialArray(social: media, url: twitter)
            case .instagram:
                buildSocialArray(social: media, url: ig)
            case .tiktok:
                buildSocialArray(social: media, url: tiktok)
            case .snapchat:
                buildSocialArray(social: media, url: twitter)
            case .youtube:
                buildSocialArray(social: media, url: twitter)
            }
        }
    }
    
    private func buildSocialArray(social : SocialMediaTypes, url : String?) {
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
                guard let imageUrl = $0 else {return nil}
                let vm = ProfilePhotoCellViewModel(imageUrl: imageUrl, editing: isEditing)
                vm.collectionDelegate = self
                return vm
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
    
    //MARK: - Updating User
    public func updateUser() {
//        if isEditing {
//            for (el) in sections {
//                switch el {
//                case .bio(let viewModel):
//                    desc = viewModel.grabInputValue()
//                case .photos(_):
//                    print("Photot")
//                case .socials(let viewModels):
//                    viewModels.forEach { model in
//                        updateUserParams(viewModel: model)
//                    }
//                }
//            }
//            guard let id = user?.id, let created = user?.created, let username = user?.username, let imgOne = photoList[0]?.absoluteString, let imgTwo = photoList[1]?.absoluteString, let imgThree = photoList[2]?.absoluteString, let avatar = user?.avatar_url else {return}
//            let newUser = User(id: id, created: created, username: username, description: desc, ig: ig, twitter: twitter, tiktok: tiktok, avatar_url: avatar, img_one: imgOne, img_two: imgTwo, img_three: imgThree)
//        }
    }
    
    //MARK: - Update User
    private func updateUser(updated : User) {
        let req = RequestPostService(urlIds: AstellaUrlIds(userId: UserManager.shared.getUserId(), eventId: "", messageId: ""),
                                     endpoint: AstellaEndpoints.UPDATE_USER, httpMethod: "PUT",
                                     httpBody: updated, queryParameters: [])
        AstellaService.shared.execute(req, expecting: UserListResponse.self) { result in
            switch result {
            case .success(let data):
                UserManager.shared.setUser(user: data.data[0])
            case .failure(let err):
                print(String(describing: err))
            }
        }
        
    }
    
    private func updateUserParams(viewModel : ProfileDetailSocialCellViewModel) {
        switch viewModel.social {
        case .instagram:
            ig = viewModel.grabInputValue()
        case .tiktok:
            tiktok = viewModel.grabInputValue()
        case .snapchat:
            snapchat = viewModel.grabInputValue()
        case .youtube:
            youtube = viewModel.grabInputValue()
        case .twitter:
            twitter = viewModel.grabInputValue()
        }
    }
    
}
//What whappens when user logs into platform
//Trace Transport how data flows

//MARK: - Delegate + DataSource
extension ProfileViewModel : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = sections[section]
        switch sectionType {
        case .photos(viewModel: let self):
            if isEditing {
                return 3
            }
            print(self.count)
            return self.count
        case .bio(viewModel: _):
            return 1
        case .socials(viewModel: let self):
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
//MARK: - Delegate To VC
protocol ProfileViewModelDelegate : AnyObject {
    func goToSettings(user : User)
}

extension ProfileViewModel : ProfilePhotoCellViewModelUpdateCollectionViewDelegate {
    func updateCollectionView(image: UIImage, oldPhoto: UIImage) {
        for i in 0...photoList.count-1 {
            if photoList[i] == oldPhoto {
                photoList[i] = image
                break
            }
            if i == photoList.count-1 {
                photoList.append(image)
            }
        }
        setUpSections()
    }
    
   
}
