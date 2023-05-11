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
    func postedMessageRefreshMessages()
    func didLoadPinnedMessages()
}
protocol MessagePinnedListViewModelDelegate : AnyObject {
    func setMessageCellViewModel(messageCellViewModels : [MessageCellViewViewModel])
}
///ViewModel to handle message logic
final class MessageListViewModel : MessageParentViewModel {
    //Do not want circle pointer
    //MARK: - INIT
    public weak var delegate : MessageListViewModelDelegate?
    public weak var pinnedDelegate : MessagePinnedListViewModelDelegate?
    public var messageCellViewModels : [MessageCellViewViewModel] = []
    private var userCellViewModel : [UserCollectionViewCellViewModel] = []
    public var messagePinnedCellViewModels : [MessageCellViewViewModel] = []

    private let event : Event
    private var apiInfo : InfoResponse? = nil   
    public var messages : [Message] = []{
        didSet {
            for msg in messages {
                if !messageCellViewModels.contains(where: {$0.message.id == msg.id}) {
                    let viewModel = MessageCellViewViewModel(message: msg, eventId: event.id)
                    messageCellViewModels.append(viewModel)
                }
            }
        }
    }
    
    public var users : [User] = []{
        didSet {
            for usr in users {
                if !userCellViewModel.contains(where: {$0.user.id == usr.id}) {
                    let viewModel = UserCollectionViewCellViewModel(user: usr)
                    userCellViewModel.append(viewModel)
                }
            }
        }
    }
    
    public var pinnedMessages : [Message] = []{
        didSet {
            for msg in pinnedMessages {
                if !messagePinnedCellViewModels.contains(where: {$0.message.id == msg.id}) {
                    let viewModel = MessageCellViewViewModel(message: msg, eventId: event.id)
                    messagePinnedCellViewModels.append(viewModel)
                }
            }
        }
    }
        
    init(event : Event) {
        self.event = event
        super.init(eventId: event.id)
    }
    
    //MARK: - Post Message
    func postMessage(msg : String) {
        super.postMessage(msg: msg) { [weak self] result in
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
    
    
    //MARK: - Fetching Messages
    func fetchMessages(page : String) {
        let urlIds = AstellaUrlIds(
            userId: "db212c03-8d8a-4d36-9046-ab60ac5b250d",
            eventId: eventId.uuidString,
            messageId: "")
        let requestService = RequestGetService(
            urlIds: urlIds,
            endpoint: AstellaEndpoints.GET_MESSAGE_IN_EVENT,
            queryParameters: [URLQueryItem(name: "page", value: page)]
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
    
    public func fetchUsers(page : String) {
        let req = RequestGetService(
            urlIds: AstellaUrlIds(userId: "",
                                  eventId: event.id.uuidString,
                                  messageId: ""),
            endpoint: AstellaEndpoints.GET_EVENTS_MEMBER,
            queryParameters: [URLQueryItem(name: "page", value: page)])
        AstellaService.shared.execute(req, expecting: UserListResponse.self) {[weak self] result in
            switch result {
            case .success(let success):
                self?.users = success.data
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialUsers()
                }
                break
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
    
    //MARK: - Pinning Messages
    func fetchUserPinnedMessages(page : String) {
        let req = RequestGetService(
            urlIds: AstellaUrlIds(userId: "db212c03-8d8a-4d36-9046-ab60ac5b250d", eventId: event.id.uuidString, messageId: ""), endpoint: AstellaEndpoints.GET_USER_PIN, queryParameters: [URLQueryItem(name: "page", value: page)])
        AstellaService.shared.execute(req, expecting: MessageListResponse.self) {[weak self] result in
            switch result {
            case .success(let res):
                DispatchQueue.main.async {
                    self?.pinnedMessages = res.data
                    guard let messagePinnedCellViewModels = self?.messagePinnedCellViewModels else {return}
                    self?.pinnedDelegate?
                        .setMessageCellViewModel(
                            messageCellViewModels: messagePinnedCellViewModels)
                    self?.delegate?.didLoadPinnedMessages()
                    
                }
            case .failure(let err):
                print(String(describing: err))
            }
        }
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

// MARK: - Delegate to refresh Pins
extension MessageListViewModel : MessageCollectionParentViewCellDelegate {
    func deletePin(msg: Message) {
        messagePinnedCellViewModels = messagePinnedCellViewModels.filter({ $0.message.id != msg.id })
        pinnedMessages = pinnedMessages.filter({$0.id != msg.id})
        pinnedDelegate?.setMessageCellViewModel(messageCellViewModels: messagePinnedCellViewModels)
        delegate?.didLoadPinnedMessages()
    }
    
    func updateMessage(msg: Message) {
        for (index, el) in messageCellViewModels.enumerated() {
            if el.message.id == msg.id {
                messageCellViewModels[index] = MessageCellViewViewModel(message: msg, eventId: eventId)
            }
        }
        for (index, el) in messagePinnedCellViewModels.enumerated() {
            if el.message.id == msg.id {
                messagePinnedCellViewModels[index] = MessageCellViewViewModel(message: msg, eventId: eventId)
            }
        }
        pinnedDelegate?.setMessageCellViewModel(messageCellViewModels: messagePinnedCellViewModels)
        delegate?.didLoadPinnedMessages()
    }
    
    func fetchPinMessages() {
        fetchUserPinnedMessages(page: "0")
    }
}

//MARK: - DELEGATE 4 UserCell
extension MessageListViewModel : UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userCellViewModel.count
    }
    
    ///Deque and return single cell, using messagecellview
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: UserCollectionViewCell.cellIdentifier,
            for: indexPath
        ) as? UserCollectionViewCell else {
            fatalError("Unsupported cell")
        }
        cell.configure(with: userCellViewModel[indexPath.row])
        return cell
    }
    
    ///Get the size of the UI screenof the device
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds.width
        let width = bounds - 20
        return CGSize(width: width , height: ( UIScreen.main.bounds.height))
    }
    
}
