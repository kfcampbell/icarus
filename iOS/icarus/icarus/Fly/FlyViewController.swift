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
// 0. figure out how to make service calls whose results are bound to model schema
// 1. create UI/models for leaderboard. populate with fake data in view model.
// 2. populate leaderboard with real data
// 3. wire up "send high score" button press

class FlyViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var displayNameLabel: UITextField!
    @IBOutlet weak var currentAltitudeLabel: UILabel!
    @IBOutlet weak var highestAltitudeLabel: UILabel!
    
    var locationManager: CLLocationManager = CLLocationManager()
    var flyViewModel = FlyViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.delegate = self
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        flyViewModel.updateState(location: locations[locations.count - 1])
        updateUI()
    }
    
    @IBAction func trackingSwitchFlipped(_ sender: UISwitch) {
        if(sender.isOn) {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.stopUpdatingLocation()
        }
    }
    
    @IBAction func sendHighScore(_ sender: UIButton) {
        flyViewModel.displayName = (displayNameLabel.text == "") ? "default_display_name" : displayNameLabel.text ?? "default_display_name"
        let score = flyViewModel.getUserHighScore()
        print(score)
        let _ = flyViewModel.sendHighScore(score: score)
        let alert = UIAlertController(title: "You've Made A Legal Agreement!", message: "Thanks for granting us consent to take your first born child. We'll be in touch with more details shortly!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Okay", style: .default) { (action) in
            // noop
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func resetLocalData(_ sender: UIButton) {
        flyViewModel.reset()
        updateUI()
    }
    
    private func updateUI() {
        currentAltitudeLabel.text = "current height: \(flyViewModel.getCurrentAltitude() ?? 0.0) meters"
        highestAltitudeLabel.text = "highest toss: \(flyViewModel.getHighestAltitude() ?? 0.0) meters"
    }
}
