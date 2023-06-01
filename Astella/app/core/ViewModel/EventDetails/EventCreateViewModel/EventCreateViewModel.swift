//
//  EventCreateViewModel.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/15/23.
//

import UIKit
import CoreLocation

final class EventCreateViewModel : NSObject {
    
    enum SectionTypes {
        case map(viewModel : EventCreateMapViewCellViewModel)
    }
    
    private var sections : [SectionTypes] = []
    private var locationInfo : LocationInfoPost?
    private var userCords : CLLocationCoordinate2D?
    
    public func setupSections() {
        sections = [
            .map(viewModel: EventCreateMapViewCellViewModel(viewModel: self))
        ]
    }
    
    override init() {
        super.init()
    }
    
    public func postCreateEvent(name : String, desc : String, isPublic : Bool, code : String, duration : Int, completion : @escaping (Result<EventListResponse, Error>) -> Void) {
        guard let locationInfo = locationInfo else {return}
        let event = EventPost(name: name, is_public: isPublic, code: code, description: desc, duration: duration, location_info: locationInfo, user_id: UserManager.shared.getUserId())
        let req = RequestPostService(
            urlIds: AstellaUrlIds(userId: "", eventId: "", messageId: ""),
            endpoint: AstellaEndpoints.CREATE_EVENT, httpMethod: "POST", httpBody: event, queryParameters: [])
        AstellaService.shared.execute(req, expecting: EventListResponse.self, completion: completion) 
    }
    
    private func createMapCollectionView() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1))
        )
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 10,
            trailing: 0)
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(0.90)),
            subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    public func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout(section: createMapCollectionView())
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        ///Input for our messageCell
        collectionView.register(
            EventCreateMapViewCell.self,
            forCellWithReuseIdentifier: EventCreateMapViewCell.cellIdentifier)
        return collectionView
    }
}

extension EventCreateViewModel : UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds.width
        return CGSize(width: bounds , height: (UIScreen.main.bounds.height))
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = sections[indexPath.section]
        switch sectionType {
        case .map(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: EventCreateMapViewCell.cellIdentifier,
                for: indexPath
            ) as? EventCreateMapViewCell else {
                fatalError("Unsupported cell")
            }
            cell.configuration(viewModel : viewModel)
            cell.delegate = self
            return cell
        
        }
    }
}


extension EventCreateViewModel : EventCreateMapViewCellDelegate {
    func setUserCords(coords: CLLocationCoordinate2D) {
        self.userCords = coords
    }
    
    func submitLocationInfo(info: LocationInfoPost) {
        self.locationInfo = info
    }
}
