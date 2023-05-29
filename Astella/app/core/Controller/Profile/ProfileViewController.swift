//
//  ProfileViewController.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/2/23.
//
import SwiftUI
import UIKit


final class ProfileViewController : UIViewController {
    private let viewModel : ProfileViewModel
    private let profileView : ProfileView
    private var fetchUserLoading : Bool = false
    private var fetchUserImages : Bool = false
    
    //MARK: - init
    init(viewModel : ProfileViewModel) {
        self.viewModel = viewModel
        self.profileView = ProfileView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        profileView.collectionView?.delegate = viewModel
        profileView.collectionView?.dataSource = viewModel
        view.addSubview(profileView)
        setUpView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUserLoading = true
        viewModel.getUser {[weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let data):
                if data.data.count > 0 {
                    let el = data.data[0]
                    print("Fetched User \(el.id)")
                    self.fetchUserLoading = false
                    self.viewModel.setUserParams(user: el, tiktok: el.tiktok, twitter: el.twitter, youtube: el.tiktok, desc: el.description, ig: el.ig, snapchat: el.twitter)
                    self.viewModel.buildSocialAndPhotoArr()
                    DispatchQueue.main.async {
                        self.profileView.nameLabel.text = el.username
                    }
                } else {
                    print("User No entry")
                }
            case.failure(let err):
                print(String(describing: err))
            }
        }
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
    

//MARK: = Extension delegate
extension ProfileViewController : ProfileViewModelDelegate {
    func isDoneLoading() {
        if !fetchUserImages && !fetchUserLoading {
            profileView.spinner.stopAnimating()
            profileView.collectionView?.isHidden = false
            viewModel.setUpSections()
            profileView.collectionView?.reloadData()
            //Only reload for init fetch of characters
            UIView.animate(withDuration: 0.4) {
                self.profileView.collectionView?.alpha = 1
            }
        }
    }
    
    func isFetchUserImage(fetching: Bool) {
        self.fetchUserImages = fetching
    }
    
    func reloadCollectionView() {
        self.viewModel.setUpSections()
        self.profileView.collectionView?.reloadData()
    }
    
    func goToSettings(user : User) {
        let vm = ProfileSettingViewModel(user: User.usr)
        let vc = ProfileSettingViewController(viewModel: vm)
        vc.navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.pushViewController(vc, animated: true)
    }
}

