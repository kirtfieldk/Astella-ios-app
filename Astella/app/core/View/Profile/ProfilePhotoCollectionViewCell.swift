//
//  ProfilePictureCollectionViewCell.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/4/23.
//

import UIKit


struct ProfilePictureCollectionViewCell : Identifiable, Hashable {
    let id = UUID()
    
    static let cellIdentifier = "ProfilePictureCollectionViewCell"

    let image : UIImage?
    let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    init(image: UIImage?) {
        self.image = image
    }
    
    func setUpImage() {
        guard let image = image else {return}
        self.imageView.image = image
    }
    
}
