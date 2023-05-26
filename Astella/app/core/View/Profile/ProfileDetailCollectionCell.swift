//
//  ProfileBioCollectionCell.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/5/23.
//

import UIKit

final class ProfileDetailCollectionCell : UICollectionViewCell {
    static let cellIdentifier = "ProfileDetailCollectionCell"
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.textColor = UIColor.black
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = NSTextAlignment.left
        textView.dataDetectorTypes = UIDataDetectorTypes.all
        textView.layer.shadowOpacity = 0.5
        textView.contentMode = .scaleAspectFit
        textView.font = .systemFont(ofSize: 20)
        textView.alpha = 1
        return textView
    }()
    
    private let divider : UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(textView, divider)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textView.text = nil
    }
    
    func configure(with viewModel : ProfileDetailCellViewModel) {
        textView.text = viewModel.usr.description
        viewModel.delegate = self
        if viewModel.isEditing {
            textView.isEditable = true
            textView.layer.borderWidth = 1
            textView.layer.cornerRadius = 10
        } else {
            textView.isEditable = false
        }
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            textView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            textView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            textView.heightAnchor.constraint(equalToConstant: 160),
            divider.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 1),
            divider.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            divider.rightAnchor.constraint(equalTo: rightAnchor, constant: -10 ),
            divider.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
}


extension ProfileDetailCollectionCell : ProfileDetailCellViewModelDelegate {
    func grabInputValue() -> String {
        guard let txt = textView.text else {return ""}
        print(txt)
        return txt
    }
}
