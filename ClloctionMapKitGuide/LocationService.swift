//
//  LocationService.swift
//  ClloctionMapKitGuide
//
//  Created by yaosixu on 2016/11/16.
//  Copyright © 2016年 Jason_Yao. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

//6D810169-5797-4EF2-B141-554360C4086E
//yaosixuBluetooth

protocol LocationMessageDelegate {
    func locationMessage(lat: Double, log: Double, floor: Int?)
    func reciveBeaconRegion()
    //Optional
    func locationAddressMessage(street: String?, city: String?, country: String?)
}

//Optional
extension LocationMessageDelegate {
    func locationAddressMessage(street: String?, city: String?, country: String?) {
        print("\(#function)")
    }
}


class LocationService: NSObject {
    static let `default` = LocationService()
    var delegate: LocationMessageDelegate!
    private let geo = CLGeocoder()
    var circleRegion: CLCircularRegion!
    var clBeaconRegion: CLBeaconRegion!    
    
    let locationManager = CLLocationManager()
    
    ///获取定位权限
    func requestLocationService() {
        locationManager.requestAlwaysAuthorization()
    }
    
    ///开始定位
    func startLocation() {
        if !CLLocationManager.locationServicesEnabled() {
            return
        }
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways,.authorizedWhenInUse:
            locationManager.delegate = self
            locationManager.desiredAccuracy = 1
            locationManager.distanceFilter = 0.5
            locationManager.activityType = .fitness
            locationManager.allowsBackgroundLocationUpdates = true
            locationManager.startUpdatingLocation()
            print("***********************************************************")
        default:
            return
        }
    }
}

extension LocationService : CLLocationManagerDelegate {
    ///位置更新
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.last else {
//            locationManager.stopUpdatingLocation()
//            return
//        }
//        let floorLeveal = locations.first?.floor?.level
//        delegate.locationMessage(lat: location.coordinate.latitude, log: location.coordinate.longitude, floor: floorLeveal)
    }
}
