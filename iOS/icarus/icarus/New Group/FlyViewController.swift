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
// 2. create server
// 3. create cosmosdb instance

class FlyViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var currentAltitudeLabel: UILabel!
    @IBOutlet weak var currentVerticalAccuracyLabel: UILabel!
    @IBOutlet weak var highestAltitudeLabel: UILabel!
    @IBOutlet weak var highestVerticalAccuracyLabel: UILabel!
    
    var locationManager: CLLocationManager = CLLocationManager()
    var flyViewModel = FlyViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.delegate = self
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        flyViewModel.updateState(location: locations[locations.count - 1])
        updateUI()
    }
    
    private func updateUI() {
        currentAltitudeLabel.text = "altitude: \(flyViewModel.getCurrentAltitude() ?? 0.0) meters"
        currentVerticalAccuracyLabel.text = "vertical accuracy: \(flyViewModel.getCurrentVerticalAccuracy() ?? 0.0) meters"
        highestAltitudeLabel.text = "highest altitude: \(flyViewModel.getHighestAltitude() ?? 0.0) meters"
        highestVerticalAccuracyLabel.text = "highest vertical accuracy: \(flyViewModel.getHighestVerticalAccuracy() ?? 0.0)"
    }
}
