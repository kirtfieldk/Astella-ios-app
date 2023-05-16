//
//  EventCreateMapViewCellCiewModel.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/15/23.
//

import UIKit

protocol EventCreateMapViewCellViewModelDelegate : AnyObject {
    func createLocationIndo(locationInfo : LocationInfo)
}
final class EventCreateMapViewCellViewModel {
    private let viewModel : EventCreateViewModel
    
    init(viewModel : EventCreateViewModel) {
        self.viewModel = viewModel
    }
}
