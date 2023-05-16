//
//  ProfileBriefListViewModel.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/11/23.
//

import UIKit

protocol ProfileBreifListViewModelDelegate : AnyObject {
    func redirectIntoProfileDetail(usr : User)
}

final class ProfileBriefListViewModel : NSObject {
    private let msg : Message
    private let eventId : UUID
    public var users : [User] = []
    public weak var delegate : ProfileBreifListViewModelDelegate?
    
    enum SectionTypes  {
        case users(viewModel : [UserCollectionViewCellViewModel])
    }
    public var sections : [SectionTypes] = []
    
    init(msg : Message, eventId : UUID) {
        self.msg = msg
        self.eventId = eventId
        super.init()
    }
    
    required init?(coder : NSCoder) {
        fatalError("Not Supported")
    }
    
    public func fetchUsersWhoLiked(completion : @escaping (Result<UserListResponse, Error>) -> Void) {
        let req = RequestGetService(
            urlIds: AstellaUrlIds(userId: "db212c03-8d8a-4d36-9046-ab60ac5b250d", eventId: eventId.uuidString, messageId: msg.id.uuidString),
            endpoint: AstellaEndpoints.GET_USRS_LIKE_MESSAGE,
            queryParameters: [URLQueryItem(name: "page", value: "0")])
        AstellaService.shared.execute(req, expecting: UserListResponse.self, completion: completion)
    }
    
    
    
    public func setUpSections() {
        sections = [
            .users(viewModel: users.compactMap({
                return UserCollectionViewCellViewModel(user: $0)
            }))
        ]
    }
    
    public func buildCollectionView() -> UICollectionView{
        let layout = UICollectionViewCompositionalLayout {[weak self] sectionIndex, _ in
            return self?.createSection(for: sectionIndex)
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        ///Input for our messageCell
        collectionView.register(
            UserCollectionViewCell.self,
            forCellWithReuseIdentifier: UserCollectionViewCell.cellIdentifier
        )
        return collectionView
    }
    
    private func createSection(for sectionIndex : Int) -> NSCollectionLayoutSection {
        let sectionTypes = sections
        switch sectionTypes[sectionIndex] {
        case .users:
            return createUserSection()
        }
    }
        
    private  func createUserSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1))
        )
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 10,
            leading: 5,
            bottom: 10,
            trailing: 5)
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(0.10)),
            subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}

extension ProfileBriefListViewModel : UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = sections[section]
        switch sectionType {
        case .users(viewModel : let self):
            return self.count
        }
    }
    
    ///Deque and return single cell, using messagecellview
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = sections[indexPath.section]
        switch sectionType {
        case .users(let vm):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: UserCollectionViewCell.cellIdentifier,
                for: indexPath
            ) as? UserCollectionViewCell else {
                fatalError("Unsupported cell")
            }
            cell.configuration(viewModel: vm[indexPath.row])
            return cell
        }
    }
    
    ///Get the size of the UI screenof the device
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds.width
        let width = bounds - 20
        
        return CGSize(width: width , height: ( UIScreen.main.bounds.height * 0.08 ))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.redirectIntoProfileDetail(usr: users[indexPath.row])
    }
}
