//
//  UserLocationManager.swift
//  Astella
//
//  Created by Keith Kirtfield on 4/28/23.
//

import Foundation
import CoreLocation

class UserLocationManager : NSObject, CLLocationManagerDelegate {
    static let shared = UserLocationManager()
    let manager = CLLocationManager()
    var completion : ((CLLocation) -> Void)?
    public func getUserLocation(completion: @escaping ((CLLocation) -> Void)) {
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        completion?(location)
        manager.stopUpdatingLocation()
    }
    
    //If not able to reverse geocode, pass back nil
    public func resolveLocationName(with location : CLLocation, completion: @escaping(String?) -> Void) {
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location, preferredLocale: .current) {
            placemarks, error in
            guard let place = placemarks?.first, error == nil else {
                completion(nil)
                return
            }
            print(place)
            var name = ""
            if let locality = place.locality {
                name += locality
            }
            completion(name)
        }
    }
    
    
}
