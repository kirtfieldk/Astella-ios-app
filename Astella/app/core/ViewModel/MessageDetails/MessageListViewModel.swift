//
//  MessagesViewModel.swift
//  Astella
//
//  Created by Keith Kirtfield on 4/30/23.
//

import UIKit

// MARK:  - Protocol
protocol MessageListViewModelDelegate : AnyObject{
    func didLoadInitialMessages()
    func didLoadInitialUsers()
}
///ViewModel to handle message logic
final class MessageListViewModel : NSObject {
    //Do not want circle pointer
    //MARK: - INIT
    public weak var delegate : MessageListViewModelDelegate?
    private var messageCellViewModels : [MessageCellViewViewModel] = []
    private var userCellViewModel : [UserCollectionViewCellViewModel] = []
    private let event : Event
    private var apiInfo : InfoResponse? = nil
    enum SectionTypes {
        case messages(viewModel : [MessageCellViewViewModel])
        case users(viewModel : [UserCollectionViewCellViewModel])
    }
    public var sections : [SectionTypes] = []
    
    
    ///DO not create cells every time we get new data, only create new
    public var messages : [Message] = []{
        didSet {
            for msg in messages {
                let viewModel = MessageCellViewViewModel(message: msg, eventId: event.id)
                messageCellViewModels.append(viewModel)
            }
        }
    }
    
    public var users : [User] = []{
        didSet {
            for usr in users {
                let viewModel = UserCollectionViewCellViewModel(user: usr)
                userCellViewModel.append(viewModel)
            }
        }
    }
        
    init(event : Event) {
        self.event = event
        super.init()
        self.fetchMessages()
        self.fetchUsers()
        self.setUpSections()
    }
    
    public func setUpSections() {
        sections = [
            .messages(viewModel: messages.compactMap({
                return MessageCellViewViewModel(message: $0, eventId: event.id)
            })),
            .users(viewModel: users.compactMap({
                return UserCollectionViewCellViewModel(user: $0)
            }))
        ]
    }
    
    func fetchMessages() {
        print("Fetching Messages \(eventId)")
        UserLocationManager.shared.getUserLocation {[weak self] location in
            guard let eventId = self?.event.id.uuidString else { return }
            
            let urlIds = AstellaUrlIds(
                userId: "dd5fa511-4ec1-4882-9a04-462d8e43856e",
                eventId: eventId,
                messageId: "")
            let coords = LocationBody(
                latitude: 53.020485,
                longitude: -8.128898)
            let requestService = RequestPostService(
                urlIds: urlIds,
                endpoint: AstellaEndpoints.GET_MESSAGE_IN_EVENT,
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
    
    public func fetchUsers() {
        let req = RequestGetService(
            urlIds: AstellaUrlIds(userId: "",
                                  eventId: event.id.uuidString,
                                  messageId: ""),
            endpoint: AstellaEndpoints.GET_EVENTS_MEMBER,
            queryParameters: [URLQueryItem(name: "page", value: "0")])
        AstellaService.shared.execute(req, expecting: UserListResponse.self) {[weak self] result in
            switch result {
            case .success(let success):
                self?.users = success.data
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialUsers()
                }
                print(String(describing: success))
            case .failure(let err):
                print(String(describing: err))
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
