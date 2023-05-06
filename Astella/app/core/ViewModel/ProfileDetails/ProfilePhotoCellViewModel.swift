//
//  ProfilePhotoViewModel.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/4/23.
//

import UIKit

final class ProfilePhotoViewModel  {
    
    public let imageUrl: URL?
    public var image : UIImage?
    
    // MARK: - Init
    init(imageUrl: URL) {
        self.imageUrl = imageUrl
        fetchImage()
        
        
    }
    
    // MARK: - Public
    private func fetchImage() {
        guard let imageUrl = imageUrl else {return}
        ImageManager.shared.downloadImage(imageUrl) {[weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    guard let img = UIImage(data: data) else {return}
                    self?.image = img
                }
            case .failure(let err):
                print("Issue fetching photo")
                print(String(describing: err))
                return
                
            }
        }
    }
    
}
