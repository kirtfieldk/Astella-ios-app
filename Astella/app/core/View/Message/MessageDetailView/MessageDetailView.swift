//
//  MessageDetailView.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/10/23.
//

import UIKit

final class MessageDetailView : UIView {
    private let viewModel : MessageDetailViewModel
    public var collectionView : UICollectionView?
    
    private let messageInputText : UITextField = {
        let messageInputText = UITextField()
        messageInputText.translatesAutoresizingMaskIntoConstraints = false
        messageInputText.keyboardType = .twitter
        messageInputText.backgroundColor = .lightGray
        return messageInputText
    }()
    
    private let submitTextBtn : UIButton = {
        let submitTextBtn = UIButton(configuration: .bordered())
        submitTextBtn.translatesAutoresizingMaskIntoConstraints = false
        submitTextBtn.addTarget(self, action: #selector(submit),for: .touchDown)
        submitTextBtn.setTitle("Send", for: .normal)
        return submitTextBtn
    }()
    
    private let textInput : UIView = {
       let textInput = UIView()
        textInput.translatesAutoresizingMaskIntoConstraints = false
        return textInput
    }()
    
    init(frame: CGRect, viewModel : MessageDetailViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        let collectionView = createCollectionView()
        self.collectionView = collectionView
        textInput.addSubviews(messageInputText, submitTextBtn)
        addSubviews(collectionView, textInput)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout {[weak self] sectionIndex, _ in
            return self?.createSection(for: sectionIndex)
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        ///Input for our messageCell
        collectionView.register(
            MessageCollectionViewCell.self,
            forCellWithReuseIdentifier: MessageCollectionViewCell.cellIdentifier
        )
        collectionView.register(
            MessageDetailViewCell.self,
            forCellWithReuseIdentifier: MessageDetailViewCell.cellIdentifier
        )
        return collectionView
    }
    
    private func createSection(for sectionIndex : Int) -> NSCollectionLayoutSection {
        let sectionTypes = viewModel.sections
        switch sectionTypes[sectionIndex]  {
        case .message:
            return viewModel.createMsgFocusSection()
        case .threadMessages:
            return viewModel.createMsgThreadSection()
        }
    }
    
    private func addConstraints() {
        guard let collectionView = collectionView else {return}
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
//            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            textInput.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20),
            textInput.leftAnchor.constraint(equalTo: leftAnchor),
            textInput.rightAnchor.constraint(equalTo: rightAnchor),
            textInput.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    @objc
    private func submit() {
        guard let text = messageInputText.text else {return}
        viewModel.postMessage(msg: text)
        collectionView?.reloadData()
        messageInputText.text = nil

    }
}
