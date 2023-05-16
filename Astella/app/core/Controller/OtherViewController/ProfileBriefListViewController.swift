//
//  ProfileBriefListViewController.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/11/23.
//

import UIKit

final class ProfileBriefListViewController : UIViewController {
    let viewModel : ProfileBriefListViewModel
    let profileView : ProfileBriefListView
    
    init(viewModel : ProfileBriefListViewModel) {
        self.profileView = ProfileBriefListView(frame: .zero, viewModel: viewModel)
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.profileView.collectionView?.delegate = self.viewModel
        self.profileView.collectionView?.dataSource = self.viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchUsersWhoLiked {[weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.viewModel.users = data.data
                    self?.viewModel.setUpSections()
                    self?.profileView.collectionView?.isHidden = false
                    self?.profileView.collectionView?.reloadData()
                    UIView.animate(withDuration: 0.4) {
                        self?.profileView.collectionView?.alpha = 1
                    }
                }
            case .failure(let err):
                print(String(describing: err))
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Likes"
        view.addSubviews(profileView)
        setUpView()
        
    }
    
    
    func setUpView() {
        NSLayoutConstraint.activate([
            profileView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            profileView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            profileView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            profileView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension ProfileBriefListViewController : ProfileBreifListViewModelDelegate {
    func redirectIntoProfileDetail(usr: User) {
        let vm = ProfileViewModel(user: usr)
        let vc = ProfileViewController(viewModel: vm)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}
