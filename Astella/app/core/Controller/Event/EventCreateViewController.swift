//
//  EventCreateViewController.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/15/23.
//

import UIKit

final class EventCreateViewController : UIViewController {
    private let vm : EventCreateViewModel = EventCreateViewModel()
    private var eventCreateView : EventCreateView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventCreateView = EventCreateView(frame: .zero, viewModel: vm)
        guard let eventCreateView = eventCreateView else {return}
        eventCreateView.mapCollectionView?.delegate = vm
        eventCreateView.mapCollectionView?.dataSource = vm
        title = "Create Event"
        view.addSubviews(eventCreateView)
        addConstrains()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    private func addConstrains() {
        guard let eventCreateView = eventCreateView else {return}
        NSLayoutConstraint.activate([
            eventCreateView.topAnchor.constraint(equalTo: view.topAnchor),
            eventCreateView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            eventCreateView.rightAnchor.constraint(equalTo: view.rightAnchor),
            eventCreateView.leftAnchor.constraint(equalTo: view.leftAnchor),
        ])
    }
}

