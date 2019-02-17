//
//  ScoreUtilities.swift
//  icarus
//
//  Created by Keegan Campbell on 2/17/19.
//  Copyright © 2019 kfcampbell. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class ScoreUtilities {
    public static func getFormattedLatLon(location: CLLocation) -> String {
        // format: lat || long
        return "\(location.coordinate.latitude) || \(location.coordinate.longitude)"
    }
    
    public static func getDeviceModel() -> String {
        return UIDevice.modelName
    }
    
    public static func getFormattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        return dateFormatter.string(from: Date())
    }
}
