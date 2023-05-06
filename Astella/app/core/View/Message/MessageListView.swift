//
//  MessageListView.swift
//  Astella
//
//  Created by Keith Kirtfield on 4/30/23.
//

import UIKit

protocol MessageListViewDelegate : AnyObject {
    func rmMessageListView(
        _ messageListView : MessageListView,
        didSelectMessage message : Message
    )
}

final class MessageListView: UIView {
    
    public weak var delegate : MessageListViewDelegate?
    private let viewModel = MessageListViewModel()
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    override init(frame : CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        //Do not need view since we are already in view
        addSubviews(collectionView ,spinner)
        addConstraints()
        spinner.startAnimating()
        ///TODO -- Grab the userId and EventId, For delegate need to conform to view model delegate
        viewModel.delegate = self
        viewModel.fetchMessages(userId: "aecd2c62-1eee-46fa-8ad9-6440cb4d0e88", eventId: "ceaee292-b377-4052-9458-646f659e6a9e")
        setupCollectionView()
    }
    
    required init?(coder : NSCoder) {
        fatalError("Not Supported")
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)

        ])
    }
    
    private let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isHidden = true
        collectionView.alpha = 0
        ///Input for our messageCell
        collectionView.register(MessageCellView.self, forCellWithReuseIdentifier: MessageCellView.cellIdentifier)
        return collectionView
        
    }()
    ///Set the data source, for this project the data will come from view models
    private func setupCollectionView() {
        collectionView.delegate = viewModel
        collectionView.dataSource = viewModel
        
    }
    
}


extension MessageListView : MessageListViewModelDelegate {
    //Need to get message to controller
    func didSelectMessage(_ msg: Message) {
        delegate?.rmMessageListView(self, didSelectMessage: msg)
    }
    
    func didLoadInitialMessages() {
        spinner.stopAnimating()
        collectionView.isHidden = false
        collectionView.reloadData()
        //Only reload for init fetch of characters
        collectionView.reloadData()
        UIView.animate(withDuration: 0.4) {
            self.collectionView.alpha = 1
        }
    }
    
    
}
