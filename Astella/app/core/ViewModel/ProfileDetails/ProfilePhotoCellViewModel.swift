//
//  ProfilePhotoViewModel.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/4/23.
//

import UIKit

final class ProfilePhotoCellViewModel : NSObject {
    
    public var imageUrl: UIImage?
    public let editing : Bool
    public weak var delegate : ProfilePhotoCellViewModelDelegate?
    public weak var collectionDelegate : ProfilePhotoCellViewModelUpdateCollectionViewDelegate?
    public var isEmpty : Bool

    
    // MARK: - Init
    init(imageUrl: UIImage, editing : Bool, isEmpty : Bool) {
        self.imageUrl = imageUrl
        self.editing = editing
        self.isEmpty = isEmpty
    }
}

extension ProfilePhotoCellViewModel : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("Image selected")
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            isEmpty = false
            DispatchQueue.main.async {
                self.delegate?.refreshImage(image: image)
            }
            collectionDelegate?.updateCollectionView(image : image, oldPhoto: imageUrl)
        }            
        picker.dismiss(animated: true, completion: nil)

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

protocol ProfilePhotoCellViewModelDelegate : AnyObject {
    func refreshImage(image : UIImage)
}

protocol ProfilePhotoCellViewModelUpdateCollectionViewDelegate : AnyObject {
    func updateCollectionView(image : UIImage, oldPhoto : UIImage?)
}
