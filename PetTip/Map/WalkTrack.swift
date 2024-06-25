//
//  Track2.swift
//  PetTip
//
//  Created by Ahn Je Wook on 6/24/24.
//

import Foundation
import CoreLocation


class WalkTrack: Codable {
    var lastDate: Date = Date()
    var movedSec: Double = 0
    var movedDist: Double = 0
    var movePathDist: Double = 0
    var trackList: Array<TrackItem> = []
    
    
    init() {
    }
    
//    init(movedSec: Double, movedDist: Double, movePathDist: Double) {
//        self.movedSec = movedSec
//        self.movedDist = movedDist
//        self.movePathDist = movePathDist
//    }
}


struct TrackItem: Codable {
    var location: CLLocation?
    var event: Event?
    var pet: Pet?

    enum CodingKeys: String, CodingKey {
        case locationLatitude
        case locationLongitude
        case event
        case pet
    }
    
    init(location: CLLocation?, event: Event?, pet: Pet?) {
        self.location = location
        self.event = event
        self.pet = pet
    }

    init(from decoder: Decoder) throws {
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


//// CLLocation을 감싸는 구조체
//struct CodableLocation: Codable {
//    var latitude: Double
//    var longitude: Double
//
//    init(from location: CLLocation) {
//        self.latitude = location.coordinate.latitude
//        self.longitude = location.coordinate.longitude
//    }
//
//    func toCLLocation() -> CLLocation {
//        return CLLocation(latitude: latitude, longitude: longitude)
//    }
//}
//
//
//
//
//struct CodableTrack: Codable {
//    var location: CLLocation?
//    var event: Event?
//    var pet: Pet?
//    
//    enum CodingKeys: String, CodingKey {
//        case location
//        case event
//        case pet
//    }
//    init(location: CLLocation? = nil, event: Event? = nil, pet: Pet? = nil) {
//        self.location = location
//        self.event = event
//        self.pet = pet
//    }
//
//    
//    func toTrack() -> Track {
//        return Track(latitude: latitude, longitude: longitude)
//    }
//
//    
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        if let locationData = try? container.decode(CodableLocation.self, forKey: .location) {
//            self.location = locationData.toCLLocation()
//        }
//        self.event = try container.decode(Event.self, forKey: .event)
//        if let petData = try? container.decode(Pet.self, forKey: .pet) {
//            self.pet = petData
//        }
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        if let location = self.location {
//            let codableLocation = CodableLocation(from: location)
//            try container.encode(codableLocation, forKey: .location)
//        }
//        try container.encode(event, forKey: .event)
//        if pet != nil {
//            try container.encode(pet, forKey: .pet)
//        }
//    }
//}
//
