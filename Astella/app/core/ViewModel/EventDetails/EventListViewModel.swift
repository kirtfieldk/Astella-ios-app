//
//  EventListViewModel.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/1/23.
//

import UIKit

protocol EventListViewModelDelegate : AnyObject{
    func didLoadInitEvents()
    func didSelectEvent(_ event : Event)
    func didLoadMoreEvents(with newIndexPath: [IndexPath])
}

// MARK: - Main Class Impl
final class EventListViewModel : NSObject {
    private var events : [Event] = []{
        didSet {
            for e in events where !cellViewModels.contains(where: {$0.event.id == e.id}){
                let viewModel = EventCellViewViewModel(event: e)
                cellViewModels.append(viewModel)
            }
        }
    }
    
    private var cellViewModels : [EventCellViewViewModel] = []
    private var info : InfoResponse?
    public weak var delegate : EventListViewModelDelegate?
    private var isLoadingMoreEvents  : Bool = false
    
    
    override init() {
        
    }
    
    func fetchEvents(tmp : [URLQueryItem], firstFetch : Bool) {
        print("Here Fetch Events")
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
    
    private func buildRequest(queryItems : [URLQueryItem], cityName : String) -> RequestService {
        return RequestService(
            urlIds: AstellaUrlIds.emptyUrlIds,
            endpoint: AstellaEndpoints.GET_EVENT_BY_CITY.rawValue,
            httpMethod: "POST",
            httpBody: CityBody(city: cityName),
            queryParameters: queryItems
        )
    }
    
    private func executeInit(requestService : RequestService) {
        AstellaService.shared.execute(requestService, expecting: EventsByCityResponse.self)
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
    
    private func executeFetchMore(requestService : RequestService) {
        AstellaService.shared.execute(requestService, expecting: EventsByCityResponse.self)
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
                print(indexPathToAdd)
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
}

// MARK: - Delegate work and Dequing
/// Create extension to conform to protocol
extension EventListViewModel : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    ///Deque and return single cell, using messagecellview
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: EventCellView.cellIdentifier,
            for: indexPath
        ) as? EventCellView else {
            fatalError("Unsupported cell")
        }
        cell.configuration(with: cellViewModels[indexPath.row])
        
        return cell
    }
    
    ///Get the size of the UI screenof the device
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds.width
        let width = bounds - 20
        
        return CGSize(width: width , height: ( UIScreen.main.bounds.height * 0.08 ))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let e = events[indexPath.row]
        delegate?.didSelectEvent(e)
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
