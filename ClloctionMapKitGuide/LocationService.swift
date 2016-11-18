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
    
    ///开始定位
    func startLocation() {
        locationAction()
//        if !CLLocationManager.locationServicesEnabled() {
//            return
//        }
//        switch CLLocationManager.authorizationStatus() {
//        case .authorizedAlways:
//            //uuid AE6C1280-0BEF-4FF8-AAD1-7495397FF826
//            guard let uuid = UUID(uuidString: "AE6C1280-0BEF-4FF8-AAD1-7495397FF826") else {
//                locationAction()
//                return
//            }
//            beaconMonitor = CLBeaconRegion(proximityUUID: uuid, major: 1, minor: 1, identifier: "yaosixu")
//            locationManager.startMonitoring(for: beaconMonitor)
//            if CLLocationManager.isRangingAvailable() {
//                locationManager.startRangingBeacons(in: beaconMonitor)
//                print("CLLocationManager Ranging is available")
//            } else {
//                print("CLLocationManager Ranging is unavailable")
//            }
//            locationAction()
//        case .authorizedWhenInUse:
//            locationAction()
//        default:
//            return
//        }
    }
    
    ///定位
    func locationAction() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = 1
        locationManager.distanceFilter = 0.5
        locationManager.activityType = .fitness
//        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.startUpdatingLocation()
//        getDeviceOrientation()
    }
    
    ///获取设备朝向
    /*
        方向包括两种：地磁北极，和地理北极。如果想获取地理北极就需要打开定位服务.
     */
    func getDeviceOrientation() {
        ///判断方向是否可用
        if CLLocationManager.headingAvailable() {
            locationManager.startUpdatingHeading()
            print("heading is available")
        } else{
            print("heading is unAvailable")
        }
        
        let view = MKPinAnnotationView()
        let result = view.canShowCallout
    }
}

extension LocationService : CLLocationManagerDelegate {
    ///位置更新
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else {
            return
        }
        delegate.locationMessage(lat: currentLocation.coordinate.latitude, log: currentLocation.coordinate.longitude, floor: 12)
    }
    
    
    ///方向信息
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        if newHeading.headingAccuracy < 0 {
            return
        }
        print("\(newHeading.trueHeading),\(newHeading.magneticHeading)")
        let resultOrientation = transfromLocationDataToLocationString(trueHeading: newHeading.trueHeading, mangneticHeading: newHeading.magneticHeading)
        delegate.orientationMessage(truthOrientation: resultOrientation.0, magneticOrientation: resultOrientation.1)
    }
    
//    ///进入一个监视区域
//    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
//        print("\(#function),\(region.identifier)")
//    }
//    
//    ///离开一个监视区域
//    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
//        print("\(#function),\(region.identifier)")
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
//        print("\(#function),\(beacons.count),\(region.proximityUUID),\(region.identifier)")
//    }
//    
//    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
//        print("\(#function),\(region?.identifier),\(error.localizedDescription)")
//    }
//    
//    func locationManager(_ manager: CLLocationManager, rangingBeaconsDidFailFor region: CLBeaconRegion, withError error: Error) {
//        print("\(#function),\(region.proximityUUID),\(region.identifier),\(error.localizedDescription)")
//    }
}

///将地理信息转为文字
extension LocationService {
    
    ///接收真实方位和地磁方位，返回位置描述
    func transfromLocationDataToLocationString(trueHeading: Double = 0.0, mangneticHeading: Double = 0.0) -> (String,String) {
        var trueHeadingStr: String = ""
        var mangneticHeadingStr: String = ""
        trueHeadingStr = turthOrientation(angle: trueHeading)
        mangneticHeadingStr = turthOrientation(angle: mangneticHeading)
        return (trueHeadingStr, mangneticHeadingStr)
    }
    
    ///返回大方向，如东、南、西、北
    func turthOrientation(angle: Double) -> String {
        let orientationAngle = angle / 90.0
        if orientationAngle == 0 {
            return "北"
        } else if orientationAngle == 1 {
            return "东"
        } else if orientationAngle == 2 {
            return "南"
        } else if orientationAngle == 3 {
            return "西"
        }
        
        switch angle  {
        case 0...45:
            return "北偏东"
        case 315.01...360:
            return "北偏西"
        case 45.01...90:
            return "东偏北"
        case 90.01...135:
            return "东偏南"
        case 135.01...180.0:
            return "南偏东"
        case  180.01...225:
            return "南偏西"
        case 225.0...270:
            return "西偏南"
        case 270.01...315:
            return "西偏北"
        default:
            return "未知"
        }
    }
    
}

