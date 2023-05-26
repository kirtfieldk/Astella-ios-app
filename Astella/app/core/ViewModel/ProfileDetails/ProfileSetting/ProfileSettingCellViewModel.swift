//
//  ProfileSettingCellViewModel.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/18/23.
//

import UIKit

class ProfileSettingCellViewModel {
    public let setting : SettingTypes
    public weak var delegate : ProfileSettingCellViewModelDelegate?
    
    init(setting : SettingTypes) {
        self.setting = setting
    }
    
    public func clickSetting() {
        switch setting {
        case .editProfile:
            delegate?.pushToEditProfile()
        }
    }
    
    public func pushToEditProfile() {
        delegate?.pushToEditProfile()
    }
}

protocol ProfileSettingCellViewModelDelegate : AnyObject {
    func pushToEditProfile()
}
