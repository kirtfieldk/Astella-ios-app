//
//  EventCreateMapViewCell.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/15/23.
//

import CoreLocation
import SwiftUI
import MapKit

final class EventCreateMapViewCell : UICollectionViewCell {
    static let cellIdentifier = "EventCreateMapViewCell"
    private var titleLable : UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private var pin : MKPointAnnotation?

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
        slider.addTarget(self, action: #selector(updatePolySize), for: .valueChanged)
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
        UserLocationManager.shared.getUserLocation {[weak self] location in
            DispatchQueue.main.async {
                guard let strongself = self else {
                    return
                }
                strongself.addMapPin(with: location)
            }
        }
        
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
        guard let pin = pin else {return}
        var cords = [
            CLLocationCoordinate2D(latitude: pin.coordinate.latitude + Double(slider.value), longitude: pin.coordinate.longitude + Double(slider.value)),
        CLLocationCoordinate2D(latitude: pin.coordinate.latitude + Double(slider.value), longitude: pin.coordinate.longitude - Double(slider.value)),
        CLLocationCoordinate2D(latitude: pin.coordinate.latitude - Double(slider.value), longitude: pin.coordinate.longitude - Double(slider.value)),  CLLocationCoordinate2D(latitude: pin.coordinate.latitude - Double(slider.value), longitude: pin.coordinate.longitude + Double(slider.value))]
        let med = MKPolygon(coordinates: &cords, count: cords.count)
        map.removeOverlays(map.overlays)

        map.addOverlay(med)
        
    }
}

extension EventCreateMapViewCell : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolygon {
            let renderer = MKPolygonRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.gray
            renderer.lineWidth = 3
            renderer.fillColor = .gray
            renderer.alpha = 0.5
            return renderer
        }
        
        return MKOverlayRenderer()
    }
}
