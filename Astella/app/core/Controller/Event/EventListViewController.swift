//
//  EventListViewController.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/1/23.
//

import UIKit


final class EventListViewController : UIViewController, EventListViewDelegate {

    private let eventListView = EventListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Local Events"
        eventListView.fetchEvents()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("ViewWillAppear")
        eventListView.fetchEvents()
        navigationController?.viewControllers = [self]
    }
    
    func setUpView() {
        eventListView.delegate = self
        view.addSubview(eventListView)
        NSLayoutConstraint.activate([
            eventListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            eventListView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            eventListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            eventListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: - Delegate Impl
    func rmEventListView(_ eventListView: EventListView, didSelectMessage event: Event) {
        //Open messages in that event
        let viewModel = MessageListViewModel(event: event)
        let messagesVc = MessagesViewController(viewModel: viewModel)
        messagesVc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(messagesVc, animated: true)
    }
    
    func rmPrivateEventListView(_ eventListView: EventListView, didSelectPrivateEvent event: Event) {
        let viewModel = EventPasswordInputViewModel(event: event)
        let passwordVc = EventPasswordInputModalViewController(viewModel: viewModel)
        passwordVc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(passwordVc, animated: true)
    }
    
}
