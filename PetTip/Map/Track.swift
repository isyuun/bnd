//
//  Track.swift
//  PetTip
//
//  Created by carebiz on 11/30/23.
//

import Foundation
import CoreLocation

//class Track {
//    var location : CLLocation?
//    var event : Event?
//    var pet: Pet?
//}


class Track: Codable {
    var location: CLLocation?
    var event: Event?
    var pet: Pet?

    enum CodingKeys: String, CodingKey {
        case locationLatitude
        case locationLongitude
        case event
        case pet
    }
    
//    init(location: CLLocation?, event: Event?, pet: Pet?) {
//        self.location = location
//        self.event = event
//        self.pet = pet
//    }

    init() {
        
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let latitude = try container.decodeIfPresent(CLLocationDegrees.self, forKey: .locationLatitude),
           let longitude = try container.decodeIfPresent(CLLocationDegrees.self, forKey: .locationLongitude) {
            self.location = CLLocation(latitude: latitude, longitude: longitude)
        } else {
            self.location = nil
        }
        
        if let event = try container.decodeIfPresent(Event.self, forKey: .event) {
            self.event = event
        } else {
            self.location = nil
        }

        if let pet = try container.decodeIfPresent(Pet.self, forKey: .pet) {
            self.pet = pet;
        } else {
            self.pet = nil
        }
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        if let location = location {
            try container.encode(location.coordinate.latitude, forKey: .locationLatitude)
            try container.encode(location.coordinate.longitude, forKey: .locationLongitude)
        }
        
        if let event = event {
            try container.encodeIfPresent(event, forKey: .event)
        }
        if let pet = pet {
            try container.encodeIfPresent(pet, forKey: .pet)
        }
    }
}

enum Event : Int, Codable {
    case non = 0
    case pee = 1
    case poo = 2
    case mrk = 3
    case img = 4
}
