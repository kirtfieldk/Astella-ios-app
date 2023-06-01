//
//  EventOverviewCollectionViewCell.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/30/23.
//

import CoreLocation
import SwiftUI
import MapKit

class EventOverviewCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "EventOverviewCollectionViewCell"
    private var viewModel : EventOverviewCollectionViewModel?
    private var pin : MKPointAnnotation?
    private let eventName : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 25, weight: .black)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let textField : UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = .systemFont(ofSize: 14, weight: .medium)
        field.textColor = .white
        return field
    }()
    
    private let map: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 55 / 255, green: 140 / 255, blue: 118 / 255, alpha: 0.9)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configuration(with viewModel : EventOverviewCollectionViewModel) {
        self.viewModel = viewModel
        eventName.text = viewModel.event.name
        textField.text = viewModel.event.description
        map.isZoomEnabled = false
        map.isPitchEnabled = false
        map.isRotateEnabled = false
        map.isScrollEnabled = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 5, height: 5)
        layer.shadowOpacity = 0.2
        addSubviews(eventName, textField, map)
        map.delegate = self
        addUserPin()
        addEventPoly()
        addConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        map.removeOverlays(map.overlays)
    }
    
    //MARK: - Add map and User Pin
    private func addUserPin() {
        UserLocationManager.shared.getUserLocation {[weak self] location in
            DispatchQueue.main.async {
                guard let strongself = self else {
                    return
                }
                strongself.addMapPin(with: location)
            }
        }
    }
    
    private func addEventPoly() {
        guard let locationInfo = viewModel?.event.location_info else {return}
        var cords = [
            CLLocationCoordinate2D(latitude: locationInfo.top_right_lat, longitude: locationInfo.top_right_lon),
            CLLocationCoordinate2D(latitude: locationInfo.bottom_right_lat, longitude: locationInfo.bottom_right_lon),
            CLLocationCoordinate2D(latitude: locationInfo.bottom_left_lat, longitude: locationInfo.bottom_left_lon),  CLLocationCoordinate2D(latitude: locationInfo.top_left_lat, longitude: locationInfo.top_left_lon)]
        let med = MKPolygon(coordinates: &cords, count: cords.count)
        
        map.addOverlay(med)
    }
    
    func addMapPin(with location: CLLocation) {
        pin = MKPointAnnotation()
        pin?.coordinate = location.coordinate
        map.setRegion(MKCoordinateRegion(center: location.coordinate,
                                                    span: MKCoordinateSpan(latitudeDelta: 0.025,
                                                                           longitudeDelta: 0.025)),
                                 animated: true)
        guard let pin = pin else {return}
        map.addAnnotation(pin)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            eventName.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            eventName.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.topAnchor.constraint(equalTo: eventName.bottomAnchor),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            map.trailingAnchor.constraint(equalTo: trailingAnchor),
            map.bottomAnchor.constraint(equalTo: bottomAnchor),
            map.heightAnchor.constraint(equalToConstant: 150),
            map.leadingAnchor.constraint(equalTo: leadingAnchor),


        ])
    }
}

extension EventOverviewCollectionViewCell : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolygon {
            let renderer = MKPolygonRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.gray
            renderer.lineWidth = 3
            renderer.fillColor = .gray
            renderer.alpha = 0.3
            return renderer
        }
        
        return MKOverlayRenderer()
    }
}
