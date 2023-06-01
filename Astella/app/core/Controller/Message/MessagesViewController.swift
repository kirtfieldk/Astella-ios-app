//
//  MessagesViewController.swift
//  Astella
//
//  Created by Keith Kirtfield on 4/30/23.
//

import UIKit

final class MessagesViewController: UIViewController {
    
    private var viewModel : MessageListViewModel
    private let messageListView : MessageListView
    private let messagePinnedViewModel : MessagePinnedViewModel
    
    //MARK: - Init, Delegate
    init(viewModel : MessageListViewModel) {
        self.viewModel = viewModel
        self.messageListView = MessageListView(frame: .zero, viewModel: viewModel)
        self.messagePinnedViewModel = MessagePinnedViewModel()
        super.init(nibName: nil, bundle: nil)
        setUpDelegate()

    }
    
    private func setUpDelegate() {
        self.messageListView.collectionView?.delegate = self
        self.messageListView.collectionView?.dataSource = self
        self.messageListView.pinnedMessagesCollectionView?.delegate = self
        self.messageListView.pinnedMessagesCollectionView?.dataSource = self
        self.messageListView.userCollectionView?.delegate = viewModel
        self.messageListView.userCollectionView?.dataSource = viewModel
        self.messageListView.pinnedMessagesCollectionView?.delegate = messagePinnedViewModel
        self.messageListView.pinnedMessagesCollectionView?.dataSource = messagePinnedViewModel
        self.viewModel.pinnedDelegate = messagePinnedViewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(messageListView)
        self.setUpView()
        view.backgroundColor = .systemBackground
        title = viewModel.eventName
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(didTapShare))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchMessages(page: "0")
        viewModel.fetchUsers(page : "0")
        viewModel.fetchUserPinnedMessages(page: "0")
    }
    
    func setUpView() {
        messageListView.eventId = viewModel.eventId
        NSLayoutConstraint.activate([
            messageListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            messageListView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            messageListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            messageListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    ///Needs to objective c when we use a #selector
    @objc
    private func didTapShare() {
        
    }
    
    //MARK: - Redirect
    private func redirectIntoMessageDetail(msg : Message, eventId : UUID) {
        let vm = MessageDetailViewModel(msg: msg, event: eventId)
        let vc = MessageDetailViewController(viewModel: vm)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}


// MARK: - Collection View Impl
/// Create extension to conform to protocol
extension MessagesViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.messageSections.count
    }
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = viewModel.messageSections[section]
        switch sectionType {
        case .eventOverview(_):
            return 1
        case .messages(let viewModel):
            return viewModel.count
        }
    }
    
    ///Deque and return single cell, using messagecellview
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = viewModel.messageSections[indexPath.section]
        switch sectionType {
            
        case .eventOverview(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: EventOverviewCollectionViewCell.cellIdentifier,
                for: indexPath
            ) as? EventOverviewCollectionViewCell else {
                fatalError("Unsupported cell")
            }
            cell.configuration(with: viewModel)
            return cell
            
        case .messages(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MessageCollectionViewCell.cellIdentifier,
                for: indexPath
            ) as? MessageCollectionViewCell else {
                fatalError("Unsupported cell")
            }
            cell.delegate = self.viewModel
            cell.vcDelegate = self
            cell.configuration(with: viewModel[indexPath.row])
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
        let sectionType = viewModel.messageSections[indexPath.section]
        switch sectionType {
        case .eventOverview(_):
            return
        case .messages(let viewModel):
            redirectIntoMessageDetail(msg: viewModel[indexPath.row].message,
                                            eventId: viewModel[indexPath.row].eventId)
        }
        
    }
}

//MARK: - Connect to Cell
extension MessagesViewController : MessageCollectionParentViewToVcCellDelegate {
    func redirectToUpvoteUserList(msg: Message) {
        let vm = ProfileBriefListViewModel(msg: msg, eventId: viewModel.eventId)
        let vc = ProfileBriefListViewController(viewModel: vm)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
