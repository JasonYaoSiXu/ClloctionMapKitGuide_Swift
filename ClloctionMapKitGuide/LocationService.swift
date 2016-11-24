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
import UserNotifications

//枫叶广场：34.2259420000,108.9016910000
//科技五路：34.2165240000,108.8880780000

protocol LocationMessageDelegate {
    ///位置坐标
    func locationMessage(locationCoord: CLLocationCoordinate2D)
    ///位置信息
    func locationAddressMessage(street: String?)
}


class LocationService: NSObject {
    static let `default` = LocationService()
    var delegate: LocationMessageDelegate!
    let locationManager = CLLocationManager()
    
    ///区域监视
    var companyGeographicalMonitor: CLCircularRegion!
    var homeGeographicalMonitor: CLCircularRegion!
    ///Beacon 监视
    var beaconMonitor: CLBeaconRegion!
    
    ///请求定位权限
    func requestLocationService() {
        locationManager.requestAlwaysAuthorization()
    }
    
    ///开始定位
    func startLocation() {
        // 查看定位服务有没有打开
        if !CLLocationManager.locationServicesEnabled() {
            return
        }
        
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            locationManager.delegate = self
            //允许后台刷新
            locationManager.allowsBackgroundLocationUpdates = true
            //后台活动类型
            locationManager.activityType = .fitness
            //隔多少米定位一次
            locationManager.distanceFilter = 10
            //定位精度
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            //开始定位
            locationManager.startUpdatingLocation()
            /**
             设置监听信息 位置监听发送通知有两种，一种是下面要写的，另一种是本地通知有一种类型是用来监听地理位置改变的
             需要注意一点locationManager最多绑定20个CLRegion,多于20个的话会报错未能连接成功还是什么，忘了错误码应该是5
             */
            configMonitor()
        default:
            return
        }
    }
    
    //设置监听信息
    func configMonitor() {
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            var cllocationCoordinate = CLLocationCoordinate2D(latitude: 34.2274859637402, longitude: 108.897247123795)
            var radius: Double = 300
            
            if radius > locationManager.maximumRegionMonitoringDistance {
                radius = locationManager.maximumRegionMonitoringDistance
            }
            
            companyGeographicalMonitor = CLCircularRegion(center: cllocationCoordinate, radius: radius, identifier: "company")
            locationManager.startMonitoring(for: companyGeographicalMonitor)
            
            cllocationCoordinate = CLLocationCoordinate2D(latitude: 34.2165240000, longitude: 108.8880780000)
            homeGeographicalMonitor = CLCircularRegion(center: cllocationCoordinate, radius: radius, identifier: "home")
            locationManager.startMonitoring(for: homeGeographicalMonitor)
        }
        
        if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) && CLLocationManager.isRangingAvailable() {
            guard let uuid = UUID(uuidString: "98E5AC56-D7C4-4F69-9708-393AE4166DC0") else {
                return
            }
            beaconMonitor = CLBeaconRegion(proximityUUID: uuid, major: 0, minor: 0, identifier: "beacon")
            locationManager.startMonitoring(for: beaconMonitor)
            locationManager.startRangingBeacons(in: beaconMonitor)
        }
    }
    
}

// CLLocationManagerDelegate
extension LocationService : CLLocationManagerDelegate {
    
    //授权状态变更
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("授权状态变更")
    }
    
    //位置更新
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else {
            return
        }
        self.delegate.locationMessage(locationCoord: lastLocation.coordinate)
        transformCoordinateToAddress(location: lastLocation)
    }
    
    //位置更新失败
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("位置更新失败\(error.localizedDescription)")
    }
    
    //用户进入一个CLRegion
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("用户进入一个CLRegion")
        if region.identifier == "company" {
            createUserNotification(contentIdentifier: CateGeographicalIdentifier.categorEnterGeographical.rawValue, title: "Come Company", body: "You had come in Company")
        } else if region.identifier == "home" {
            createUserNotification(contentIdentifier: CateGeographicalIdentifier.categorEnterGeographical.rawValue, title: "Come Home", body: "You had come in Home")
        } else if region.identifier == "beacon" {
            createUserNotification(contentIdentifier: CateGeographicalIdentifier.categorEnterBeacon.rawValue, title: "Come Beacons", body: "You had come is Beacons Range")
        }
    }
    
    //用户离开一个CLRegion
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("用户离开一个CLRegion")
        if region.identifier == "company" {
            createUserNotification(contentIdentifier: CateGeographicalIdentifier.categorExitGeographical.rawValue, title: "Leave Company", body: "You had leave Company")
        } else if region.identifier == "home" {
            createUserNotification(contentIdentifier: CateGeographicalIdentifier.categorExitGeographical.rawValue, title: "Leave Home", body: "You had leave Home")
        } else if region.identifier == "beacon" {
            createUserNotification(contentIdentifier: CateGeographicalIdentifier.categorExitBeacon.rawValue, title: "Leave Beacons", body: "You had leave Beacons Range")
        }
    }
    
    //开始监听CLRegion
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("开始监听\(region.identifier)")
        locationManager.requestState(for: region)
    }
    
    //使用startRangingBeacons会调用该方法,beacons按照设备离用户的距离进行排序，从近到远
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        print("\(#function),beacons.count=\(beacons.count),region's Identifier=\(region.identifier)")
    }
    
    //使用requestState会调用该方法，当用户处于一个geographical或着beacon范围内不会调用 didEnterRegion或者didExitRegion方法
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        print("region'state\(state.rawValue),region'identifier=\(region.identifier)")
        if state == .inside {
            let title = "You inside \(region.identifier)"
            let body = "you inside \(region.identifier)"
            createUserNotification(contentIdentifier: transformInsideCateGeographicalIdentifier(formString: region.identifier), title: title, body: body)
        } else if state == .outside {
            let title = "You outside \(region.identifier)"
            let body = "you outside \(region.identifier)"
            createUserNotification(contentIdentifier: transformOutsideCateGeographicalIdentifier(formString: region.identifier), title: title, body: body)
        }
    }
    
    //监听CLRegion出错
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("监听CLRegion出错,region.identifier=\(region?.identifier),errorInfo=\(error.localizedDescription)")
    }
    
    //监听一个CLBeaconRegion出错
    func locationManager(_ manager: CLLocationManager, rangingBeaconsDidFailFor region: CLBeaconRegion, withError error: Error) {
        //kCLErrorDomain = 16 蓝牙没有开启
        print("监听一个CLBeaconRegion出错,region.identifier=\(region.identifier),errorInfo=\(error.localizedDescription)")
    }
}

//创建通知
extension LocationService {
    
    func createUserNotification(contentIdentifier: String, title: String, body: String) {
        let userNotificationContent = UNMutableNotificationContent()
        userNotificationContent.categoryIdentifier = contentIdentifier
        userNotificationContent.title = title
        userNotificationContent.body = body
        UIApplication.shared.applicationIconBadgeNumber += 1
        userNotificationContent.badge = NSNumber(integerLiteral: UIApplication.shared.applicationIconBadgeNumber)
        
        let userNotificationRequest = UNNotificationRequest(identifier: contentIdentifier, content: userNotificationContent, trigger: nil)
        let userNotificationCenter = UNUserNotificationCenter.current()
        userNotificationCenter.add(userNotificationRequest, withCompletionHandler: {
            print("\($0?.localizedDescription)")
        })
    }
    
    
    func transformInsideCateGeographicalIdentifier(formString: String) -> String {
        switch formString {
        case "company":
            return CateGeographicalIdentifier.userInsideCompany.rawValue
        case "home":
            return CateGeographicalIdentifier.userInsideHome.rawValue
        default:
            return CateGeographicalIdentifier.userInsideBeacon.rawValue
        }
    }
    
    func transformOutsideCateGeographicalIdentifier(formString: String) -> String {
        switch formString {
        case "company":
            return CateGeographicalIdentifier.userOutsideCompany.rawValue
        case "home":
            return CateGeographicalIdentifier.userOutsideHome.rawValue
        default:
            return CateGeographicalIdentifier.userOutsideBeacon.rawValue
        }
    }
 
    //将地理信息从经纬度转成相应的地理位置名称
    func transformCoordinateToAddress(location: CLLocation) {
        let geoCoder = CLGeocoder()
        var streetName: String = ""
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: {
            guard let placeMark = $0.0 else {
                return
            }
            streetName = placeMark.first?.thoroughfare ?? ""
            self.delegate.locationAddressMessage(street: streetName)
        })
    }
    
}


