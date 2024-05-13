//
//  NMapViewController4.swift
//  PetTip
//
//  Created by isyuun on 2024/5/13.
//

import UIKit
import NMapsMap
import AVKit

extension Pet: Equatable {
    static func == (lhs: Pet, rhs: Pet) -> Bool {
        // 여기에 비교할 내용을 구현합니다.
        return lhs.ownrPetUnqNo == rhs.ownrPetUnqNo && lhs.petNm == rhs.petNm // 예시로 ownrPetUnqNo와 petNm을 비교합니다.
    }
}

extension Track: Equatable {
    static func == (lhs: Track, rhs: Track) -> Bool {
        // location 비교
        let locationsEqual = lhs.location == rhs.location

        // event 비교
        let eventsEqual = lhs.event == rhs.event

        // pet 비교
        let petsEqual = lhs.pet == rhs.pet

        return locationsEqual && eventsEqual && petsEqual
    }
}

class NMapViewController4: NMapViewController3 {
    override func selectEventMarkPet(mark: NMapViewController.EventMark) {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][mark:\(mark)]")
        super.selectEventMarkPet(mark: mark)
    }

    override func addEventMark(mark: NMapViewController.EventMark, pet: Pet) {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][mark:\(mark)][pet:\(pet)]")
        // super.addEventMark(mark: mark, pet: pet)

        if (arrTrack != nil && arrTrack.last != nil && arrTrack.last?.location != nil) {
            let marker = NMapViewController.getEventMarker(loc: NMGLatLng(lat: arrTrack.last!.location!.coordinate.latitude, lng: arrTrack.last!.location!.coordinate.longitude), event: mark)
            marker.mapView = self.mapView

            let track = Track()
            track.location = CLLocation(coordinate: arrTrack.last!.location!.coordinate,
                                        altitude: arrTrack.last!.location!.altitude,
                                        horizontalAccuracy: arrTrack.last!.location!.horizontalAccuracy,
                                        verticalAccuracy: arrTrack.last!.location!.verticalAccuracy,
                                        course: arrTrack.last!.location!.course,
                                        courseAccuracy: arrTrack.last!.location!.courseAccuracy,
                                        speed: arrTrack.last!.location!.speed,
                                        speedAccuracy: arrTrack.last!.location!.speedAccuracy,
                                        timestamp: Date())
            track.event = mark == .PEE ? .pee : mark == .POO ? .poo : mark == .MRK ? .mrk : .img
            track.pet = pet
            arrTrack.append(track)

            if (arrEventMarker == nil) {
                arrEventMarker = Array<NMFMarker>()
            }
            arrEventMarker?.append(marker)

            let petName = pet.petNm

            let eventInfo: String
            switch(track.event) {
            case .pee: eventInfo = "소변"
                break
            case .poo: eventInfo = "배변"
                break
            case .mrk: eventInfo = "마킹"
                break
            case .img: eventInfo = "사진"
                break
            default: eventInfo = ""
                break
            }

            let infoWindow = NMFInfoWindow()
            let dataSource = NMFInfoWindowDefaultTextSource.data()
            dataSource.title = "\(petName) \(eventInfo)"
            infoWindow.dataSource = dataSource
            infoWindow.touchHandler = { overlay in
                if let infoWindow = overlay as? NMFInfoWindow {
                    NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][인포::터치][infoWindow:\(infoWindow)][marker:\(String(describing: infoWindow.marker))][mapView:\(String(describing: infoWindow.marker?.mapView))]")
                    infoWindow.marker?.mapView = nil
                    // deleteTrack(track)
                    // deleteMark(track)
                    // self.arrTrack = self.arrTrack.filter { $0 !== track }
                    self.arrTrack.removeAll { $0 === track }
                    infoWindow.close()
                }
                return true
            }
            infoWindow.mapView = mapView

            let w = marker.width
            let h = marker.height
            
            // marker.infoWindow = infoWindow
            marker.touchHandler = { /*[weak self]*/ overlay in
                // 마커가 탭되었을 때 실행될 코드
                NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][마커::터치][overlay:\(String(describing: overlay))][marker:\(marker)]")
                if let marker = overlay as? NMFMarker/*, track.event != .img*/ {
                    if (marker.zIndex == 10) {
                        marker.width = w * 0.9 //(32 * 0.9f).dp.toPx(context).toInt()
                        marker.height = h * 0.9 //(32 * 0.9f).dp.toPx(context).toInt()
                        // marker.zIndex = 2

                        infoWindow.close()
                    } else {
                        marker.width = w * 1.1 //(32 * 1.1f).dp.toPx(context).toInt()
                        marker.height = h * 1.1 //(32 * 1.1f).dp.toPx(context).toInt()
                        // marker.zIndex = 10

                        infoWindow.open(with: marker)
                    }

                    if let markers = self.arrEventMarker {
                        markers.filter { $0 != marker }.forEach { otherMarker in
                            marker.width = w * 0.9 //(32 * 0.9f).dp.toPx(context).toInt()
                            marker.height = h * 0.9 //(32 * 0.9f).dp.toPx(context).toInt()
                            // otherMarker.zIndex = 2

                            otherMarker.infoWindow?.close()
                        }
                    }
                }
                return true
            }
        }
    }

    override func onBtnMrk(_ sender: Any) {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][sender:\(sender)]")
        super.onBtnMrk(sender)
    }

    override func onBtnCamera(_ sender: Any) {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][sender:\(sender)]")
        #if targetEnvironment(simulator)
            self.showToast(msg: "Simulator에서는 카메라가 동작하지 않아요")
            selectEventMarkPet(mark: .IMG)
            return
        #else
            super.onBtnCamera(sender)
        #endif
    }
}
