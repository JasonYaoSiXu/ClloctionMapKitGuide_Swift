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

    //科技五路  34.216520000000003,108.886346
    //枫叶广场 34.225942000000003,108.901691
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationService.default.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func tapButtonAction(_ sender: UIButton) {
//        LocationService.default.startLocation()
//        let clGeoCoder = CLGeocoder()
//        clGeoCoder.geocodeAddressString("西安市枫叶广场", completionHandler: {
//            if let placeMark = $0.0 {
//                let cllcotion = placeMark.first?.location
//                print("cllcotion = \(cllcotion?.coordinate.latitude),\(cllcotion?.coordinate.longitude)")
//            }
//        })
        LocationService.default.startLocation()
    }
        
}

extension ViewController: LocationMessageDelegate {
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

