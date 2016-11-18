//
//  ViewController.swift
//  ClloctionMapKitGuide
//
//  Created by yaosixu on 2016/11/16.
//  Copyright © 2016年 Jason_Yao. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var latLabel: UILabel!
    @IBOutlet weak var logLabel: UILabel!
    @IBOutlet weak var floorLeavel: UILabel!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    //科技五路  34.216520000000003,108.886346
    //枫叶广场 34.225942000000003,108.901691
    
    let coordinate = CLLocationCoordinate2D(latitude: 34.216520000000003, longitude: 108.886346)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationService.default.delegate = self
        LocationService.default.startLocation()
        mapView.delegate = self
        configMapView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func tapButtonAction(_ sender: UIButton) {
//        LocationService.default.startLocation()
    }
    
    func configMapView() {
        let lookingAtCenter = CLLocationCoordinate2D(latitude: 34.225942000000003, longitude: 108.901691)
        let resultcoordinateRegion = MKCoordinateRegionMakeWithDistance(lookingAtCenter, 1000, 1000)
        let coordinateCrame = MKMapCamera(lookingAtCenter: lookingAtCenter, fromEyeCoordinate: coordinate, eyeAltitude: 20)
        mapView.camera = coordinateCrame
//        mapView.setRegion(resultcoordinateRegion, animated: true)
        mapView.showsUserLocation = true
        
        let pointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = coordinate
        mapView.addAnnotation(pointAnnotation)
    }
        
}


// Location service delegate
extension ViewController: LocationMessageDelegate {
    func orientationMessage(truthOrientation: String, magneticOrientation: String) {
        DispatchQueue.main.async { [unowned self] in
            self.latLabel.text = truthOrientation
            self.logLabel.text = magneticOrientation
        }
    }

    func locationMessage(lat: Double, log: Double, floor: Int?) {
        DispatchQueue.main.async { [unowned self] in
            self.latLabel.text = "\(lat)"
            self.logLabel.text = "\(log)"
            self.floorLeavel.text = "\(floor)"
        }
    }
    
    func locationAddressMessage(street: String?, city: String?, country: String?) {
        DispatchQueue.main.async { [unowned self] in
            self.streetLabel.text = street
            self.cityLabel.text = city
            self.countryLabel.text = country
        }
    }
    
    func reciveBeaconRegion() {
         self.view.backgroundColor = UIColor.blue
        let time: DispatchTime = DispatchTime.now() + 3
        DispatchQueue.main.asyncAfter(deadline: time, execute: { [unowned self] in
            self.view.backgroundColor = UIColor.red
        })
    }
}

// MKMapView Delegate
extension ViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let customPoAnnotation = MKAnnotationView()
        customPoAnnotation.image = UIImage(named: "发现-选中")
        if annotation.coordinate.latitude == coordinate.latitude && annotation.coordinate.longitude == coordinate.longitude {
            return customPoAnnotation
        }
        return nil
    }
}
