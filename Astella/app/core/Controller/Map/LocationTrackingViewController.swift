//
//  LocationTrackingViewController.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/2/23.
//

import CoreLocation
import SwiftUI
import MapKit

class LocationTrackingViewController : UIViewController {    // Step 2: Declare a CLLocationManager object at the ViewController level to prevent the instance from being released by system.
    var locationManager: CLLocationManager?
    private let map: MKMapView = {
        let map = MKMapView()
        return map
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Map"
        view.addSubview(map)
        UserLocationManager.shared.getUserLocation {[weak self] location in
            DispatchQueue.main.async {
                guard let strongself = self else {
                    return
                }
                strongself.addMapPin(with: location)
            }
            
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        map.frame = view.bounds
    }
    
    func addMapPin(with location: CLLocation) {
        let pin = MKPointAnnotation()
        pin.coordinate = location.coordinate
        map.setRegion(MKCoordinateRegion(center: location.coordinate,
                                                    span: MKCoordinateSpan(latitudeDelta: 0.7,
                                                                           longitudeDelta: 0.7)),
                                 animated: true)
        map.addAnnotation(pin)
        UserLocationManager.shared.resolveLocationName(with: location) {[weak self] locationName in
            self?.title = locationName
        }
    }
    
}


