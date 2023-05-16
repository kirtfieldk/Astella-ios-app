//
//  MessageDetailViewModel.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/10/23.
//

import UIKit

protocol MessageDetailViewModelDelegate : AnyObject {
    func refreshThread()
}
protocol MessageDetailViewModelVcDelegate : AnyObject {
    func redirectIntoMessageDetail(msg : Message, eventId : UUID)
    func redirectIntoUpvoteDetail(msg : Message, eventId : UUID)
}
final class MessageDetailViewModel : MessageParentViewModel {
    private let msg : Message?
    private let event : UUID?
    private var threadMsg : [Message] = [] {
        didSet {
            
        }
    }
    public weak var delegate : MessageDetailViewModelDelegate?
    public weak var vcDelegate : MessageDetailViewModelVcDelegate?
    
    enum SectionTypes {
        case message(viewModel : MessageCellViewViewModel)
        case threadMessages(viewModel : [MessageCellViewViewModel])
    }
    public var sections : [SectionTypes] = []
    
    
    init(msg : Message, event : UUID) {
        self.msg = msg
        self.event = event
        super.init(eventId: event)
        super.setParentId(parentId: msg.id)
        getMessageThread()
    }
    
    public func getMessageThread() {
        guard let message = msg else {return}
        super.getMessageThread(msg: message, page: "0") {[weak self] result in
            switch result {
            case .success(let resp):
                DispatchQueue.main.async {
                    self?.threadMsg = resp.data
                    self?.buildSections()
                    self?.delegate?.refreshThread()
                }
            case .failure(let err):
                print(String(describing: err))
            }
        }
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
    
    func postMessage(msg: String) {
        super.postMessage(msg: msg) {[weak self] result in
            switch result {
            case .success(let resp):
                guard let _ = resp.success else {
                    print("Unable to Post Message")
                    return
                }
                DispatchQueue.main.async {
                    self?.threadMsg.append(resp.data[0])
                    self?.buildSections()
                    self?.delegate?.refreshThread()
                }
            case .failure(let err):
                print(String(describing: err))
            }
        }
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
                withReuseIdentifier: MessageDetailThreadViewCell.cellIdentifier,
                for: indexPath
            ) as? MessageDetailThreadViewCell else {
                fatalError("Unsupported cell")
            }
            cell.configuration(with : viewModel[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let message = threadMsg[indexPath.row]
        guard let eventId = event else {return}
        vcDelegate?.redirectIntoMessageDetail(msg: message, eventId: eventId)
    }
    
}
