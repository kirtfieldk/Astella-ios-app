//
//  MessageListView.swift
//  Astella
//
//  Created by Keith Kirtfield on 4/30/23.
//

import UIKit

final class MessageListView: UIView {

    //MARK: - Vars
    public  var eventId : UUID
    public var eventName : String
    private let viewModel : MessageListViewModel
    public var collectionView : UICollectionView?
    public var userCollectionView : UICollectionView?
    public var pinnedMessagesCollectionView : UICollectionView?

    public enum Tabs : String, CaseIterable {
        case messages, pinned, users
    }

    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    public let eventDetailsTabBar : UITabBar = {
        let tabbar = UITabBar()
    
        tabbar.translatesAutoresizingMaskIntoConstraints = false
        var tabbarItems : [UITabBarItem] = []
        Tabs.allCases.forEach { tab in
            let item = UITabBarItem()
            item.title = tab.rawValue
            tabbarItems.append(item)
        }
        tabbar.setItems(tabbarItems, animated: true)
        tabbar.selectedItem = tabbarItems[0]
        return tabbar
    }()
    
    private let messageInputText : UITextField = {
        let messageInputText = UITextField()
        messageInputText.translatesAutoresizingMaskIntoConstraints = false
        messageInputText.keyboardType = .twitter
        messageInputText.backgroundColor = .lightGray
        return messageInputText
    }()
    
    private let v : UIView = {
       let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let submitTextBtn : UIButton = {
        let submitTextBtn = UIButton(configuration: .bordered())
        submitTextBtn.translatesAutoresizingMaskIntoConstraints = false
        submitTextBtn.addTarget(self, action: #selector(submit),for: .touchDown)
        submitTextBtn.setTitle("Send", for: .normal)
        return submitTextBtn
    }()

    private let messageSendBarContainer : UIView = {
        let messageSendBarContainer = UIView()
        messageSendBarContainer.translatesAutoresizingMaskIntoConstraints = false
        messageSendBarContainer.backgroundColor = .lightText
        messageSendBarContainer.layer.borderColor = UIColor.black.cgColor
        messageSendBarContainer.layer.borderWidth = 1
        return messageSendBarContainer
    }()
    
    //MARK: - INIT
    init(frame : CGRect, viewModel : MessageListViewModel) {
        self.viewModel = viewModel
        self.eventId = viewModel.eventId
        self.eventName = viewModel.eventName
        super.init(frame: frame)
        viewModel.delegate = self
        translatesAutoresizingMaskIntoConstraints = false
        let collectionView = createMessageCollectionView()
        let usercollectionView = createUserCollectionView()
        let pinnedMessagesCollectionView = createPinnedMessagesCollectionView()
        self.collectionView = collectionView
        self.userCollectionView = usercollectionView
        self.pinnedMessagesCollectionView = pinnedMessagesCollectionView

        messageSendBarContainer.addSubviews(messageInputText, submitTextBtn)
        v.addSubviews(usercollectionView, collectionView, pinnedMessagesCollectionView)
        addSubviews(v, spinner, eventDetailsTabBar, messageSendBarContainer)
        
        addConstraints()
        spinner.startAnimating()
        eventDetailsTabBar.delegate = self
    }

    // MARK: - INIT
    required init?(coder : NSCoder) {
        fatalError("Not Supported")
    }

    //MARK: - constraints
    private func addConstraints() {
        guard let collectionView = collectionView, let userCollectionView = userCollectionView, let pinnedMessagesCollectionView = pinnedMessagesCollectionView else {return}
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),

            eventDetailsTabBar.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.04),
            eventDetailsTabBar.topAnchor.constraint(equalTo: topAnchor),
            eventDetailsTabBar.leftAnchor.constraint(equalTo: leftAnchor),
            eventDetailsTabBar.rightAnchor.constraint(equalTo: rightAnchor),
            
            v.topAnchor.constraint(equalTo: eventDetailsTabBar.bottomAnchor, constant: 5),
            v.leftAnchor.constraint(equalTo: leftAnchor),
            v.rightAnchor.constraint(equalTo: rightAnchor),
            v.bottomAnchor.constraint(equalTo: messageSendBarContainer.topAnchor),
            
            messageSendBarContainer.topAnchor.constraint(equalTo: v.bottomAnchor),
            messageSendBarContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            messageSendBarContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
            messageSendBarContainer.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            messageSendBarContainer.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.04),
            
            messageInputText.leadingAnchor.constraint(equalTo: messageSendBarContainer.leadingAnchor),
            messageInputText.bottomAnchor.constraint(equalTo: messageSendBarContainer.bottomAnchor),
            messageInputText.topAnchor.constraint(equalTo: messageSendBarContainer.topAnchor),
            messageInputText.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.85),

            submitTextBtn.trailingAnchor.constraint(equalTo: messageSendBarContainer.trailingAnchor),
            submitTextBtn.leadingAnchor.constraint(equalTo: messageInputText.trailingAnchor),
            submitTextBtn.bottomAnchor.constraint(equalTo: messageSendBarContainer.bottomAnchor),
            submitTextBtn.topAnchor.constraint(equalTo: messageSendBarContainer.topAnchor),
        ])
        if eventDetailsTabBar.selectedItem?.title == Tabs.messages.rawValue {
            NSLayoutConstraint.deactivate([
                userCollectionView.topAnchor.constraint(equalTo: v.topAnchor),
                userCollectionView.rightAnchor.constraint(equalTo: v.rightAnchor),
                userCollectionView.leftAnchor.constraint(equalTo: v.leftAnchor),
                userCollectionView.bottomAnchor.constraint(equalTo: v.bottomAnchor),
                
                pinnedMessagesCollectionView.topAnchor.constraint(equalTo: v.topAnchor),
                pinnedMessagesCollectionView.rightAnchor.constraint(equalTo: v.rightAnchor),
                pinnedMessagesCollectionView.leftAnchor.constraint(equalTo: v.leftAnchor),
                pinnedMessagesCollectionView.bottomAnchor.constraint(equalTo: v.bottomAnchor),


            ])
            NSLayoutConstraint.activate([
                collectionView.topAnchor.constraint(equalTo: v.topAnchor),
                collectionView.rightAnchor.constraint(equalTo: v.rightAnchor),
                collectionView.leftAnchor.constraint(equalTo: v.leftAnchor),
                collectionView.bottomAnchor.constraint(equalTo: v.bottomAnchor),

            ])
        } else if eventDetailsTabBar.selectedItem?.title == Tabs.users.rawValue {
            NSLayoutConstraint.deactivate([
                collectionView.topAnchor.constraint(equalTo: v.topAnchor),
                collectionView.rightAnchor.constraint(equalTo: v.rightAnchor),
                collectionView.leftAnchor.constraint(equalTo: v.leftAnchor),
                collectionView.bottomAnchor.constraint(equalTo: v.bottomAnchor),
                
                pinnedMessagesCollectionView.topAnchor.constraint(equalTo: v.topAnchor),
                pinnedMessagesCollectionView.rightAnchor.constraint(equalTo: v.rightAnchor),
                pinnedMessagesCollectionView.leftAnchor.constraint(equalTo: v.leftAnchor),
                pinnedMessagesCollectionView.bottomAnchor.constraint(equalTo: v.bottomAnchor),
            ])
            NSLayoutConstraint.activate([
                userCollectionView.topAnchor.constraint(equalTo: v.topAnchor),
                userCollectionView.rightAnchor.constraint(equalTo: v.rightAnchor),
                userCollectionView.leftAnchor.constraint(equalTo: v.leftAnchor),
                userCollectionView.bottomAnchor.constraint(equalTo: v.bottomAnchor),
            ])
        } else if eventDetailsTabBar.selectedItem?.title == Tabs.pinned.rawValue {
            NSLayoutConstraint.deactivate([
                collectionView.topAnchor.constraint(equalTo: v.topAnchor),
                collectionView.rightAnchor.constraint(equalTo: v.rightAnchor),
                collectionView.leftAnchor.constraint(equalTo: v.leftAnchor),
                collectionView.bottomAnchor.constraint(equalTo: v.bottomAnchor),
                
                userCollectionView.topAnchor.constraint(equalTo: v.topAnchor),
                userCollectionView.rightAnchor.constraint(equalTo: v.rightAnchor),
                userCollectionView.leftAnchor.constraint(equalTo: v.leftAnchor),
                userCollectionView.bottomAnchor.constraint(equalTo: v.bottomAnchor),
            ])
            NSLayoutConstraint.activate([
                pinnedMessagesCollectionView.topAnchor.constraint(equalTo: v.topAnchor),
                pinnedMessagesCollectionView.rightAnchor.constraint(equalTo: v.rightAnchor),
                pinnedMessagesCollectionView.leftAnchor.constraint(equalTo: v.leftAnchor),
                pinnedMessagesCollectionView.bottomAnchor.constraint(equalTo: v.bottomAnchor),
            ])
        }
    }
    
    
    //MARK: - Register Cells
    private func createMessageCollectionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            return self.viewModel.createSection(for : sectionIndex)
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        ///Input for our messageCell
        collectionView.register(
            MessageCollectionViewCell.self,
            forCellWithReuseIdentifier: MessageCollectionViewCell.cellIdentifier
        )
        collectionView.register(EventOverviewCollectionViewCell.self,
                                forCellWithReuseIdentifier: EventOverviewCollectionViewCell.cellIdentifier
        )
        return collectionView
    }
    
    private func createUserCollectionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout {[weak self] sectionIndex, _ in
            return self?.viewModel.createMessageSectionLayout()
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
    
    private func createPinnedMessagesCollectionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout {[weak self] sectionIndex, _ in
            return self?.viewModel.createMessageSectionLayout()
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        ///Input for our messageCell
        collectionView.register(
            MessageCollectionPinnedViewCell.self,
            forCellWithReuseIdentifier: MessageCollectionPinnedViewCell.cellIdentifier
        )
        return collectionView
    }
    
    @objc
    private func submit() {
        guard let text = messageInputText.text else {return}
        viewModel.postMessage(msg: text)
        collectionView?.reloadData()
        messageInputText.text = nil

    }
    
    private func refreshCells() {
        guard let collectionView = collectionView, let userCollectionView = userCollectionView else {return}
        collectionView.reloadData()
        userCollectionView.reloadData()
        v.reloadInputViews()
    }

}

//MARK: - MessageListViewModelDelegate
extension MessageListView : MessageListViewModelDelegate {
    
    func postedMessageRefreshMessages() {
        guard let collectionView = collectionView else {return}
        collectionView.isHidden = false
        userCollectionView?.isHidden = false
        refreshCells()
        UIView.animate(withDuration: 0.7) {
            collectionView.alpha = 1
        }
    }
    
    func didLoadInitialUsers() {
        guard let collectionView = userCollectionView else {return}
        spinner.stopAnimating()
        refreshCells()
        //Only reload for init fetch of characters
        UIView.animate(withDuration: 0.7) {
            collectionView.alpha = 1
        }
    }
    
    func didLoadPinnedMessages() {
        guard let collectionView = pinnedMessagesCollectionView else {return}
        collectionView.reloadData()
        UIView.animate(withDuration: 0.7) {
            collectionView.alpha = 1
        }
    }
    

    func didLoadInitialMessages() {
        guard let collectionView = collectionView else {return}
        print("Made it here")
        spinner.stopAnimating()
        
        collectionView.isHidden = false
        userCollectionView?.isHidden = false
        refreshCells()
        UIView.animate(withDuration: 0.7) {
            collectionView.alpha = 1
        }
    }

    
}

//MARK: - TabBar Delegate
extension MessageListView : UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.title == Tabs.users.rawValue {
            collectionView?.isHidden = true
            userCollectionView?.isHidden = false
            pinnedMessagesCollectionView?.isHidden = true
            addConstraints()
        } else if item.title == Tabs.messages.rawValue {
            collectionView?.isHidden = false
            userCollectionView?.isHidden = true
            pinnedMessagesCollectionView?.isHidden = true
            addConstraints()
        } else if item.title == Tabs.pinned.rawValue {
            collectionView?.isHidden = true
            userCollectionView?.isHidden = true
            pinnedMessagesCollectionView?.isHidden = false
            addConstraints()
        }
    }
}
