//
//  LocationViewController2.swift
//  PetTip
//
//  Created by isyuun on 2024/5/24.
//

import UIKit
import NMapsMap

class LocationViewController2: LocationViewController {
    var recentLoc: CLLocation?

    override func updateCurrLocation(_ locations: [CLLocation]) {
        super.updateCurrLocation(locations)
        recentLoc = locations.last
    }
}
