//
//  Extensions.swift
//  Astella
//
//  Created by Keith Kirtfield on 4/30/23.
//

import UIKit

extension UIView {
    func addSubviews(_ views : UIView...) {
        views.forEach({
            addSubview($0)
        })
    }
    
    func findViewController() -> UIViewController? {
            if let nextResponder = self.next as? UIViewController {
                return nextResponder
            } else if let nextResponder = self.next as? UIView {
                return nextResponder.findViewController()
            } else {
                return nil
            }
        }
}
