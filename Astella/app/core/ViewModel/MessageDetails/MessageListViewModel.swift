//
//  MessagesViewModel.swift
//  Astella
//
//  Created by Keith Kirtfield on 4/30/23.
//

import UIKit

/// MARK: - Protocol
protocol MessageListViewModelDelegate : AnyObject{
    func didLoadInitialMessages()
}
///ViewModel to handle message logic
final class MessageListViewModel : NSObject {
    //Do not want circle pointer
    public weak var delegate : MessageListViewModelDelegate?
    private var cellViewModels : [MessageCellViewViewModel] = []
    private let event : Event
    private var apiInfo : InfoResponse? = nil
    enum SectionTypes : CaseIterable {
        case messages
        case users
    }
    public let sections = SectionTypes.allCases
    
    
    ///DO not create cells every time we get new data, only create new
    private var messages : [Message] = []{
        didSet {
            for msg in messages {
                let viewModel = MessageCellViewViewModel(message: msg)
                cellViewModels.append(viewModel)
            }
        }
    }
        
    init(event : Event) {
        self.event = event
    }
    
    func fetchMessages() {
        print("Fetching Messages")
        UserLocationManager.shared.getUserLocation {[weak self] location in
            guard let eventId = self?.event.id.uuidString else { return }
            let urlIds = AstellaUrlIds(
                userId: "dd5fa511-4ec1-4882-9a04-462d8e43856e",
                eventId: eventId,
                messageId: "")
            let coords = LocationBody(
                latitude: 53.020485,
                longitude: -8.128898)
            let requestService = RequestService(
                urlIds: urlIds,
                endpoint: AstellaEndpoints.GET_MESSAGE_IN_EVENT.rawValue,
                httpMethod: "POST",
                httpBody: coords,
                queryParameters: [URLQueryItem(name: "page", value: "0")]
            )
            AstellaService.shared.execute(requestService, expecting: MessageListResponse.self) {[weak self] result in
                switch result{
                case .success(let model):
                    self?.messages = model.data
                    self?.apiInfo = model.info
                    DispatchQueue.main.async {
                        //Throw in main  queue since it is UI refresh
                        self?.delegate?.didLoadInitialMessages()
                    }
                    
                    break
                case .failure(let error):
                    print("Issue at fetchMessages: \(String(describing: error))")
                }
            }
            
            
        }
    }
    
    // MARK: - Getters for properties of messgae
    public var eventName : String {
        event.name
    }
    
    public var eventPublic : Bool {
        event.is_public
    }
    
    public var eventDesc : String {
        event.description
    }
    
    public var eventCreated : Date {
        let dateFormatter = DateFormatter()
        //2023-05-02 13:22:50
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let date = dateFormatter.date(from: event.created) else {
            return Date()
        }
        return date
    }
    
    public var eventId : UUID {
        event.id
    }
    
    public var shouldShowLoadMore : Bool {
        //Need to see If API has a `next`
        return false
    }
    
    //Pagination
    public func fetchAdditionalMessages() {
        
    }
    
    //MARK: - Create section layouts
    public func createMessageSectionLayout() -> NSCollectionLayoutSection {
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
    public  func createUserSectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.8),
            heightDimension: .fractionalHeight(1))
        )
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 2,
            bottom: 2,
            trailing: 2)
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .absolute(150)),
            subitems: [item, item])
        let section = NSCollectionLayoutSection(group: group)
        //scroll horizontal
//        section.orthogonalScrollingBehavior = .continuous
        //Snaps to next card
        section.orthogonalScrollingBehavior = .groupPaging

        return section
    }
    
}

// MARK: - Collection View Impl
/// Create extension to conform to protocol
extension MessageListViewModel : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    ///Deque and return single cell, using messagecellview
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MessageCellView.cellIdentifier,
            for: indexPath
        ) as? MessageCellView else {
            fatalError("Unsupported cell")
        }
        cell.configuration(with: cellViewModels[indexPath.row])
        
        return cell
    }
    ///Get the size of the UI screenof the device
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds.width
        let width = bounds - 20
        
        return CGSize(width: width , height: ( UIScreen.main.bounds.height * 0.08 ))
    }
    
    
}

// MARK: Scroll View
extension MessageListViewModel : UIScrollViewDelegate {
    //When user reaches bttm
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //Need to add a info to API response to see if there is more to query
        guard shouldShowLoadMore else {
            return
        }
    }
}
