//
//  Track2.swift
//  PetTip
//
//  Created by Ahn Je Wook on 6/24/24.
//

import Foundation
import CoreLocation
import UIKit


class WalkTrack: Codable {
    var lastDate: Date = Date()
    var movedSec: Double = 0
    var movedDist: Double = 0
    var movePathDist: Double = 0
    var trackList: Array<Track> = []
    var selectedPets = [Pet]()
    var arrImageFromCamera = [UIImage]()


    init() {
    }
    
    enum CodingKeys: String, CodingKey {
        case lastDate
        case movedSec
        case movedDist
        case movePathDist
        case trackList
        case selectedPets
        case arrImageFromCamera
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.lastDate = try container.decode(Date.self, forKey: .lastDate)
        self.movedSec = try container.decode(Double.self, forKey: .movedSec)
        self.movedDist = try container.decode(Double.self, forKey: .movedDist)
        self.movePathDist = try container.decode(Double.self, forKey: .movePathDist)
        self.trackList = try container.decode([Track].self, forKey: .trackList)
        self.selectedPets = try container.decode([Pet].self, forKey: .selectedPets)
        
        let imageDataArray = try container.decode([Data].self, forKey: .arrImageFromCamera)
        self.arrImageFromCamera = imageDataArray.compactMap { UIImage(data: $0) }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(lastDate, forKey: .lastDate)
        try container.encode(movedSec, forKey: .movedSec)
        try container.encode(movedDist, forKey: .movedDist)
        try container.encode(movePathDist, forKey: .movePathDist)
        try container.encode(trackList, forKey: .trackList)
        try container.encode(selectedPets, forKey: .selectedPets)

        let imageDataArray = arrImageFromCamera.compactMap { $0.jpegData(compressionQuality: 1.0) }
        try container.encode(imageDataArray, forKey: .arrImageFromCamera)
    }

}


//struct TrackItem: Codable {
//    var location: CLLocation?
//    var event: Event?
//    var pet: Pet?
//
//    enum CodingKeys: String, CodingKey {
//        case locationLatitude
//        case locationLongitude
//        case event
//        case pet
//    }
//    
//    init(location: CLLocation?, event: Event?, pet: Pet?) {
//        self.location = location
//        self.event = event
//        self.pet = pet
//    }
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        
//        if let latitude = try container.decodeIfPresent(CLLocationDegrees.self, forKey: .locationLatitude),
//           let longitude = try container.decodeIfPresent(CLLocationDegrees.self, forKey: .locationLongitude) {
//            self.location = CLLocation(latitude: latitude, longitude: longitude)
//        } else {
//            self.location = nil
//        }
//        
//        if let event = try container.decodeIfPresent(Event.self, forKey: .event) {
//            self.event = event
//        } else {
//            self.location = nil
//        }
//
//        if let pet = try container.decodeIfPresent(Pet.self, forKey: .pet) {
//            self.pet = pet;
//        } else {
//            self.pet = nil
//        }
//        
//    }
//    
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        
//        if let location = location {
//            try container.encode(location.coordinate.latitude, forKey: .locationLatitude)
//            try container.encode(location.coordinate.longitude, forKey: .locationLongitude)
//        }
//        
//        if let event = event {
//            try container.encodeIfPresent(event, forKey: .event)
//        }
//        if let pet = pet {
//            try container.encodeIfPresent(pet, forKey: .pet)
//        }
//    }
//}

