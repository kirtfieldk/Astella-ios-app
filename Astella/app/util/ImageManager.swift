//
//  ImageManager.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/3/23.
//

import Foundation



final class ImageManager  {
    static let shared = ImageManager()
    private var imageDataCache = NSCache<NSString, NSData>()
    
    private init() {
    
    }
    
    // Get image with url, check cache
    public func downloadImage(_ url : URL, completion: @escaping (Result<Data, Error>) -> Void) {
        let key = url.absoluteString as NSString
        if let data = imageDataCache.object(forKey: key) {
            print("Reading from cache: \(key)")
            completion(.success(data as Data))
            return
        }
        let req = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: req) {[weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? URLError(.badServerResponse)))
                return
            }
            
            let value = data as NSData
            self?.imageDataCache.setObject(value, forKey: key)
            completion(.success(data))
        }
        task.resume()
    }
    
}
