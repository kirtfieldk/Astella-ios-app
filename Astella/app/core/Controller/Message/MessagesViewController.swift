//
//  MessagesViewController.swift
//  Astella
//
//  Created by Keith Kirtfield on 4/30/23.
//

import UIKit

final class MessagesViewController: UIViewController, MessageListViewDelegate {
    
    private let messageListView = MessageListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Messages"
        setUpView()
    }
    
    func setUpView() {
        messageListView.delegate = self
        view.addSubview(messageListView)
        NSLayoutConstraint.activate([
            messageListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            messageListView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            messageListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            messageListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: MessageListViewDelegate Impl
    func rmMessageListView(_ messageListView: MessageListView, didSelectMessage message: Message) {
        //Open Controller for thread and what user likes
    }
}
