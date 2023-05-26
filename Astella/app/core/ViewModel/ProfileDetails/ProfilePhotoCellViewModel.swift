//
//  ProfilePhotoViewModel.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/4/23.
//

import UIKit

final class ProfilePhotoCellViewModel : NSObject {
    
    public let imageUrl: UIImage
    public let editing : Bool
    public weak var delegate : ProfilePhotoCellViewModelDelegate?
    public weak var collectionDelegate : ProfilePhotoCellViewModelUpdateCollectionViewDelegate?

    
    // MARK: - Init
    init(imageUrl: UIImage, editing : Bool) {
        self.imageUrl = imageUrl
        self.editing = editing
    }
}

extension ProfilePhotoCellViewModel : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("Image selected")
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            //SetImage
            DispatchQueue.main.async {
                self.delegate?.refreshImage(image: image)
            }
            self.collectionDelegate?.updateCollectionView(image : image, oldPhoto: imageUrl)
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
    func updateCollectionView(image : UIImage, oldPhoto : UIImage)
}
