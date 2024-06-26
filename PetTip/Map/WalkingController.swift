//
//  WalkingController.swift
//  PetTip
//
//  Created by Ahn Je Wook on 6/12/24.
//


import Foundation
import CoreLocation
import NMapsMap


class WalkingController: LocationController {

    var selectedPets = [Pet]()
    var bWalkingState = WalkingState.STOP
    var walkingTimer: Timer?

//    // MARK: - Move Timer (Distance, TimeSec)
    var movedSec: Double = 0
    var movedDist: Double = 0
    var movePathDist: Double = 0
    var arrTrack: Array<Track> = Array<Track>();
    var arrImageFromCamera = [UIImage]()
    
    var tempMovedSec: Double = 0
    var tempMovedDist: Double = 0
    var tempArrTrack: Array<Track> = Array<Track>();
    var tempMovePathDist: Double = 0



    enum WalkingState: Int {
        case STOP
        case START
        case PAUSE
    }

    
    enum EventMark: Int {
        case PEE
        case POO
        case MRK
        case IMG
    }

    
    override init() {
        super.init()
    }
    
    func updateWalkingState(_ bWalkingState: WalkingState) {
        if self.bWalkingState == .PAUSE && bWalkingState == .START  {
            movedSec = tempMovedSec
            movedDist = tempMovedDist
            arrTrack = tempArrTrack
        }
        self.bWalkingState = bWalkingState;
    }
    

    @objc func walkingTimerCallback() {
        if bWalkingState == .STOP {
            stopWalkingProcess()
        } else {
            refreshMoveInfoData()
            delegate?.walkingTimerCallback()
        }
        
    }

    func resetWalkingData() {
        movedSec = 0
        movedDist = 0
        movePathDist = 0
        
        tempMovedSec = 0
        tempMovedDist = 0
        tempMovePathDist = 0
        
        arrTrack.removeAll()
        tempArrTrack.removeAll()
        arrImageFromCamera.removeAll()
    }

    
    func startWalkingProcess() {
        bWalkingState = .START
        arrTrack.removeAll()
        tempArrTrack.removeAll()
        arrImageFromCamera.removeAll()
        startContinueLocation()
    }

    func stopWalkingProcess() {
        bWalkingState = .STOP
        arrTrack.removeAll()
        tempArrTrack.removeAll()
        arrImageFromCamera.removeAll()
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
        tempArrTrack.removeAll { $0 === track }
    }

    
    func addTrack(track: Track) {
        tempArrTrack.append(track)
        if bWalkingState == .START {
            arrTrack = tempArrTrack
        }
    }

    func addCurrLocation(_ recentLoc: CLLocation?) {

        let track = Track()
        track.location = recentLoc
        track.event = .non

        if (tempArrTrack.count > 0) {
            if (tempArrTrack.last!.location!.distance(from: track.location!) >= 10) {
                addTrack(track: track)
                movePathDist += moveDistance()
            }
        } else {
            addTrack(track: track)
            movePathDist = 0
        }
    }

    func updateMovePathDist(_ dist: Double) {
        movePathDist = dist
    }
    
    func moveDistance() -> CLLocationDistance {
        return tempArrTrack[tempArrTrack.count - 1].location!.distance(from: tempArrTrack[tempArrTrack.count - 2].location!)
    }
    
    
    func refreshMoveInfoData() {
        tempMovedSec += 1
        tempMovedDist = movePathDist;
        if bWalkingState == .START {
            movedSec = tempMovedSec
            movedDist = tempMovedDist
        }
    }
    
    override func updateCurrLocation(_ locations: [CLLocation]) {
        delegate?.didUpdateLocations(locations);
        if bWalkingState != .STOP {
            addCurrLocation(locations.last);
        }
    }

 }


