//
//  LeaderboardViewModel.swift
//  icarus
//
//  Created by Keegan Campbell on 2/18/19.
//  Copyright © 2019 kfcampbell. All rights reserved.
//

import Foundation
import Alamofire

class LeaderboardViewModel {
    public var highScores: [Score] = []
    
    public func getHighScores(successCallback: @escaping () -> Void) {
        AF.request(Constants.icarusServerUrl, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            self.highScores = []
            
            if let results = response.result.value as? [[String: Any]] {
                for result in results {
                    print("result item: \(result)")
                    
                    if let latLng = result["latLng"] as? String, let phoneModel = result["phoneModel"] as? String, let timeStamp = result["timeStamp"] as? String, let baselineAltitude = result["baselineAltitude"] as? Double, let peakAltitude = result["peakAltitude"] as? Double, let baselineVerticalAccuracy = result["baselineVerticalAccuracy"] as? Double, let peakVerticalAccuracy = result["peakVerticalAccuracy"] as? Double, let scoreId = result["scoreId"] as? Int, let displayName = result["displayName"] as? String, let throwDuration = result["throwDuration"] as? Double {
                        let highScore = Score()
                        highScore.latLng = latLng
                        highScore.phoneModel = phoneModel
                        highScore.dateTime = timeStamp
                        highScore.baselineAltitude = String(baselineAltitude)
                        highScore.peakAltitude = String(peakAltitude)
                        highScore.baselineVerticalAccuracy = String(baselineVerticalAccuracy)
                        highScore.peakVerticalAccuracy = String(peakVerticalAccuracy)
                        highScore.throwDuration = String(throwDuration)
                        highScore.scoreId = String(scoreId)
                        highScore.displayName = displayName
                        
                        self.highScores.append(highScore)
                    }
                }
                successCallback()
            } else {
                print("serialization failed")
            }
        }
    }
    
    public func getComputedHeight(score: Score) -> Double {
        return (Double(score.peakAltitude) ?? 0.0) - (Double(score.baselineAltitude) ?? 0.0)
    }
}
