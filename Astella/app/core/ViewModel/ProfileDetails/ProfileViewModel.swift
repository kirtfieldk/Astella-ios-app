//
//  File.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/4/23.
//

import UIKit


final class ProfileViewModel : NSObject{
    public var userId : String?
    public var user : User?
    public let isEditing : Bool
    public weak var delegate : ProfileViewModelDelegate?

    var photoList : [UIImage?] = []
    var socialMap : [SocialMediaTypes : URL] = [:]
    var AllSocialMap : [SocialMediaTypes : String] = [:]
    private let noImg = UIImage(systemName: "person.bust")
    private var tiktok : String?
    private var twitter : String?
    private var youtube : String?
    private var ig : String?
    private var snapchat : String?
    private var desc : String?
    private let maxSize = 3
    private var photoOne : UIImage?
    private var photoTwo : UIImage?
    private var photoThree : UIImage?
    private var photoViewModelMap : [Int : ProfilePhotoCellViewModel] = [:]
    enum SectionTypes {
        case photos(viewModel : [ProfilePhotoCellViewModel])
        case bio(viewModel : ProfileDetailCellViewModel)
        case socials(viewModel : [ProfileDetailSocialCellViewModel])
    }
    public var sections : [SectionTypes] = []

    //MARK: - INIT PhotoArray SocialArray
    init(userId : String, isEditing : Bool) {
        self.userId = userId
        self.isEditing = isEditing
        super.init()
    
    
    }
    
    public func getUser(completion: @escaping(Result<UserListResponse, Error>) -> Void) {
        UserManager.shared.getUser(completion: completion)
    }
    
    public func setUserParams(user : User, tiktok : String, twitter : String, youtube : String, desc : String, ig : String, snapchat : String ) {
        self.user = user
        self.tiktok = tiktok
        self.twitter = twitter
        self.youtube = youtube
        self.desc = desc
        self.ig = ig
        self.snapchat = twitter
    }
    
    public func buildSocialAndPhotoArr() {
        guard let user = user else {return}
        buildSocialArray()
        buildPhotoArray(images: [user.img_one, user.img_two, user.img_three])
    }
    
    //MARK: Image building Dispatch Group
    private func buildPhotoArray(images : [String]) {
        self.delegate?.isFetchUserImage(fetching: true)
        let group = DispatchGroup()
        var photos : [UIImage?] = []
        for img in images {
            group.enter()
            ImageManager.shared.downloadImage(img) {result in
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
        if isEditing {
            let currentSize = images.count
            for _ in currentSize...maxSize {
                photos.append(noImg)
            }
        }
        group.notify(queue: .main) {
            print("Setting up sections after fetching all photos")
            self.photoList = photos.reversed()
            self.delegate?.isFetchUserImage(fetching: false)
            self.delegate?.isDoneLoading()
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
        AllSocialMap[social] = url
        guard let url = url, let socialUrl = URL(string: url) else {
            return
        }
        socialMap[social] = socialUrl
    }

    public func setUpSections() {
        guard let user = user else {return}
        var userSocials : [ProfileDetailSocialCellViewModel] = []
        if !isEditing {
            for (social, url) in socialMap {
                userSocials.append(ProfileDetailSocialCellViewModel(socialLink: url, social: social, isEditing: isEditing, socialString: nil))
            }
        } else {
            for (social, url) in AllSocialMap {
                userSocials.append(ProfileDetailSocialCellViewModel(socialLink: nil, social: social, isEditing: isEditing, socialString: url))
            }
        }
        var index = 0
        sections = [
            .photos(viewModel: photoList.compactMap({
                guard let imageUrl = $0 else {return nil}
                let vm = ProfilePhotoCellViewModel(imageUrl: imageUrl, editing: isEditing, isEmpty: imageUrl == noImg)
                photoViewModelMap[index] = vm
                index+=1
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
    public func updateUser(completion : @escaping (Result<UserListResponse, Error>) -> Void) {
        if isEditing {
            for el in sections {
                switch el {
                case .bio(let viewModel):
                    desc = viewModel.grabInputValue()
                case .photos(_):
                    updateUserImages()
                case .socials(let viewModels):
                    viewModels.forEach { model in
                        updateUserParams(viewModel: model)
                    }
                }
            }
            guard let id = userId, let created = user?.created, let username = user?.username, let avatar = user?.avatar_url,
            let ig = ig, let twitter = twitter, let tiktok = tiktok, let desc = desc else {return}
            let userParams : [String : String] = [
                "id" : id,
                "created" : created,
                "username" : username,
                "ig" : ig,
                "twitter" : twitter,
                "tiktok" : tiktok,
                "description" : desc,
            ]
            let imageParams : [String : UIImage?] = [
                "img_one" : photoOne,
                "img_two" : photoTwo,
                "img_three" : photoThree
            ]
            let req = RequestMultipartForm(urlIds: AstellaUrlIds(userId: UserManager.shared.getUserId(), eventId: "", messageId: ""), endpoint: AstellaEndpoints.UPDATE_USER, httpMethod: "PUT", paramMap: userParams, paramFileMap: imageParams)
            AstellaService.shared.execute(req, expecting: UserListResponse.self, completion: completion) 
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
    
    private func updateUserImages() {
        for i in 0...maxSize - 1 {
            let vm = photoViewModelMap[i]
            guard let vm = vm else {
                continue
            }
            switch i {
            case 0:
                if !vm.isEmpty {
                    print("Image one not empty")
                    photoOne = vm.imageUrl
                }
            case 1:
                if !vm.isEmpty {
                    print("Image two not empty")
                    photoTwo = vm.imageUrl
                }
            case 2:
                if !vm.isEmpty {
                    print("Image three not empty")
                    photoThree = vm.imageUrl
                }
            default:
                return
            }
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
    func reloadCollectionView()
    func isFetchUserImage(fetching : Bool)
    func isDoneLoading()
}

extension ProfileViewModel : ProfilePhotoCellViewModelUpdateCollectionViewDelegate {
    func updateCollectionView(image: UIImage, oldPhoto: UIImage?) {
        if oldPhoto == nil {
            photoList.append(image)
        } else {
            for i in 0...photoList.count-1 {
                if photoList[i] == oldPhoto {
                    photoList[i] = image
                    break
                }
                if i == photoList.count-1 {
                    photoList.append(image)
                }
            }
        }
        setUpSections()
    }
    
   
}
