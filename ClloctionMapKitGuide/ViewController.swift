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
    var presentViewController: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let userNotificationCenter = UNUserNotificationCenter.current()
//        userNotificationCenter.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapLocationButton(_ sender: UIButton) {
//        LocationService.default.startLocation()
        let a = ViewControllerA()
        let b = ViewControllerB()
        let c = ViewControllerC()
        
        self.present(a, animated: true, completion: nil)
        self.presentedViewController?.present(b, animated: true, completion: nil)
        self.presentedViewController?.presentedViewController?.present(c, animated: true, completion: nil)
        
    }
    
}

// LocationMessageDelegate
extension ViewController : LocationMessageDelegate {
    
    func locationMessage(locationCoord: CLLocationCoordinate2D) {
        
    }
    
    func reciveBeaconRegion() {
        
    }
    
    func locationAddressMessage(street: String?) {
        
    }
    
}

//UNUserNotificationCenterDelegate
extension ViewController : UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        UIApplication.shared.applicationIconBadgeNumber -= 1
//        createAlertView(title: "\(notification.request.identifier)", message: "\(notification.request.content.categoryIdentifier)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        UIApplication.shared.applicationIconBadgeNumber -= 1
//        createAlertView(title: response.notification.request.identifier, message: "\(response.notification.request.content.categoryIdentifier),\(response.actionIdentifier)")
    }
    
    func createAlertView(title: String, message: String) {
//        print("\(#function)")
//        let alertView = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "取消")
//        alertView.show()
//        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        let alertViewAction = UIAlertAction(title: "取消", style: .destructive, handler: { _ in
//            alertViewController.view.removeFromSuperview()
//        })
//        alertViewController.addAction(alertViewAction)
//        self.show(alertViewController, sender: nil)
    }
    
}

//MKMapViewDelegate
extension ViewController : MKMapViewDelegate {
    
}
