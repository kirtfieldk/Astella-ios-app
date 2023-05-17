//
//  EventCreateMapViewCell.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/15/23.
//

import CoreLocation
import SwiftUI
import MapKit

protocol EventCreateMapViewCellDelegate : AnyObject {
    func submitLocationInfo(info : LocationInfoPost)
    func setUserCords(coords : CLLocationCoordinate2D)
}

final class EventCreateMapViewCell : UICollectionViewCell {
    static let cellIdentifier = "EventCreateMapViewCell"
    public weak var delegate : EventCreateMapViewCellDelegate?
    
    private var titleLable : UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private var pin : MKPointAnnotation?
    public var topLeftLat : Double?
    public var topLeftLon : Double?
    public var topRightLat : Double?
    public var topRightLon : Double?
    public var bottomRightLat : Double?
    public var bottomRightLon : Double?
    public var bottomLeftLat : Double?
    public var bottomLeftLon : Double?

    private let slider : UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0.001
        slider.value = 0.001
        slider.maximumValue = 0.01
        slider.isSelected = true
        slider.isUserInteractionEnabled = true
        slider.isEnabled = true
        slider.layer.setNeedsLayout()
        slider.layer.layoutIfNeeded()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.tintColor = .green
        slider.isContinuous = true
        return slider
    }()
    
    private let map: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    var locationManager: CLLocationManager?

    public func configuration(viewModel : EventCreateMapViewCellViewModel) {
        addSubviews(map, titleLable, slider)
        map.delegate = self
        addConstraint()
        slider.addTarget(self, action: #selector(updatePolySize), for: .valueChanged)
        UserLocationManager.shared.getUserLocation {[weak self] location in
            DispatchQueue.main.async {
                guard let strongself = self else {
                    return
                }
                strongself.addMapPin(with: location)
            }
        }
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLable.text = nil
        slider.value = slider.value
    }
    
    func addConstraint() {
        NSLayoutConstraint.activate([
            titleLable.topAnchor.constraint(equalTo: topAnchor),
            titleLable.leftAnchor.constraint(equalTo: leftAnchor),
            titleLable.rightAnchor.constraint(equalTo: rightAnchor),
            map.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 10),
            map.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
            map.rightAnchor.constraint(equalTo: rightAnchor, constant: 0),
            map.bottomAnchor.constraint(equalTo: bottomAnchor),
            slider.topAnchor.constraint(equalTo: titleLable.bottomAnchor, constant: 10),
            slider.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            slider.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.45),
            
        ])
    }
    
    func addMapPin(with location: CLLocation) {
        pin = MKPointAnnotation()
        pin?.coordinate = location.coordinate
        delegate?.setUserCords(coords: location.coordinate)
        map.setRegion(MKCoordinateRegion(center: location.coordinate,
                                                    span: MKCoordinateSpan(latitudeDelta: 0.05,
                                                                           longitudeDelta: 0.05)),
                                 animated: true)
        guard let pin = pin else {return}
        map.addAnnotation(pin)
        UserLocationManager.shared.resolveLocationName(with: location) {[weak self] locationName in
            DispatchQueue.main.async {
                guard let locationName = locationName else {return}
                self?.titleLable.text = locationName
            }
        }
    }
    
    @objc
    func updatePolySize(){
        guard let pin = pin, let city = titleLable.text  else {return}
        let locationInfo = LocationInfoPost(top_left_lat: pin.coordinate.latitude - Double(slider.value), top_left_lon: pin.coordinate.longitude + Double(slider.value), top_right_lat: pin.coordinate.latitude + Double(slider.value), top_right_lon: pin.coordinate.longitude + Double(slider.value), bottom_left_lat: pin.coordinate.latitude - Double(slider.value), bottom_left_lon: pin.coordinate.longitude - Double(slider.value), bottom_right_lat: pin.coordinate.latitude + Double(slider.value), bottom_right_lon: pin.coordinate.longitude - Double(slider.value),
                                            city: city)
        var cords = [
            CLLocationCoordinate2D(latitude: locationInfo.top_right_lat, longitude: locationInfo.top_right_lon),
            CLLocationCoordinate2D(latitude: locationInfo.bottom_right_lat, longitude: locationInfo.bottom_right_lon),
            CLLocationCoordinate2D(latitude: locationInfo.bottom_left_lat, longitude: locationInfo.bottom_left_lon),  CLLocationCoordinate2D(latitude: locationInfo.top_left_lat, longitude: locationInfo.top_left_lon)]
        let med = MKPolygon(coordinates: &cords, count: cords.count)
        
        map.removeOverlays(map.overlays)
        map.addOverlay(med)
        delegate?.submitLocationInfo(info: locationInfo)
    }
}

extension EventCreateMapViewCell : MKMapViewDelegate {
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
