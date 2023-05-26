//
//  ProfileSettingViewCellCollectionViewCell.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/19/23.
//

import UIKit

class ProfileSettingViewCellCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "ProfileSettingViewCellCollectionViewCell"
    private var viewModel : ProfileSettingCellViewModel?
    
    private let btn : UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.configuration?.titleAlignment = .leading
        btn.configuration = .plain()
        btn.configuration?.buttonSize = .medium
        btn.configuration?.image = UIImage(systemName: "pencil")
        btn.configuration?.imagePlacement = .leading
        btn.configuration?.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(scale: .medium)
        btn.tintColor = .black
        btn.addTarget(self, action: #selector(pushToEditProfile), for: .touchDown)
        return btn
    }()
    
    private let divider : UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(viewModel : ProfileSettingCellViewModel) {
        self.viewModel = viewModel
        btn.setTitle(viewModel.setting.rawValue, for: .normal)

        addSubviews(btn, divider)
        addConstraint()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        btn.setTitle(nil, for: .normal)
    }
    
    private func addConstraint() {
        NSLayoutConstraint.activate([
            btn.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            btn.leadingAnchor.constraint(equalTo: leadingAnchor),
            btn.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
//            btn.trailingAnchor.constraint(equalTo: trailingAnchor),
//            btn.bottomAnchor.constraint(equalTo: divider.topAnchor),
            divider.bottomAnchor.constraint(equalTo: bottomAnchor),
            divider.leadingAnchor.constraint(equalTo: leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: trailingAnchor),
            divider.topAnchor.constraint(equalTo: btn.bottomAnchor),
            divider.heightAnchor.constraint(equalToConstant: 1),
            
        ])
    }
    
    @objc
    private func pushToEditProfile() {
        viewModel?.pushToEditProfile()
    }
    
}
