//
//  Track.swift
//  PetTip
//
//  Created by carebiz on 11/30/23.
//

import Foundation
import CoreLocation

class Track {
    var location : CLLocation?
    var event : Event?
    var pet: Pet?
}

enum Event : Int {
    case non = 0
    case pee = 1
    case poo = 2
    case mrk = 3
    case img = 4
}
