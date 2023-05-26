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
        super.init(nibName: nil, bundle: nil)
        settingView.collectionView?.delegate = viewModel
        settingView.collectionView?.dataSource = viewModel
        self.viewModel.delegate = self
        title = "Settings"
        view.addSubview(settingView)
        addConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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

extension ProfileSettingViewController : ProfileSettingViewModelDelegate {
    func pushToEditProfile() {
        let vm = ProfileViewModel(user: User.usr, isEditing: true)
        let vc = ProfileViewController(viewModel: vm)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}
