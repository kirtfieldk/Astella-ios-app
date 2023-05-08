//
//  FooterReusableLoaderView.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/2/23.
//

import UIKit

final class FooterReusableLoaderView : UICollectionReusableView {
    
    static let identifier = "FooterReusableLoaderView"
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubviews(spinner)
    }
    
    required init?(coder : NSCoder) {
        fatalError("Not Supported")
    }
    
    func addConstrains() {
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    public func startAnimating () {
        spinner.startAnimating()
    }
}


