//
//  ViewController.swift
//  ClloctionMapKitGuide
//
//  Created by yaosixu on 2016/11/16.
//  Copyright © 2016年 Jason_Yao. All rights reserved.
//

import UIKit
import MapKit
import UserNotifications

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var latLabelDetail: UILabel!
    @IBOutlet weak var logLabelDetail: UILabel!
    @IBOutlet weak var streetLabelDetail: UILabel!
    
    struct AlertControllerMessage {
        let title: String!
        let body: String!
        init(title: String, body: String) {
            self.title = title
            self.body = body
        }
    }
    var alertControllerMessageArray: [AlertControllerMessage] = []
    var isPresentingVC = true
    var userLocation: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var mkCircle = MKCircle()

    var preDeation: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userNotificationCenter = UNUserNotificationCenter.current()
        userNotificationCenter.delegate = self
        LocationService.default.delegate = self
        configMapView()
        addNotification()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapLocationButton(_ sender: UIButton) {
        LocationService.default.startLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if alertControllerMessageArray.count > 0 {
            let firstAlertControllerMessage: AlertControllerMessage! = alertControllerMessageArray.first
            createAlertView(title: firstAlertControllerMessage.title, message: firstAlertControllerMessage.body)
        } else {
            isPresentingVC = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if alertControllerMessageArray.count > 0 {
            alertControllerMessageArray.remove(at: 0)
        }
    }
    
    func configMapView() {
        mapView.delegate = self
        mapView.userTrackingMode = .followWithHeading
        mapView.isZoomEnabled = false
        mapView.isScrollEnabled = false
    }
    
    func addNotification() {
        let userNotificationCenter = UNUserNotificationCenter.current()
        
        var userNotificationContent = UNMutableNotificationContent()
        userNotificationContent.categoryIdentifier = "userEnterCompany"
        userNotificationContent.title = "进入公司"
        userNotificationContent.body = "进入公司"
        var location = CLLocationCoordinate2D(latitude: 34.2274859637402, longitude: 108.897247123795)
        var clRegion = CLCircularRegion(center: location, radius: 100, identifier: "userEnterCompany")
        clRegion.notifyOnExit = true
        clRegion.notifyOnEntry = true
        var userNotificationTrigger = UNLocationNotificationTrigger(region: clRegion, repeats: false)
        var requestNotifier = UNNotificationRequest(identifier: "userEnterCompany", content: userNotificationContent, trigger: userNotificationTrigger)
        userNotificationCenter.add(requestNotifier, withCompletionHandler: {
            print("\($0?.localizedDescription)")
        })
        
        userNotificationContent = UNMutableNotificationContent()
        userNotificationContent.categoryIdentifier = "userEnterHome"
        userNotificationContent.title = "回家"
        userNotificationContent.body = "回家"
        location = CLLocationCoordinate2D(latitude: 34.2165240000, longitude: 108.8880780000)
        clRegion = CLCircularRegion(center: location, radius: 100, identifier: "userEnterHome")
        clRegion.notifyOnExit = true
        clRegion.notifyOnEntry = true
        userNotificationTrigger = UNLocationNotificationTrigger(region: clRegion, repeats: false)
        requestNotifier = UNNotificationRequest(identifier: "userEnterHome", content: userNotificationContent, trigger: userNotificationTrigger)
        userNotificationCenter.add(requestNotifier, withCompletionHandler: {
            print("\($0?.localizedDescription)")
        })
    }
}

// LocationMessageDelegate
extension ViewController : LocationMessageDelegate {
    
    func locationMessage(locationCoord: CLLocationCoordinate2D) {
        DispatchQueue.main.async { [unowned self] in
            self.latLabelDetail.text = "\(locationCoord.latitude)"
            self.logLabelDetail.text = "\(locationCoord.longitude)"
        }
    }
    
    func locationAddressMessage(street: String?) {
        DispatchQueue.main.async { [unowned self] in
            self.streetLabelDetail.text = street
        }
    }
    
}

//UNUserNotificationCenterDelegate
extension ViewController : UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        UIApplication.shared.applicationIconBadgeNumber -= 1
        let alertControllerMessage = AlertControllerMessage(title: notification.request.identifier, body: notification.request.content.categoryIdentifier)
        alertControllerMessageArray.append(alertControllerMessage)
        if isPresentingVC {
            let firstAlertControllerMessage: AlertControllerMessage! = alertControllerMessageArray.first
            createAlertView(title: firstAlertControllerMessage.title, message: firstAlertControllerMessage.body)
            isPresentingVC = false
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        UIApplication.shared.applicationIconBadgeNumber -= 1
        let alertControllerMessage = AlertControllerMessage(title: response.notification.request.identifier, body: response.actionIdentifier)
        alertControllerMessageArray.append(alertControllerMessage)
        if isPresentingVC {
            let firstAlertControllerMessage: AlertControllerMessage! = alertControllerMessageArray.first
            createAlertView(title: firstAlertControllerMessage.title, message: firstAlertControllerMessage.body)
            isPresentingVC = false
        }
    }
    
    func createAlertView(title: String, message: String) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertViewCancleAction = UIAlertAction(title: "取消", style: .destructive, handler: { [unowned self] _ in
            alertViewController.dismiss(animated: true, completion: nil)
            let afterTime = DispatchTime.now() + 1
            if self.alertControllerMessageArray.count > 0 {
                self.alertControllerMessageArray.remove(at: 0)
                if self.alertControllerMessageArray.count == 0 {
                    self.isPresentingVC = true
                }
            }
            DispatchQueue.main.asyncAfter(deadline: afterTime, execute: { [unowned self] in
                if self.alertControllerMessageArray.count > 0 {
                    let firstAlertControllerMessage: AlertControllerMessage! = self.alertControllerMessageArray.first
                    self.createAlertView(title: firstAlertControllerMessage.title, message: firstAlertControllerMessage.body)
                }
            })
        })
        let alertViewDetailAction = UIAlertAction(title: "详情", style: .default, handler: { [unowned self] _ in
            self.navigationController?.pushViewController(ViewControllerA(), animated: true)
        })
        alertViewController.addAction(alertViewCancleAction)
        alertViewController.addAction(alertViewDetailAction)
        /**
            viewController present一个UIViewController，会调用disappear的相关方法
            但viewController present一个UIAlertController(继承自UIViewController)却不会调用disappear的相关方法
         */
        self.present(alertViewController, animated: true, completion: nil)
    }
    
}

extension ViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        mapView.remove(mkCircle)
        mkCircle = MKCircle(center: userLocation.coordinate, radius: 100)
        mapView.add(mkCircle)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay.isKind(of: MKCircle.self) {
            let mkCircle = MKCircleRenderer(circle: overlay as! MKCircle)
            mkCircle.fillColor = UIColor.cyan
            mkCircle.alpha = 0.3
            return mkCircle
        } else {
            return MKOverlayRenderer()
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.coordinate == mapView.userLocation.coordinate {
            let mkAnnotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            mkAnnotationView.image = UIImage(named: "find_venue_place")
            return mkAnnotationView
        } else {
            return nil
        }
    }
}


class Overlay: NSObject, MKOverlay {
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var boundingMapRect: MKMapRect = MKMapRect()
}

func ==(left: CLLocationCoordinate2D, right: CLLocationCoordinate2D ) -> Bool {
    if left.latitude == right.latitude && left.longitude == right.longitude {
        return true
    } else {
        return false
    }
}

