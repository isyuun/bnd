//
//  WalkingController.swift
//  PetTip
//
//  Created by Ahn Je Wook on 6/12/24.
//


import Foundation
import CoreLocation
import NMapsMap


/*
 기능 목록
 - 현재위치 받기
 - 타이머로 1초단위로 루프
 - 퍼미션 체크
 
 변수 모록
 - Track 목록 변수
 - 거리 변수
 - 시간 변수
 - 산책버튼 ON/OFF 플레그 변수
 - delegate
 

 
 */

class WalkingController: LocationController {

    var bWalkingState = false

    var walkingTimer: Timer?

//    // MARK: - Move Timer (Distance, TimeSec)
    var movedSec: Double = 0
    var movedDist: Double = 0
    var movePathDist: Double = 0
    var arrTrack: Array<Track> = Array<Track>();
    var arrEventMarker: Array<NMFMarker> = Array<NMFMarker>();

    enum EventMark: Int {
        case PEE
        case POO
        case MRK
        case IMG
    }

    
    override init() {
        super.init()
    }
    

    @objc func walkingTimerCallback() {
        guard bWalkingState == true else {
            stopWalkingProcess()
            return
        }
        refreshMoveInfoData()
        delegate?.walkingTimerCallback()
    }

    func resetWalkingData() {
        movedSec = 0
        movedDist = 0
        movePathDist = 0
        arrTrack.removeAll()
        arrEventMarker.removeAll()
    }

    
    func startWalkingProcess() {
        bWalkingState = true
        arrTrack.removeAll()
        startContinueLocation()
        
    }

    func stopWalkingProcess() {
        bWalkingState = false
        arrTrack.removeAll()
        stopContinueLocation()
    }
    
    
    func refreshMoveInfoStart() {
        walkingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(walkingTimerCallback), userInfo: nil, repeats: true)
    }
    
    func refreshMoveInfoStop() {
        if (walkingTimer != nil && walkingTimer!.isValid) {
            walkingTimer!.invalidate()
        }
    }

    
    func removeTrack(track: Track) {
        arrTrack.removeAll { $0 === track }
    }

    
    func addTrack(track: Track) {
        arrTrack.append(track)
    }

    func addCurrLocation(_ recentLoc: CLLocation?) {

        let track = Track()
        track.location = recentLoc
        track.event = .non

        if (arrTrack.count > 0) {
            if (arrTrack.last!.location!.distance(from: track.location!) >= 10) {
                arrTrack.append(track)
                movePathDist += moveDistance()            }

        } else {
            arrTrack.append(track)
            movePathDist = 0
        }
    }

    func moveDistance() -> CLLocationDistance {
        return arrTrack[arrTrack.count - 1].location!.distance(from: arrTrack[arrTrack.count - 2].location!)
    }
    
    
    func addEvent(track: Track?, marker: NMFMarker?) {
        guard let track = track, let marker = marker, arrTrack.last?.location == nil else {
            return;
        }
        arrTrack.append(track)
        arrEventMarker.append(marker)
    }

    
    
    func refreshMoveInfoData() {
        movedSec += 1
        movedDist = movePathDist
        
    }
    
    
    override func updateCurrLocation(_ locations: [CLLocation]) {
        delegate?.didUpdateLocations(locations);
        if bWalkingState == true {
            addCurrLocation(locations.last);
        }
    }

 }


