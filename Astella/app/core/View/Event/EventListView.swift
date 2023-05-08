//
//  EventListView.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/1/23.
//
import SwiftUI
import UIKit

protocol EventListViewDelegate : AnyObject {
    func rmEventListView(
        _ eventListView : EventListView,
        didSelectMessage event : Event
    )
    
    func rmPrivateEventListView(
        _ eventListView : EventListView,
        didSelectPrivateEvent event : Event
    )
}

final class EventListView : UIView {
    
    public weak var delegate : EventListViewDelegate?
    private let viewModel = EventListViewModel()
    private var collectionView : UICollectionView?
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    required init?(coder : NSCoder) {
        fatalError("Not Supported")
    }
    
    override init(frame : CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        //Do not need view since we are already in view
        let collectionView = createCollectionView() 
        self.collectionView = collectionView
        
        addSubviews(collectionView ,spinner)
        addConstraints()
        spinner.startAnimating()
        viewModel.setUpSections()
        ///TODO -- Grab the userId and EventId, For delegate need to conform to view model delegate
        viewModel.delegate = self
        setupCollectionView()
    }
    
    public func fetchEvents() {
        viewModel.fetchEventsUserMemberOf(tmp: [URLQueryItem(name: "page", value: "0")], firstFetch: true)
        viewModel.fetchEvents(tmp : [URLQueryItem(name: "page", value: "0")], firstFetch: true)
    }

    ///Set the data source, for this project the data will come from view models
    private func setupCollectionView() {
        guard let collectionView = collectionView else {return}
        collectionView.delegate = viewModel
        collectionView.dataSource = viewModel
    }
    
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
            EventCellView.self,
            forCellWithReuseIdentifier: EventCellView.cellIdentifier
            )
        collectionView.register(EventMemberCollectionViewCell.self, forCellWithReuseIdentifier: EventMemberCollectionViewCell.cellIdentifier)
            
        return collectionView
    }
    
    private func addConstraints() {
        guard let collectionView = collectionView else {return}
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
    
    private func createSection(for sectionIndex : Int) -> NSCollectionLayoutSection {
        let sectionTypes = viewModel.sections
        switch sectionTypes[sectionIndex] {
        case .localEvents, .memberEvents:
            return viewModel.createEventSection()
        }
    }
}

// MARK: - EventListViewModelDelegate
extension EventListView : EventListViewModelDelegate {
    func didLoadEvents() {
        guard let collectionView = collectionView else {return}
        collectionView.reloadData()
        viewModel.setUpSections()
        //Only reload for init fetch of characters
        UIView.animate(withDuration: 0.4) {
            collectionView.alpha = 1
        }
    }
    
    func didSelectPrivateEvent(_ event: Event) {
        delegate?.rmPrivateEventListView(self, didSelectPrivateEvent: event)
    }
    
    //Need to add more cells
    func didLoadMoreEvents(with newIndexPath: [IndexPath]) {
        guard let collectionView = collectionView else {return}
        collectionView.performBatchUpdates {
            collectionView.insertItems(at: newIndexPath)
        }
    }
    
    func didLoadInitEvents() {
        guard let collectionView = collectionView else {return}
        spinner.stopAnimating()
        collectionView.isHidden = false
        didLoadEvents()
    }

    func didSelectEvent(_ event: Event) {
        delegate?.rmEventListView(self, didSelectMessage: event)
    }
    
}
