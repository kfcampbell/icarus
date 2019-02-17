//
//  FlyViewModel.swift
//  icarus
//
//  Created by Keegan Campbell on 2/17/19.
//  Copyright © 2019 kfcampbell. All rights reserved.
//

import Foundation
import CoreLocation

class FlyViewModel {
    private var locations: [CLLocation] = []
    private var baselineLocation: CLLocation = CLLocation()
    private var highestAltitude: CLLocationDistance? = nil
    private var highestVerticalAccuracy: CLLocationAccuracy? = nil
    
    public func getCurrentAltitude() -> CLLocationDistance? {
        if(locations.count > 0) {
            return locations[locations.count - 1].altitude - baselineLocation.altitude
        }
        return nil
    }
    
    public func getCurrentVerticalAccuracy() -> CLLocationAccuracy? {
        if(locations.count > 0) {
            return locations[locations.count - 1].verticalAccuracy
        }
        return nil
    }
    
    public func getHighestAltitude() -> CLLocationDistance? {
        if let highest = highestAltitude {
            return highest - baselineLocation.altitude
        }
        return nil
    }
    public func getHighestVerticalAccuracy() -> CLLocationAccuracy? {
        if let highest = highestVerticalAccuracy {
            return highest
        }
        return nil
    }
    
    public func updateState(location: CLLocation) {
        if(locations.count <= 0) {
            baselineLocation = location
        }
        updateHighestAltitude(altitude: location.altitude)
        updateHighestVerticalAccuracy(verticalAccuracy: location.verticalAccuracy)
        locations.append(location)
    }
    
    private func updateHighestAltitude(altitude: CLLocationDistance) {
        if(highestAltitude == nil || highestAltitude! < altitude) {
            highestAltitude = altitude
        }
    }
    
    private func updateHighestVerticalAccuracy(verticalAccuracy: CLLocationAccuracy) {
        if(highestVerticalAccuracy == nil || highestVerticalAccuracy! < verticalAccuracy) {
            highestVerticalAccuracy = verticalAccuracy
        }
    }
}
