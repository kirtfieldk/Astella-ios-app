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

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}


