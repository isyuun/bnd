//
//  WalkingController3.swift
//  PetTip
//
//  Created by Ahn Je Wook on 6/24/24.
//

import Foundation
import CoreLocation

class WalkingController3: WalkingController2 {
    override func addTrack(track: Track) {
        super.addTrack(track: track)
        
        let item = TrackItem(location: track.location, event: track.event, pet: track.pet)
        let walkTrack = WalkTrack(movedSec: tempMovedSec, movedDist: movedDist, movePathDist: movePathDist)
        if let loadedTrack = loadTrackFromUserDefaults() {
            print("Loaded Track: \(loadedTrack.lastDate) \(loadedTrack.trackList.count)")
            loadedTrack.trackList.append(item)
            walkTrack.trackList = loadedTrack.trackList
        } else {
            walkTrack.trackList = [item]
        }
        
        saveTrackToUserDefaults(walkTrack)
    }
    
    private func saveTrackToUserDefaults(_ walkTrack: WalkTrack) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(walkTrack) {
            UserDefaults.standard.set(encoded, forKey: "WalkTrackList")
            UserDefaults.standard.synchronize()
        }
    }

    private func loadTrackFromUserDefaults() -> WalkTrack? {
        if let savedTrackData = UserDefaults.standard.object(forKey: "WalkTrackList") as? Data {
            let decoder = JSONDecoder()
            if let loadedwalkTrack = try? decoder.decode(WalkTrack.self, from: savedTrackData) {
                return loadedwalkTrack
            }
        }
        return nil
    }
    
    public func clearTrackFromUserDefaults() {
//        UserDefaults.standard.removeObject(forKey: "WalkTrackList")
//        UserDefaults.standard.synchronize()
    }

    
    public func checkWalkTrack() -> Bool {
        // 이전에 끊긴 데이터가 있는가?
        guard let loadedTrack = loadTrackFromUserDefaults() else {
            return false
        }

        // 시간 차이를 계산
        let timeDifference = Date().timeIntervalSince(loadedTrack.lastDate)

        // 10분(600초) 이상인지 확인
        guard timeDifference < 600 else {
            print("10분 이상 경과하였습니다.")
            clearTrackFromUserDefaults()
            return false
        }
        return true
    }


}

