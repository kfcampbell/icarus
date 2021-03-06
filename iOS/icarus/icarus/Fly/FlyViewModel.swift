//
//  FlyViewModel.swift
//  icarus
//
//  Created by Keegan Campbell on 2/17/19.
//  Copyright © 2019 kfcampbell. All rights reserved.
//

import Foundation
import CoreLocation
import Alamofire

class FlyViewModel {
    public var displayName = "default_display_name"
    private var locations: [CLLocation] = []
    private var baselineAltitude = 0.0
    private var baselineSet = false
    private var highestAltitude: CLLocationDistance? = nil
    private var highestVerticalAccuracy: CLLocationAccuracy? = nil
    
    public func getUserHighScore() -> Score {
        let score = Score()
        score.baselineAltitude = baselineAltitude.description
        score.baselineVerticalAccuracy = "\(0.0)"
        score.dateTime = ScoreUtilities.getFormattedDate()
        score.displayName = displayName
        score.latLng = ScoreUtilities.getFormattedLatLon(location: locations[0])
        
        if let peakAltitude = highestAltitude {
            score.peakAltitude = String(peakAltitude)
        }
        if let peakVerticalAccuracy = highestVerticalAccuracy {
            score.peakVerticalAccuracy = String(peakVerticalAccuracy)
        }
        score.phoneModel = ScoreUtilities.getDeviceModel()
        return score
    }
    
    private func getHighScoreParams(score: Score) -> [String: Any] {
        let highScore: [String: Any] = [
            "LatLng": score.latLng,
            "DisplayName": score.displayName,
            "BaselineAltitude": score.baselineAltitude,
            "PeakAltitude": score.peakAltitude,
            "BaselineVerticalAccuracy": score.baselineVerticalAccuracy,
            "PeakVerticalAccuracy": score.peakVerticalAccuracy,
            "TimeStamp": score.dateTime,
            "PhoneModel": score.phoneModel,
            "ThrowDuration": (score.throwDuration == "") ? "0" : score.throwDuration
        ]
        return highScore
    }
    
    // todo(kfcampbell):
    // 1. add input validation
    // 2. add a return value that depeends on response.result's status
    public func sendHighScore(score: Score) -> Bool {
        let params = self.getHighScoreParams(score: score)
        
        AF.request(Constants.icarusServerUrl, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
        }
        
        return true
    }
    
    public func getCurrentAltitude() -> CLLocationDistance? {
        if(locations.count > 5) {
            return locations[locations.count - 1].altitude - baselineAltitude
        }
        return nil
    }
    
    public func getCurrentVerticalAccuracy() -> CLLocationAccuracy? {
        if(locations.count > 5) {
            return locations[locations.count - 1].verticalAccuracy
        }
        return nil
    }
    
    public func getHighestAltitude() -> CLLocationDistance? {
        if let highest = highestAltitude {
            return highest - baselineAltitude
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
        if(locations.count <= 5) {
            locations.append(location)
            return
        } else if !baselineSet {
            var sum = 0.0
            for (index, location) in locations.enumerated() {
                if(index > 4) {
                    break
                }
                sum += location.altitude
            }
            baselineAltitude = sum / 5
            baselineSet = true
        }
        updateHighestAltitude(altitude: location.altitude)
        updateHighestVerticalAccuracy(verticalAccuracy: location.verticalAccuracy)
        locations.append(location)
    }
    
    public func reset() {
        locations = []
        baselineAltitude = 0.0
        baselineSet = false
        highestAltitude = nil
        highestVerticalAccuracy = nil
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
