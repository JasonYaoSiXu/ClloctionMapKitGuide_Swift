//
//  ViewController.swift
//  ClloctionMapKitGuide
//
//  Created by yaosixu on 2016/11/16.
//  Copyright © 2016年 Jason_Yao. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var latLabel: UILabel!
    @IBOutlet weak var logLabel: UILabel!
    @IBOutlet weak var floorLeavel: UILabel!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!

    var myLocation: CLLocationManager!
    var myRegion: CLBeaconRegion!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationService.default.startLocation()
        
//        myLocation = CLLocationManager()
//        myLocation.delegate = self
//        guard let uuid = UUID(uuidString: "6D810169-5797-4EF2-B141-554360C4086E") else {
//            return
//        }
//        myRegion = CLBeaconRegion(proximityUUID: uuid, identifier: "yaosixuBluetooth")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapButtonAction(_ sender: UIButton) {
    }
        
}

extension ViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        myLocation.startMonitoring(for: myRegion)
        myLocation.startRangingBeacons(in: myRegion)
        for region in myLocation.monitoredRegions {
            print("\(#function),region = \(region)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        myLocation.requestState(for: myRegion)
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        print("\(#function),\(state.rawValue)")
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        print("\(#function)")
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("\(#function),\(error.localizedDescription)")
    }
}
