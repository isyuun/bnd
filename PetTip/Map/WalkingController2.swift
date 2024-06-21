//
//  WalkingController2.swift
//  PetTip
//
//  Created by Ahn Je Wook on 6/20/24.
//

import Foundation
import CoreLocation

private let GPS_MAX_SATELLITES = 18
private let GPS_RELOAD_MINUTES = 10
private let GPS_UPDATE_MIllIS = 1
private let GPS_UPDATE_MIN_METERS = 5.0
//private let GPS_UPDATE_MAX_METERS = 15.0
private let GPS_UPDATE_MAX_METERS = 30.0
private let GPS_LATITUDE_ZERO = 37.546855 //37.5
private let GPS_LONGITUDE_ZERO = 127.065330 //127.0
private let GPS_CAMERA_ZOOM_ZERO = 17.0

class WalkingController2: WalkingController {
    var recentLoc: CLLocation?

    override func startWalkingProcess() {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][bWalkingState:\(bWalkingState)][recentLoc:\(String(describing: recentLoc)))]")
        recentLoc = nil
        super.startWalkingProcess()
    }

    override func stopWalkingProcess() {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][bWalkingState:\(bWalkingState)][recentLoc:\(String(describing: recentLoc)))]")
        recentLoc = nil
        super.stopWalkingProcess()
    }

    override func updateCurrLocation(_ locations: [CLLocation]) {
        let start = (recentLoc == nil)
        guard let acur = locations.last?.horizontalAccuracy else { return }
        NSLog("[LOG][I][ST][(\(#fileID):\(#line))::\(#function)][bWalkingState:\(bWalkingState)][acur:\(String(describing: acur))][recentLoc:\(String(describing: recentLoc)))][locations:\(locations)]")
        if bWalkingState == .STOP {
            NSLog("[LOG][I][ED][(\(#fileID):\(#line))::\(#function)][bWalkingState:\(bWalkingState)][acur:\(String(describing: acur))][recentLoc:\(String(describing: recentLoc)))][locations:\(locations)]")
            super.updateCurrLocation(locations)
            return
        }
        if !start && (acur < 0 || acur > GPS_UPDATE_MAX_METERS) {
            NSLog("[LOG][I][NG][(\(#fileID):\(#line))::\(#function)][bWalkingState:\(bWalkingState)][acur:\(String(describing: acur))][recentLoc:\(String(describing: recentLoc)))][locations:\(locations)]")
            return
        }
        if start { recentLoc = locations.last }
        guard let loc1 = recentLoc else { return }
        guard let loc2 = locations.last else { return }
        let dist = loc1.distance(from: loc2)
        let chck = (dist > GPS_UPDATE_MIN_METERS && dist < GPS_UPDATE_MAX_METERS) && (acur < GPS_UPDATE_MAX_METERS)
        if (start || chck) {
            NSLog("[LOG][I][OK][(\(#fileID):\(#line))::\(#function)][bWalkingState:\(bWalkingState)][\(start || chck)][start:\(start)][chck:\(chck)][dist:\(dist)][loc1:\(loc1)][loc2:\(loc2))]")
            super.updateCurrLocation(locations)
        } else {
            NSLog("[LOG][I][NG][(\(#fileID):\(#line))::\(#function)][bWalkingState:\(bWalkingState)][\(start || chck)][start:\(start)][chck:\(chck)][dist:\(dist)][loc1:\(loc1)][loc2:\(loc2))]")
            return
        }
        recentLoc = locations.last
    }

}
