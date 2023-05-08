//
//  EventCellViewViewModel.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/1/23.
//

import UIKit

final class EventCellViewViewModel {
    public let event : Event
    public var isPublic : Bool
    public let isMember : Bool
    // MARK: - Init
    init(
        event : Event,
        isMember : Bool
    ) {
        self.event = event
        self.isPublic = event.is_public
        self.isMember = isMember
    }
}


