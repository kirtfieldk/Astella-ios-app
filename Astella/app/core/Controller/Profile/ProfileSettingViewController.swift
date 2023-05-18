//
//  ProfileSettingViewController.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/18/23.
//

import UIKit

final class ProfileSettingViewController : UIViewController {
    private let viewModel : ProfileSettingViewModel
    private let settingView : ProfileSettingView
    
    required init?(coder: NSCoder) {
        fatalError("Not supported")
    }
    
    init(viewModel : ProfileSettingViewModel) {
        self.viewModel = viewModel
        self.settingView = ProfileSettingView(frame: .zero, viewModel: viewModel)
        super.init()
        view.addSubview(settingView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            settingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            settingView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            settingView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            settingView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
