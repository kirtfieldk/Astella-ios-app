//
//  MessageDetailViewController.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/10/23.
//

import UIKit

final class MessageDetailViewController : UIViewController {
    let viewModel : MessageDetailViewModel
    let messageView : MessageDetailView
    
    init(viewModel : MessageDetailViewModel) {
        self.viewModel = viewModel
        self.messageView = MessageDetailView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self.messageView
        self.messageView.collectionView?.delegate = self.viewModel
        self.messageView.collectionView?.dataSource = self.viewModel
        self.viewModel.vcDelegate = self

        view.addSubview(messageView)
        setUpView()

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getMessageThread()
    }
    
    func setUpView() {
        NSLayoutConstraint.activate([
            messageView.topAnchor.constraint(equalTo: view.topAnchor),
            messageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            messageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            messageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    
}


extension MessageDetailViewController : MessageDetailViewModelVcDelegate {
    func redirectIntoUpvoteDetail(msg: Message, eventId: UUID) {
        let vm = ProfileBriefListViewModel(msg: msg, eventId: eventId)
        let vc = ProfileBriefListViewController(viewModel: vm)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func redirectIntoMessageDetail(msg: Message, eventId: UUID) {
        let vm = MessageDetailViewModel(msg: msg, event: eventId)
        let vc = MessageDetailViewController(viewModel: vm)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
