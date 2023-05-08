//
//  EventPasswordInputModalViewController.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/6/23.
//

import UIKit

final class EventPasswordInputModalViewController : UIViewController, EventPasswordInputViewDelegate {
    private let passwordInputView : EventPasswordInputView
    private let viewModel : EventPasswordInputViewModel
    private var alreadyMember : Bool = false
    
    init(viewModel : EventPasswordInputViewModel) {
        self.passwordInputView = EventPasswordInputView(frame: .zero, viewModel: viewModel)
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.passwordInputView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if alreadyMember {
            let eventVc = EventListViewController()
            eventVc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(eventVc, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(passwordInputView)
        title = ""
        setUpView()
    }
    
    
    func setUpView() {
        NSLayoutConstraint.activate([
            passwordInputView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            passwordInputView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            passwordInputView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            passwordInputView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func pushIntoMessages(event: Event) {
        let viewModel = MessageListViewModel(event: event)
        let messagesVc = MessagesViewController(viewModel: viewModel)
        messagesVc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.viewControllers = [messagesVc]
        navigationController?.pushViewController(messagesVc, animated: true)
    }
    
    func setAlreadyMemberToTrue() {
        alreadyMember = true
    }
    
}
