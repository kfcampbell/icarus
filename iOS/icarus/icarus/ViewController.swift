//
//  ViewController.swift
//  icarus
//
//  Created by Keegan Campbell on 2/17/19.
//  Copyright © 2019 kfcampbell. All rights reserved.
//

import UIKit
import CoreLocation

// todo(kfcampbell):
// 0. store highest value in private variable
// 1. refactor to MVVM pattern
// 2. create server
// 3. create cosmosdb instance

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var currentAltitudeLabel: UILabel!
    @IBOutlet weak var currentVerticalAccuracyLabel: UILabel!
    @IBOutlet weak var highestAltitudeLabel: UILabel!
    @IBOutlet weak var highestVerticalAccuracyLabel: UILabel!
    
    var locationManager: CLLocationManager = CLLocationManager()
    var altitudes: [CLLocationDistance] = []
    var verticalAccuracies: [CLLocationAccuracy] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.delegate = self
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        updateUI(location: locations[locations.count - 1])
        updateState(newLocation: locations[locations.count - 1])
    }
    
    private func updateUI(location: CLLocation) {
        currentAltitudeLabel.text = "altitude: \(location.altitude) meters"
        currentVerticalAccuracyLabel.text = "vertical accuracy: \(location.verticalAccuracy) meters"
    }
    
    private func updateState(newLocation: CLLocation) {
        altitudes.append(newLocation.altitude)
        verticalAccuracies.append(newLocation.verticalAccuracy)
    }
    
    //    private func getHighestAltitude(): CLLocationDistance {
    //
    //    }
}
