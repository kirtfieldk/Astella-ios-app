//
//  MessagestructMainViewController.swift
//  Astella
//
//  Created by Keith Kirtfield on 4/30/23.
//

import SwiftUI

struct MessageStructMainViewController: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> MessagesViewController {
        return MessagesViewController()
        }
    ///Useless
    func updateUIViewController(_ uiViewController: MessagesViewController, context: Context) {
        
    }
}
