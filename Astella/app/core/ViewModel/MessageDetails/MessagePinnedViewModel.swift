//
//  MessagePinnedViewModel.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/9/23.
//

import UIKit

final class MessagePinnedViewModel : NSObject, MessagePinnedListViewModelDelegate {
    private var messageCellViewModels : [MessageCellViewViewModel] = []
    
    func setMessageCellViewModel(messageCellViewModels: [MessageCellViewViewModel]) {
        print("Called")
        self.messageCellViewModels = messageCellViewModels
    }
}

extension MessagePinnedViewModel : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messageCellViewModels.count
    }
    
    ///Deque and return single cell, using messagecellview
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MessageCollectionPinnedViewCell.cellIdentifier,
            for: indexPath
        ) as? MessageCollectionPinnedViewCell else {
            fatalError("Unsupported cell")
        }
        cell.configuration(with: messageCellViewModels[indexPath.row])
        return cell
    }
    
    ///Get the size of the UI screenof the device
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds.width
        let width = bounds - 20
        return CGSize(width: width , height: ( UIScreen.main.bounds.height))
    }
}
