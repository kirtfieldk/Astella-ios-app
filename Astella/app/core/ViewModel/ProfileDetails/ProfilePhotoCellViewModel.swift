//
//  ProfilePhotoViewModel.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/4/23.
//

import UIKit

final class ProfilePhotoCellViewModel  {
    
    public let imageUrl: URL?
    public var image : UIImage?
    
    // MARK: - Init
    init(imageUrl: URL) {
        self.imageUrl = imageUrl
    }
    
    // MARK: - Public
    public func fetchImage(completion : @escaping (Result<Data, Error>) -> Void) {
        guard let imageUrl = imageUrl else {return}
        ImageManager.shared.downloadImage(imageUrl, completion: completion)  
    }
    
}
