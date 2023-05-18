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
    
    
    //MARK: - init
    init(viewModel : ProfileViewModel) {
        self.viewModel = viewModel
        self.profileView = ProfileView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
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
    
    func setUpView() {
        NSLayoutConstraint.activate([
            profileView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            profileView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            profileView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            profileView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    }
    


extension ProfileViewController : ProfileViewModelDelegate {
    func goToSettings(user : User) {
        let vm = ProfileViewModel(user: user, isEditing: true)
    }
}
