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

var circleRegion: CLCircularRegion!
//6D810169-5797-4EF2-B141-554360C4086E

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


class LocationService: NSObject,CLLocationManagerDelegate {
    static let `default` = LocationService()
    var delegate: LocationMessageDelegate!
    private let geo = CLGeocoder()
    
    
    let locationManager = CLLocationManager()
    
    func requestLocationService() {
        locationManager.requestAlwaysAuthorization()
//        registerMotion()
    }
    
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
            registerMotion()
//            guard let uuid: UUID = UUID(uuidString: "6D810169-5797-4EF2-B141-554360C4086E") else {
//                return
//            }
//            let clBeaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: "yaosixuBluetooth")
//            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
//                locationManager.startMonitoring(for: clBeaconRegion)
//                locationManager.requestState(for: clBeaconRegion)
//                print("isMonitoringAvailable is true")
//            } else {
//                print("isMonitoringAvailable is false")
//            }
        default:
            return
        }
    }
    
    ///注册位置监听
    func registerMotion() {
        print("\(#function)")
        var radius = 300.0
        //34.225942000000003,108.901691
        let location = CLLocationCoordinate2D(latitude: 34.2274574207637, longitude: 108.897323768781)
        circleRegion = CLCircularRegion(center: location, radius: radius, identifier: "roadFive")
        print("\(locationManager.maximumRegionMonitoringDistance)")
        if radius > locationManager.maximumRegionMonitoringDistance {
            radius = locationManager.maximumRegionMonitoringDistance
        }
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            locationManager.startMonitoring(for: circleRegion)
            locationManager.requestState(for: circleRegion)
            print("++++++++")
        } else {
            print("-----------")
        }
    }
    
    func geoCoder(location: CLLocation) {
        geo.reverseGeocodeLocation(location, completionHandler: { [unowned self] in
            if let placeMark = $0.0 {
                let street: String? = placeMark.last?.thoroughfare
                let city: String? = placeMark.last?.locality
                let country: String? = placeMark.last?.country
                self.delegate.locationAddressMessage(street: street, city: city, country: country)
            }
        })
    }
    
    //位置更新
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            locationManager.stopUpdatingLocation()
            return
        }
        let floorLeveal = locations.first?.floor?.level
        geoCoder(location: location)
        delegate.locationMessage(lat: location.coordinate.latitude, log: location.coordinate.longitude, floor: floorLeveal)
    }
    
    //朝向 0朝北
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
    }
    
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        print("\(#function),region's Identifier = \(region.identifier)")
        if  state == .inside && region.identifier == "roadFive" {
            guard let url = URL(string: "tel://\(15877347757)") else {
                return
            }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            
        }
    }
    
    ///用户进入一个地区
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region.identifier == "roadFive" {
            guard let url = URL(string: "tel://\(15877347757)") else {
                return
            }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            
        }
    }
    
    ///用户离开一个地区
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region.identifier == "roadFive" {
            guard let url = URL(string: "tel://\(15877347757)") else {
                return
            }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("\(#function)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("\(#function)")
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        print("\(#function)")
        delegate.reciveBeaconRegion()
        guard let firstBeacon = beacons.first else {
            return
        }
        print("distanse = \(firstBeacon.proximity)")
    }
    
}
