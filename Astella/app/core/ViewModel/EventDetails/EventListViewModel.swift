//
//  EventListViewModel.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/1/23.
//

import UIKit

protocol EventListViewModelDelegate : AnyObject{
    func didLoadInitEvents()
    func didLoadEvents()
    func didSelectEvent(_ event : Event)
    func didSelectPrivateEvent(_ event : Event)
    func didLoadMoreEvents(with newIndexPath: [IndexPath])
}

// MARK: - Main Class Impl
final class EventListViewModel : NSObject {
    
    private var cellViewModels : [EventCellViewViewModel] = []
    private var eventsMemberOfCellViewModels : [EventCellViewViewModel] = []
    private var info : InfoResponse?
    public weak var delegate : EventListViewModelDelegate?
    private var isLoadingMoreEvents  : Bool = false
    //MARK: - CellViewModel List
    public var eventsMemberOf : [Event] = [] {
        didSet {
            eventsMemberOfCellViewModels.append(contentsOf: populateEventCellList(events: eventsMemberOf, viewModels: eventsMemberOfCellViewModels))
        }
    }
    
    private var events : [Event] = []{
        didSet {
            cellViewModels.append(contentsOf: populateEventCellList(events: events, viewModels: cellViewModels))
            makePreEventMember()
        }
    }
    //MARK: - SECTIONS
    enum SectionTypes {
        case localEvents(viewModel : [EventCellViewViewModel])
        case memberEvents(viewModel : [EventCellViewViewModel])
    }
    public var sections : [SectionTypes] = []
    
    public  func createEventSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1))
        )
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 10,
            leading: 5,
            bottom: 10,
            trailing: 5)
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(0.30)),
            subitems: [item, item])
        let section = NSCollectionLayoutSection(group: group)
        //scroll horizontal
//        section.orthogonalScrollingBehavior = .continuous
        //Snaps to next card
//        section.orthogonalScrollingBehavior = .groupPaging

        return section
    }
    
    public func setUpSections() {
        sections = [
            .localEvents(viewModel: events.compactMap({ e in
                return EventCellViewViewModel(event: e,
                                              isMember: eventsMemberOf.contains(where: {$0.id == e.id}))
            })),
            .memberEvents(viewModel: eventsMemberOf.compactMap({
                return EventCellViewViewModel(event: $0, isMember: true)
            }))
        ]
    }
    
    
    override init() {
        super.init()
    }
    //MARK: - FERCHING EVENTS
    func fetchEvents(tmp : [URLQueryItem], firstFetch : Bool) {
        isLoadingMoreEvents = true
        UserLocationManager.shared.getUserLocation { location in
            UserLocationManager.shared.resolveLocationName(with: location) {[weak self] city in
                guard let cityName = city else { return }
                guard let requestService = self?.buildRequest(queryItems: tmp, cityName: cityName) else {
                    return
                }
                if firstFetch {
                    self?.executeInit(requestService: requestService)
                } else {
                    self?.executeFetchMore(requestService: requestService)
                }
                
            }
        }
    }
    
    //MARK: - FETCHING USER EVENTS
    func fetchEventsUserMemberOf(tmp : [URLQueryItem], firstFetch : Bool) {
        let req = RequestGetService(
            urlIds: AstellaUrlIds(userId: "db212c03-8d8a-4d36-9046-ab60ac5b250d", eventId: "", messageId: ""),
            endpoint: AstellaEndpoints.GET_EVENTS_MEMBER_OF,
            queryParameters: tmp)
        AstellaService.shared.execute(req, expecting: EventListResponse.self) {[weak self] result in
            switch result {
            case .success(let resp):
                self?.eventsMemberOf = resp.data
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitEvents()
                }
            case .failure(let err):
                print(String(describing: err))
            }
        }
        
    }
    
    public var shouldShowLoadMore : Bool {
        //Need to see If API has a `next`
        guard let i = info else {
            return false
        }
        return i.next
    }
    
    private func fetchMoreEvents() {
        var queryItem : [URLQueryItem] = []
        isLoadingMoreEvents = true
        guard var page = info?.page else {
            return
        }
        page+=1
        queryItem.append(URLQueryItem(name: "page", value: String(describing:page)))
        fetchEvents(tmp: queryItem, firstFetch: false)
    }
    
    private func buildRequest(queryItems : [URLQueryItem], cityName : String) -> RequestPostService {
        return RequestPostService(
            urlIds: AstellaUrlIds.emptyUrlIds,
            endpoint: AstellaEndpoints.GET_EVENT_BY_CITY,
            httpMethod: "POST",
            httpBody: CityBody(city: cityName),
            queryParameters: queryItems
        )
    }
    
    private func executeInit(requestService : RequestPostService) {
        AstellaService.shared.execute(requestService, expecting: EventListResponse.self)
        {[weak self] result in
            guard let strongSelf = self else {return}
            switch result{
            case .success(let model):
                strongSelf.events = model.data
                strongSelf.info = model.info
                strongSelf.isLoadingMoreEvents = false
                DispatchQueue.main.async {
                    //Throw in main  queue since it is UI refresh
                    strongSelf.delegate?.didLoadInitEvents()
                }
                break
            case .failure(let error):
                strongSelf.isLoadingMoreEvents = false
                print(String(describing: error))
            }
        }
    }
    
    private func executeFetchMore(requestService : RequestPostService) {
        AstellaService.shared.execute(requestService, expecting: EventListResponse.self)
        {[weak self] result in
            guard let strongSelf = self else {return}
            switch result{
            case .success(let model):
                let originalCount = strongSelf.events.count
            
                strongSelf.info = model.info
                let total = strongSelf.events.count + model.data.count
                let startingIndex = (strongSelf.events.count)
                let indexPathToAdd : [IndexPath] =
                Array(startingIndex..<(startingIndex + model.data.count)).compactMap({
                    return IndexPath(row: $0, section: 0)
                })
                strongSelf.events.append(contentsOf: model.data)
                DispatchQueue.main.async {
                    //Throw in main  queue since it is UI refresh
                    strongSelf.delegate?.didLoadMoreEvents(
                        with:  indexPathToAdd
                    )
                    strongSelf.isLoadingMoreEvents = false
                }
                break
            case .failure(let error):
                strongSelf.isLoadingMoreEvents = false
                print(String(describing: error))
            }
        }
    }
    
    //MARK: - populate event list
    private func populateEventCellList(events : [Event], viewModels : [EventCellViewViewModel]) -> [EventCellViewViewModel]{
        var resp : [EventCellViewViewModel] = []
        for e in events where !viewModels.contains(where: {$0.event.id == e.id}) {
            let viewModel = EventCellViewViewModel(event: e, isMember: eventsMemberOf.contains(e))
            resp.append(viewModel)
        }
        return resp
    }
    
    private func makePreEventMember() {
        cellViewModels = cellViewModels.compactMap { vm in
            if (eventsMemberOf.contains(vm.event)) {
                return EventCellViewViewModel(event: vm.event, isMember: true)
            }
            return vm
        }
    }
}

// MARK: - Delegate work and Dequing
/// Create extension to conform to protocol
extension EventListViewModel : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = sections[section]
        switch sectionType {
        case .localEvents:
            return events.count
        case .memberEvents:
            return eventsMemberOf.count
        }
    }
    ///Deque and return single cell, using messagecellview
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = sections[indexPath.section]
        switch sectionType {
        case .localEvents:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: EventCellView.cellIdentifier,
                for: indexPath
            ) as? EventCellView else {
                fatalError("Unsupported cell")
            }
            cell.configure(with: cellViewModels[indexPath.row])
            return cell
        case .memberEvents:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: EventMemberCollectionViewCell.cellIdentifier,
                for: indexPath
            ) as? EventMemberCollectionViewCell else {
                fatalError("Unsupported cell")
            }
            cell.configure(with: eventsMemberOfCellViewModels[indexPath.row])
            return cell
        }
       
    }
    
    ///Get the size of the UI screenof the device
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds.width
        let width = bounds - 20
        return CGSize(width: width , height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let e = events[indexPath.row]
        if e.is_public || eventsMemberOf.contains(where: {$0.id == e.id}){
            delegate?.didSelectEvent(e)
        } else {
            delegate?.didSelectPrivateEvent(e)
        }
    }
    
    ///Render footer
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter,
            let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: FooterReusableLoaderView.identifier,
                for: indexPath
            ) as? FooterReusableLoaderView else {
                fatalError("Not Supported")
            }
        footer.startAnimating()
        return footer
    }
    ///Determin Footer size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard shouldShowLoadMore else {
            return .zero
        }
        
        return CGSize(width: collectionView.frame.width, height: 100)
    }
    
}

// MARK: Scroll View
extension EventListViewModel : UIScrollViewDelegate {
    //When user reaches bttm
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //Need to add a info to API response to see if there is more to query
        guard !shouldShowLoadMore, isLoadingMoreEvents else {
            return
        }
        //How much we scroll
        let offset = scrollView.contentOffset.y
        //total size of view with all things render
        //totalContentHeight = totalScrollViewFixedHeight + offset
        let totalContentHeight = scrollView.contentSize.height
        //size of screen
        let totalScrollViewFixedHeight = scrollView.frame.size.height
        //Not the spinner height is 100
        if (offset >= totalContentHeight - totalScrollViewFixedHeight - 120){
            fetchMoreEvents()
        }
    }
}
