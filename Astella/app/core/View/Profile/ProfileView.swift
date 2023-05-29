//
//  ProfileView.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/5/23.
//

import UIKit



final class ProfileView : UIView {
    //MARK: - Vars
    private let viewModel : ProfileViewModel
    public var collectionView : UICollectionView?
    
    public let nameLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 30, weight: .bold)
        return label
    }()
    
    public let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    private let settingButton : UIButton = {
        let btn = UIButton()
        let img = UIImage(systemName: "slider.horizontal.3")
        btn.setImage(img, for: .normal)
        btn.tintColor = .black
        btn.addTarget(self, action: #selector(goToSettings), for: .touchDown)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let saveBtn : UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.configuration = .plain()
        btn.tintColor = .systemCyan
        btn.addTarget(self, action: #selector(updateUser), for: .touchDown)
        btn.setTitle("Save", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    init(frame : CGRect, viewModel : ProfileViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        createCollectionViews()

   }
    
    //MARK: - Create Collection View
    public func createCollectionViews() {
        let collectionView = createCollectionView()
        self.collectionView = collectionView
        self.collectionView?.isHidden = true
        addSubviews(nameLabel, collectionView, spinner)
        spinner.startAnimating()
        if viewModel.isEditing {
            addSubviews(saveBtn)
        } else {
            addSubviews(settingButton)
        }
        addConstraints()
    }

    // MARK: - INIT
    required init?(coder : NSCoder) {
        fatalError("Not Supported")
    }

    private func addConstraints() {
        guard let collectionView = collectionView else {return}
        if viewModel.isEditing {
            NSLayoutConstraint.activate([
                spinner.widthAnchor.constraint(equalToConstant: 100),
                spinner.heightAnchor.constraint(equalToConstant: 100),
                spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
                spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
                nameLabel.topAnchor.constraint(equalTo: topAnchor),
                nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
                nameLabel.trailingAnchor.constraint(equalTo: saveBtn.leadingAnchor),
                saveBtn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
                saveBtn.topAnchor.constraint(equalTo: topAnchor),
                saveBtn.bottomAnchor.constraint(equalTo: collectionView.topAnchor),
                collectionView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
                collectionView.leftAnchor.constraint(equalTo: leftAnchor),
                collectionView.rightAnchor.constraint(equalTo: rightAnchor),
                collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                spinner.widthAnchor.constraint(equalToConstant: 100),
                spinner.heightAnchor.constraint(equalToConstant: 100),
                spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
                spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
                nameLabel.topAnchor.constraint(equalTo: topAnchor),
                nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
                nameLabel.trailingAnchor.constraint(equalTo: settingButton.leadingAnchor),
                settingButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
                settingButton.topAnchor.constraint(equalTo: topAnchor),
                settingButton.bottomAnchor.constraint(equalTo: collectionView.topAnchor),
                collectionView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
                collectionView.leftAnchor.constraint(equalTo: leftAnchor),
                collectionView.rightAnchor.constraint(equalTo: rightAnchor),
                collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
       
    }
    
    //MARK: - Register Cells
    private func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            return self.createSection(for : sectionIndex)
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        ///Input for our messageCell
        collectionView.register(
            ProfilePhotoCollectionViewCell.self,
            forCellWithReuseIdentifier: ProfilePhotoCollectionViewCell.cellIdentifier
        )
        collectionView.register(
            ProfileDetailCollectionCell.self,
            forCellWithReuseIdentifier: ProfileDetailCollectionCell.cellIdentifier
        )
        collectionView.register(
            ProfileDetailSocialCellView.self,
            forCellWithReuseIdentifier: ProfileDetailSocialCellView.cellIdentifier
        )
        return collectionView
    }
    
    private func createSection(for sectionIndex : Int) -> NSCollectionLayoutSection {
        let sectionTypes = viewModel.sections
        switch sectionTypes[sectionIndex]  {
        case .photos:
            return viewModel.createProfilePhotoSection()
        case .bio:
            return viewModel.createProfileBioSection()
        case .socials:
            return viewModel.createSocialsSection()
        }
    }
    
    @objc
    private func goToSettings() {
        viewModel.goToSettings()
    }
    
    @objc
    private func updateUser() {
        viewModel.updateUser { [weak self] result in
            switch result {
            case .success(let data):
                print("Successfully Updated User \(String(describing: self?.viewModel.user?.id))")
                if data.data.count > 0 {
                    self?.viewModel.user = data.data[0]
                    DispatchQueue.main.async {
                        self?.collectionView?.reloadData()
                        self?.navigateToProfilePage()
                    }
                }
            case .failure(let err):
                print(String(describing: err))
            }
        
        }
    }
    
    private func navigateToProfilePage() {
        guard let currentViewController = findViewController(), let userId = viewModel.userId else {return}
        let vm = ProfileViewModel(userId: userId, isEditing: false)
        let vc = ProfileViewController(viewModel: vm)
        vc.navigationItem.largeTitleDisplayMode = .never
        currentViewController.navigationController?.pushViewController(vc, animated: true)
    }

}

