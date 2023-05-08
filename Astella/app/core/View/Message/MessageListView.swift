//
//  MessageListView.swift
//  Astella
//
//  Created by Keith Kirtfield on 4/30/23.
//

import UIKit

final class MessageListView: UIView {

    public  var eventId : UUID
    public var eventName : String
    private let viewModel : MessageListViewModel
    public var collectionView : UICollectionView?

    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    private let eventDetailsTabBar : UITabBar = {
        let tabbar = UITabBar()
        tabbar.barTintColor = .green
        tabbar.translatesAutoresizingMaskIntoConstraints = false
        let messages = UITabBarItem(title: "Messages", image: nil, tag: 1)
    
        let users = UITabBarItem(title: "Users", image: nil, tag: 1)
        tabbar.setItems([messages, users], animated: true)
        
        return tabbar
    }()

    init(frame : CGRect, viewModel : MessageListViewModel) {
        self.viewModel = viewModel
        self.eventId = viewModel.eventId
        self.eventName = viewModel.eventName
        super.init(frame: frame)
        viewModel.delegate = self
        translatesAutoresizingMaskIntoConstraints = false
        let collectionView = createCollectionView()
        self.collectionView = collectionView
        //Do not need view since we are already in view
        addSubviews(collectionView, spinner, eventDetailsTabBar)
        addConstraints()
        spinner.startAnimating()
        ///TODO -- Grab the userId and EventId, For delegate need to conform to view model delegate
    }

    // MARK: - INIT
    required init?(coder : NSCoder) {
        fatalError("Not Supported")
    }

    private func addConstraints() {
        guard let collectionView = collectionView else {return}
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),

            eventDetailsTabBar.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.20),
            eventDetailsTabBar.topAnchor.constraint(equalTo: topAnchor),
            eventDetailsTabBar.leftAnchor.constraint(equalTo: leftAnchor),
            eventDetailsTabBar.rightAnchor.constraint(equalTo: rightAnchor),
            
            collectionView.topAnchor.constraint(equalTo: eventDetailsTabBar.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)

        ])
    }
    //MARK: - Register Cells
    private func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            return self.createSection(for : sectionIndex)
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isHidden = true
        collectionView.alpha = 0
        ///Input for our messageCell
        collectionView.register(
            MessageCollectionViewCell.self,
            forCellWithReuseIdentifier: MessageCollectionViewCell.cellIdentifier
        )
        collectionView.register(
            UserCollectionViewCell.self,
            forCellWithReuseIdentifier: UserCollectionViewCell.cellIdentifier
        )

        return collectionView
    }
    
    private func createSection(for sectionIndex : Int) -> NSCollectionLayoutSection {
        let sectionTypes = viewModel.sections
        switch sectionTypes[sectionIndex]  {
        case .messages:
            return viewModel.createMessageSectionLayout()
        case .users:
            return viewModel.createUserSectionLayout()
        }
        
    }

}

//MARK: - MessageListViewModelDelegate
extension MessageListView : MessageListViewModelDelegate {
    func didLoadInitialUsers() {
        print("reloading Users")
        guard let collectionView = collectionView else {return}
        spinner.stopAnimating()
        viewModel.setUpSections()
        collectionView.isHidden = false
        //Only reload for init fetch of characters
        collectionView.reloadData()
        UIView.animate(withDuration: 0.4) {
            collectionView.alpha = 1
        }
    }
    

    func didLoadInitialMessages() {
        print("reloading Messages")
        guard let collectionView = collectionView else {return}
        spinner.stopAnimating()
        viewModel.setUpSections()
        collectionView.isHidden = false
        //Only reload for init fetch of characters
        collectionView.reloadData()
        UIView.animate(withDuration: 0.4) {
            collectionView.alpha = 1
        }
    }

    
}

