//
//  ProfileSettingView.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/18/23.
//

import UIKit

final class ProfileSettingView : UIView {
    private let viewModel : ProfileSettingViewModel
    
    init(frame: CGRect, viewModel : ProfileSettingViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
