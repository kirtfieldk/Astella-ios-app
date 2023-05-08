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
    
    init(viewModel : MessageListViewModel) {
        self.viewModel = viewModel
        self.messageListView = MessageListView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
        self.messageListView.collectionView?.delegate = self
        self.messageListView.collectionView?.dataSource = self

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
}


// MARK: - Collection View Impl
/// Create extension to conform to protocol
extension MessagesViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = viewModel.sections[section]
        switch sectionType {
        case .messages(viewModel: let self):
            print(self.count)
            return self.count
        case .users(viewModel: let self):
            print(self.count)
            return self.count
        }
    }
    ///Deque and return single cell, using messagecellview
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = viewModel.sections[indexPath.section]
        switch sectionType {
        case .messages(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MessageCollectionViewCell.cellIdentifier,
                for: indexPath
            ) as? MessageCollectionViewCell else {
                fatalError("Unsupported cell")
            }
            cell.configuration(with: viewModel[indexPath.row])
            return cell
        case .users(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: UserCollectionViewCell.cellIdentifier,
                for: indexPath
            ) as? UserCollectionViewCell else {
                fatalError("Unsupported cell")
            }
            cell.configure(with: viewModel[indexPath.row])
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
        let sectionType = viewModel.sections[indexPath.section]
        switch sectionType {
        case .messages:
            let msg = viewModel.messages[indexPath.row]
//            let vc = MessageListV
        case .users:
            let usr = viewModel.users[indexPath.row]
            let vc = ProfileViewController(viewModel: ProfileViewModel(user: usr))
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
     
}
