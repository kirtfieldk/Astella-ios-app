//
//  MessageDetailViewModel.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/10/23.
//

import UIKit

final class MessageDetailViewModel : NSObject {
    private let msg : Message?
    private let event : UUID?
    private let threadMsg : [Message] = []
    enum SectionTypes {
        case message(viewModel : MessageCellViewViewModel)
        case threadMessages(viewModel : [MessageCellViewViewModel])
    }
    public var sections : [SectionTypes] = []
    
    
    init(msg : Message, event : UUID) {
        self.msg = msg
        self.event = event
        super.init()
    }
    
    private func fetchThread() {
        
    }
    
    private func buildSections() {
        guard let msg = msg, let eventId = event else {return}
        sections = [
            .message(viewModel: MessageCellViewViewModel(message: msg, eventId: eventId)),
            .threadMessages(viewModel: threadMsg.compactMap({
                MessageCellViewViewModel(message: $0, eventId: eventId)
            }))
        ]
    }
    
    func postMessage(msg : String) {
        UserLocationManager.shared.getUserLocation {[weak self] location in
            guard let eventId = self?.event else { return }
            guard let userId = UUID(uuidString: "db212c03-8d8a-4d36-9046-ab60ac5b250d") else {return}
            let req = RequestPostService(
                urlIds:
                    AstellaUrlIds(userId: "db212c03-8d8a-4d36-9046-ab60ac5b250d", eventId: eventId.uuidString, messageId: ""),
                endpoint: AstellaEndpoints.POST_MESSAGE_TO_EVENT,
                httpMethod: "POST",
                httpBody: PostMessageToEventBody(
                    content: msg, user_id: userId,
                    parent_id: nil,
                    event_id: eventId, upvotes: 0, pinned: false,
                    latitude: 53.020485, longitude: -8.128898),
                queryParameters: [])
            AstellaService.shared.execute(req, expecting: MessageListResponse.self) { result in
                switch result {
                case .success(let resp):
                    guard let success = resp.success else {
                        return
                    }
                    DispatchQueue.main.async {
                        self?.messages = resp.data
                        self?.delegate?.postedMessageRefreshMessages()
                    }
                case .failure(let err):
                    print(String(describing: err))
                }
            }
        }
    }
    
    public func createMsgFocusSection() -> NSCollectionLayoutSection {
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
                heightDimension: .fractionalHeight(0.40)),
            subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    public func createMsgThreadSection() -> NSCollectionLayoutSection {
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
}

extension MessageDetailViewModel : UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = sections[section]
        switch sectionType {
        case .message(_):
            return 1
        case .threadMessages(_):
            return threadMsg.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds.width
        
        return CGSize(width: bounds , height: (UIScreen.main.bounds.height))
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = sections[indexPath.section]
        switch sectionType {
        case .message(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MessageDetailViewCell.cellIdentifier,
                for: indexPath
            ) as? MessageDetailViewCell else {
                fatalError("Unsupported cell")
            }
            cell.configuration(with : viewModel)
            return cell
        case .threadMessages(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MessageCollectionViewCell.cellIdentifier,
                for: indexPath
            ) as? MessageCollectionViewCell else {
                fatalError("Unsupported cell")
            }
            cell.configuration(with : viewModel[indexPath.row])
            return cell
        }
    }
    
}
