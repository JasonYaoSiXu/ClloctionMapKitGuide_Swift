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

protocol LocationMessageDelegate {
    func locationMessage(lat: Double, log: Double, floor: Int?)
    func reciveBeaconRegion()
    func locationAddressMessage(street: String?, city: String?, country: String?)
    func orientationMessage(truthOrientation: String, magneticOrientation: String)
}


class LocationService: NSObject {
    static let `default` = LocationService()
    var delegate: LocationMessageDelegate!
    let locationManager = CLLocationManager()
    
    ///区域监视
    var geographicalMonitor: CLCircularRegion!
    ///Beacon 监视
    var beaconMonitor: CLBeaconRegion!
    
    ///请求定位权限
    func requestLocationService() {
        locationManager.requestAlwaysAuthorization()
    }
    
}
