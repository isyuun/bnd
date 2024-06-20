//
//  NMapViewController.swift
//  PetTip
//
//  Created by carebiz on 11/23/23.
//

import UIKit
import NMapsMap
import AVKit

class NMapViewController: CommonViewController2, MapBottomViewProtocol {

    public var dailyLifePetList: PetList?
    private var selectedPets = [Pet]()

    @IBOutlet weak var naverMapView: NMFNaverMapView!
    var mapView: NMFMapView {
        return naverMapView.mapView
    }

    @IBOutlet weak var zoomControlView: NMFZoomControlView!
    @IBOutlet weak var compassView: NMFCompassView!    
    @IBOutlet weak var locationButton: NMFLocationButton!

    @IBOutlet weak var mapTopView: MapTopView!

    var walkingController: WalkingController2?

    
    var bottomSheetVC: BottomSheetViewController? = nil
    var mapBottomView: MapBottomView! = nil

    var mapSnapImg: UIImage? = nil
    var mapZoomLevel: Double = 17.0
    var mapPositionMode: NMFMyPositionMode = .normal

    @IBOutlet weak var btnWalk: UIButton!
    @IBAction func onBtnWalk(_ sender: Any) {
        
        guard let walkingController = walkingController else {
            return
        }
        
        if (walkingController.bWalkingState == true) {
//            if (endMarker == nil) {
//                guard let location = walkingController.arrTrack.last?.location else {
//                    return
//                }
//
//                endMarker = NMapViewController.getTextMarker(loc: NMGLatLng(lat: location.coordinate.latitude, lng: location.coordinate.longitude), text: "도착", forceShow: false)
//                endMarker.mapView = self.naverMapView.mapView
//
//                let track = Track()
//                track.location = CLLocation(coordinate: location.coordinate,
//                                            altitude: location.altitude,
//                                            horizontalAccuracy: location.horizontalAccuracy,
//                                            verticalAccuracy: location.verticalAccuracy,
//                                            course: location.course,
//                                            courseAccuracy: location.courseAccuracy,
//                                            speed: location.speed,
//                                            speedAccuracy: location.speedAccuracy,
//                                            timestamp: Date())
//                track.event = .non
////                arrTrack.append(track)
//                walkingController.addTrack(track: track);
//                
//            }
            
            guard let location = walkingController.arrTrack.last?.location else {
                return
            }
            
            let track = Track()
            track.location = CLLocation(coordinate: location.coordinate,
                                        altitude: location.altitude,
                                        horizontalAccuracy: location.horizontalAccuracy,
                                        verticalAccuracy: location.verticalAccuracy,
                                        course: location.course,
                                        courseAccuracy: location.courseAccuracy,
                                        speed: location.speed,
                                        speedAccuracy: location.speedAccuracy,
                                        timestamp: Date())
            track.event = .non
            walkingController.addTrack(track: track);

            saveMapCameraData()
            
            showTrackSummaryMap()

            naverMapView.takeSnapshot(withShowControls: false, complete: { [weak self] (image) in
                self?.mapSnapImg = image
            })

            self.bottomSheetVC = BottomSheetViewController()
            if let bottomSheetVC = self.bottomSheetVC {
                bottomSheetVC.modalPresentationStyle = .overFullScreen
                bottomSheetVC.dismissIndicatorView.isHidden = true
                if let v = UINib(nibName: "MapBottomView", bundle: nil).instantiate(withOwner: self).first as? MapBottomView {
                    bottomSheetVC.addContentSubView(v: v)
                    v.initialize()
                    v.setDelegate(self)
                    mapBottomView = v
                }
                self.present(bottomSheetVC, animated: false, completion: nil)
            }

        } else {
            guard let dailyLifePets = dailyLifePetList else {
                self.showNoPet()
                return
            }

            let pets = dailyLifePets.pets

            if pets.count == 0 {
                self.showNoPet()
                return
            } else if pets.count > 1 {
                showSelectPetList()
            } else {
                selectedPets = [Pet]()
                selectedPets.append(dailyLifePets.pets.last!)
                walkingController.selectedPets = selectedPets
                startWalkingProcess()
            }
        }
    }

    func showNoPet() {
        self.showToast(msg: "등록된 펫이 없습니다")
    }

    private func showSelectPetList() {

        if let v = UINib(nibName: "SelectWalkPetView", bundle: nil).instantiate(withOwner: self).first as? SelectWalkPetView {
            v.initialize()
            v.setData(dailyLifePetList?.pets as Any)
            v.isSingleSelectMode = false
            v.didTapOK = { selectedPets in
                self.didTapPopupOK()

                self.selectedPets = selectedPets
                self.walkingController?.selectedPets = selectedPets;

                self.startWalkingProcess()
            }

            self.popupShow(contentView: v, wSideMargin: 0, type: .bottom)
        }
    }
    

    internal func startWalkingProcess() {

        btnWalk.tintColor = UIColor.init(hexCode: "F54F68")
        btnWalk.setAttrTitle("산책종료", 14)

        if pathOverlay == nil {
            pathOverlay = NMFPath()
            pathOverlay.width = 6
            pathOverlay.color = UIColor(hex: "#A0FFDBDB")!
            pathOverlay.outlineWidth = 2
            pathOverlay.outlineColor = UIColor(hex: "#A0FF5000")!
            pathOverlay.mapView = mapView
        }

        if walkingController?.bWalkingState == false {
            walkingController?.bWalkingState = true
            walkingController?.startContinueLocation()
            walkingController?.resetWalkingData()
            startLoading(msg: "위치정보 확인중")
        }
    }
    
    
    internal func loadWalkingProcess() {
        guard let walkingController = walkingController else {
            return
        }
        
        guard walkingController.bWalkingState == true else {
            return;
        }

        guard walkingController.selectedPets.count > 0 else {
            return;
        }
        
        clearMapOverlay()
        
        self.selectedPets = walkingController.selectedPets
        if pathOverlay == nil {
            pathOverlay = NMFPath()
            pathOverlay.width = 6
            pathOverlay.color = UIColor(hex: "#A0FFDBDB")!
            pathOverlay.outlineWidth = 2
            pathOverlay.outlineColor = UIColor(hex: "#A0FF5000")!
            pathOverlay.mapView = mapView
        }
        
        if (arrEventMarker == nil) {
            arrEventMarker = Array<NMFMarker>()
        }
        arrEventMarker?.removeAll()
        
        let arrTrack = walkingController.arrTrack

        for i in 0..<arrTrack.count {
            if i == 0 {
                startMarker = NMapViewController.getTextMarker(loc: NMGLatLng(lat: arrTrack[i].location!.coordinate.latitude, lng: arrTrack[i].location!.coordinate.longitude), text: "출발", forceShow: true)
                startMarker.mapView = self.naverMapView.mapView
            }

//            if i == arrTrack.count - 1 {
//                let endMarker = NMapViewController.getTextMarker(loc: NMGLatLng(lat: arrTrack[i].location!.coordinate.latitude, lng: arrTrack[i].location!.coordinate.longitude), text: "도착", forceShow: true)
//                endMarker.mapView = self.naverMapView.mapView
//            }

            if arrTrack[i].event != nil && (arrTrack[i].event == .pee || arrTrack[i].event == .poo || arrTrack[i].event == .mrk || arrTrack[i].event == .img) {
                var event: NMapViewController.EventMark = .MRK
                if arrTrack[i].event! == .pee {
                    event = .PEE

                } else if arrTrack[i].event! == .poo {
                    event = .POO

                } else if arrTrack[i].event! == .mrk {
                    event = .MRK

                } else if arrTrack[i].event! == .img {
                    event = .IMG
                }

                let eventMarker = NMapViewController.getEventMarker(loc: NMGLatLng(lat: arrTrack[i].location!.coordinate.latitude, lng: arrTrack[i].location!.coordinate.longitude), event: event)
                eventMarker.mapView = self.naverMapView.mapView
                
                arrEventMarker?.append(eventMarker);
            }

            if i == 1 {
                pathOverlay.path = NMGLineString(points: [
                    NMGLatLng(lat: arrTrack[0].location!.coordinate.latitude, lng: arrTrack[0].location!.coordinate.longitude),
                    NMGLatLng(lat: arrTrack[1].location!.coordinate.latitude, lng: arrTrack[1].location!.coordinate.longitude)])
                pathOverlay.mapView = naverMapView.mapView

            } else if i > 1 {
                let path = pathOverlay.path
                path.addPoint(NMGLatLng(lat: arrTrack[i].location!.coordinate.latitude, lng: arrTrack[i].location!.coordinate.longitude))
                pathOverlay.path = path
                pathOverlay.mapView = naverMapView.mapView
            }
        }
        
        DispatchQueue.main.async {
            if let location = arrTrack.last?.location {
                let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: location.coordinate.latitude, lng: location.coordinate.longitude), zoomTo: self.mapZoomLevel)
                cameraUpdate.animation = .none
//                cameraUpdate.animationDuration = 1
                self.mapView.moveCamera(cameraUpdate)
            }

        }

    }

    internal func stopWalkingProcess() {
        walkingController?.bWalkingState = false

        btnWalk.tintColor = UIColor.init(hexCode: "4783F5")
        btnWalk.setAttrTitle("산책하기", 14)

        walkingController?.stopContinueLocation()

//        if (startMarker != nil) { startMarker.mapView = nil }
//        startMarker = nil
//        if (endMarker != nil) { endMarker.mapView = nil; }
//        endMarker = nil
//
//        pathOverlay.mapView = nil
//        pathOverlay = nil
//
//        if let arrMarker = arrEventMarker {
//            for marker in arrMarker {
//                marker.mapView = nil
//            }
//        }

        clearMapOverlay()
        
        refreshMoveInfoStop(isSafeStop: false)
    }
    
    func clearMapOverlay() {
        if (startMarker != nil) { startMarker.mapView = nil }
        startMarker = nil
        if (endMarker != nil) { endMarker.mapView = nil; }
        endMarker = nil

        if pathOverlay != nil {
            pathOverlay.mapView = nil
        }
        pathOverlay = nil

        if let arrMarker = arrEventMarker {
            for marker in arrMarker {
                marker.mapView = nil
            }
        }

    }

    @IBOutlet weak var btnList: UIButton!
    @IBAction func onBtnList(_ sender: Any) {
    }

    @IBOutlet weak var btnPee: UIButton!
    @IBAction func onBtnPee(_ sender: Any) {
        selectEventMarkPet(mark: .PEE)
    }

    @IBOutlet weak var btnPoo: UIButton!
    @IBAction func onBtnPoo(_ sender: Any) {
        selectEventMarkPet(mark: .POO)
    }

    @IBOutlet weak var btnMrk: UIButton!
    @IBAction func onBtnMrk(_ sender: Any) {
        selectEventMarkPet(mark: .MRK)
    }

    internal func selectEventMarkPet(mark: NMapViewController.EventMark) {
        if selectedPets.count == 0 {
            return

        } else if selectedPets.count == 1 {
            addEventMark(mark: mark, pet: selectedPets.last!)

        } else if selectedPets.count > 1 {
            if let v = UINib(nibName: "SelectWalkMarkPetView", bundle: nil).instantiate(withOwner: self).first as? SelectWalkMarkPetView {
                v.initialize(pets: selectedPets, mark: mark)
                v.didSelect = { selectIndex in
                    self.didTapPopupOK()

                    self.addEventMark(mark: mark, pet: self.selectedPets[selectIndex])
                }
                v.didCancel = {
                    self.didTapPopupCancel()
                }

                self.popupShow(contentView: v, wSideMargin: 0, type: .bottom)
            }
        }
    }

    internal func addEventMark(mark: NMapViewController.EventMark, pet: Pet) {
        
        guard let walkingController = walkingController, let location = walkingController.arrTrack.last?.location else {
            return
        }
        
        let eventMarker = NMapViewController.getEventMarker(loc: NMGLatLng(lat: location.coordinate.latitude, lng: location.coordinate.longitude), event: mark)
        eventMarker.mapView = self.mapView

        let track = Track()
        track.location = CLLocation(coordinate: location.coordinate,
                                    altitude: location.altitude,
                                    horizontalAccuracy: location.horizontalAccuracy,
                                    verticalAccuracy: location.verticalAccuracy,
                                    course: location.course,
                                    courseAccuracy: location.courseAccuracy,
                                    speed: location.speed,
                                    speedAccuracy: location.speedAccuracy,
                                    timestamp: Date())
        track.event = mark == .PEE ? .pee : mark == .POO ? .poo : mark == .MRK ? .mrk : .img
        track.pet = pet
        walkingController.addTrack(track: track);

        if (arrEventMarker == nil) {
            arrEventMarker = Array<NMFMarker>()
        }
        arrEventMarker?.append(eventMarker)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.tabBar.isHidden = true

        mapView.mapType = .basic
        mapView.isNightModeEnabled = traitCollection.userInterfaceStyle == .dark ? true : false // default:false
        mapPositionMode = .normal
        mapView.positionMode = mapPositionMode
        mapZoomLevel = 17
        mapView.zoomLevel = mapZoomLevel
        mapView.minZoomLevel = 5.0
        // mapView.maxZoomLevel = 18.0
        //
        // mapView.locationOverlay.icon = NMFOverlayImage(name: "currentLocation")
        // mapView.locationOverlay.iconWidth = CGFloat(NMF_LOCATION_OVERLAY_SIZE_AUTO)
        // mapView.locationOverlay.iconHeight = CGFloat(NMF_LOCATION_OVERLAY_SIZE_AUTO)
        //
        // mapView.locationOverlay.subIcon = NMFOverlayImage(name: "currentLocation")
        // mapView.locationOverlay.subIconWidth = 40
        // mapView.locationOverlay.subIconHeight = 40
        // mapView.locationOverlay.subAnchor = CGPoint(x: 0.4, y: 0.4)
        // mapView.locationOverlay.subAnchor = CGPoint(x: 0.5, y: 1)
        //
        // mapView.locationOverlay.circleColor = UIColor.red
        //
        // let circleOverlay = NMFCircleOverlay(NMGLatLng(lat: 37.5666102, lng: 126.9783881), radius: 500) // 원 위치 및 반지름을 설정합니다.
        // circleOverlay.fillColor = .lightGray // 원 내부 색을 설정합니다.
        // circleOverlay.outlineColor = .red // 원 테두리 색을 설정합니다.
        // circleOverlay.outlineWidth = 3 // 원 테두리 두께를 설정합니다.
        // circleOverlay.mapView = naverMapView.mapView

        naverMapView.showCompass = false
        naverMapView.showIndoorLevelPicker = true

        naverMapView.showZoomControls = false
        zoomControlView.mapView = naverMapView.mapView
        compassView.mapView = naverMapView.mapView

        naverMapView.showLocationButton = false
        locationButton.isHidden = true  // locationButton.mapView = naverMapView.mapView

        // mapView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)

        btnWalk.layer.cornerRadius = 10.0
        btnWalk.tintColor = UIColor.init(hexCode: "4783F5")
        btnWalk.setAttrTitle("산책하기", 14)
        btnWalk.showShadowMid()

        btnCamera.layer.cornerRadius = 2.0
        btnCamera.layer.borderColor = UIColor.init(hexCode: "e3e9f2").cgColor
        btnCamera.layer.borderWidth = 1
        btnCamera.layer.backgroundColor = UIColor.white.cgColor
        btnCamera.setImage(UIImage(named: "icon_camera"), for: .normal)
        btnCamera.setTitle("", for: .normal)
        btnCamera.showShadowLight()

        btnList.layer.cornerRadius = 2.0
        btnList.layer.borderColor = UIColor.init(hexCode: "e3e9f2").cgColor
        btnList.layer.borderWidth = 1
        btnList.layer.backgroundColor = UIColor.white.cgColor
        btnList.setImage(UIImage(named: "icon_list"), for: .normal)
        btnList.setTitle("", for: .normal)
        btnList.showShadowLight()
        btnList.isHidden = true

        btnPee.layer.cornerRadius = btnPee.layer.bounds.width / 2
        btnPee.layer.borderColor = UIColor.init(hexCode: "e3e9f2").cgColor
        btnPee.layer.borderWidth = 1
        btnPee.layer.backgroundColor = UIColor.white.cgColor
        btnPee.setImage(UIImage(named: "icon_pee"), for: .normal)
        btnPee.setTitle("", for: .normal)
        btnPee.showShadowLight()
        btnPee.isHidden = true

        btnPoo.layer.cornerRadius = btnPoo.layer.bounds.width / 2
        btnPoo.layer.borderColor = UIColor.init(hexCode: "e3e9f2").cgColor
        btnPoo.layer.borderWidth = 1
        btnPoo.layer.backgroundColor = UIColor.white.cgColor
        btnPoo.setImage(UIImage(named: "icon_poop"), for: .normal)
        btnPoo.setTitle("", for: .normal)
        btnPoo.showShadowLight()
        btnPoo.isHidden = true

        btnMrk.layer.cornerRadius = btnMrk.layer.bounds.width / 2
        btnMrk.layer.borderColor = UIColor.init(hexCode: "e3e9f2").cgColor
        btnMrk.layer.borderWidth = 1
        btnMrk.layer.backgroundColor = UIColor.white.cgColor
        btnMrk.setImage(UIImage(named: "icon_marking"), for: .normal)
        btnMrk.setTitle("", for: .normal)
        btnMrk.showShadowLight()
        btnMrk.isHidden = true
        
        self.mapTopView.showMapTipView()
        
        // testCode...
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
//            //self.mapTopView.showMapNavView()
//        })
        // testCode...
    }

    func showTrackSummaryMap() {
        guard let walkingController = walkingController else {
            return
        }
        guard walkingController.arrTrack.count > 0 else { return }
        
        let arrTrack = walkingController.arrTrack
        
        var lat1 = Double(arrTrack.first?.location?.coordinate.latitude ?? 0)
        var lon1 = Double(arrTrack.first?.location?.coordinate.longitude ?? 0)
        var lat2 = Double(arrTrack.last?.location?.coordinate.latitude ?? 0)
        var lon2 = Double(arrTrack.last?.location?.coordinate.longitude ?? 0)
        for tr in arrTrack {
            let lat = Double(tr.location?.coordinate.latitude ?? 0)
            let lon = Double(tr.location?.coordinate.longitude ?? 0)
            if (lat < lat1) { lat1 = lat }
            if (lon < lon1) { lon1 = lon }
            if (lat > lat2) { lat2 = lat }
            if (lon > lon2) { lon2 = lon }
        }
        let latLng1 = NMGLatLng(lat: lat1, lng: lon1)
        let latLng2 = NMGLatLng(lat: lat2, lng: lon2)
        let bounds = NMGLatLngBounds(southWest: latLng1, northEast: latLng2)
        let cameraUpdate = NMFCameraUpdate.init(fit: bounds, padding: 100)
        mapView.moveCamera(cameraUpdate)
    }

    // MARK: - Location
    var startMarker: NMFMarker!
    var endMarker: NMFMarker!

    var pathOverlay: NMFPath!
//    var arrTrack: Array<Track>!
//    var movePathDist: Double = 0

//    override func updateCurrLocation(_ locations: [CLLocation]) {
    func updateCurrLocation(_ locations: [CLLocation]) {
//        super.updateCurrLocation(locations)

        guard let recentLoc = locations.last else { return }
        guard let walkingController = walkingController else {
            return
        }
        
        if (walkingController.locationReqType == 1) {
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: recentLoc.coordinate.latitude, lng: recentLoc.coordinate.longitude), zoomTo: mapZoomLevel)
            cameraUpdate.animation = .none
//            cameraUpdate.animationDuration = 1
            mapView.moveCamera(cameraUpdate)
            loadMapCameraData()
            

        } else if (walkingController.locationReqType == 2) {
            if (startMarker == nil) {
                startMarker = NMapViewController.getTextMarker(loc: NMGLatLng(lat: recentLoc.coordinate.latitude, lng: recentLoc.coordinate.longitude), text: "출발", forceShow: false)
                startMarker.mapView = self.naverMapView.mapView
            } else {

            }

            let track = Track()
            track.location = recentLoc
            track.event = .non
            
            
            if (walkingController.arrTrack.count > 0) {
                guard let location = walkingController.arrTrack.last?.location else {
                    return
                }
                if (location.distance(from: track.location!) >= 10) {
//                    arrTrack.append(track)
                    walkingController.addTrack(track: track);

//                    movePathDist += arrTrack[arrTrack.count - 1].location!.distance(from: arrTrack[arrTrack.count - 2].location!)
                    walkingController.movePathDist += walkingController.moveDistance();

                    let arrTrack = walkingController.arrTrack
                    if (arrTrack.count == 2) {
                        pathOverlay.path = NMGLineString(points: [
                            NMGLatLng(lat: arrTrack[0].location!.coordinate.latitude, lng: arrTrack[0].location!.coordinate.longitude),
                            NMGLatLng(lat: arrTrack[1].location!.coordinate.latitude, lng: arrTrack[1].location!.coordinate.longitude)])
                        pathOverlay.mapView = mapView

                    } else if (arrTrack.count > 2) {
                        guard let coordinate = walkingController.arrTrack.last?.location?.coordinate else {
                            return
                        }

                        if pathOverlay != nil {
                            let path = pathOverlay.path
                            path.addPoint(NMGLatLng(lat: coordinate.latitude, lng: coordinate.longitude))
                            pathOverlay.path = path
                            pathOverlay.mapView = mapView
                        }
                    }
                }

            } else {
//                arrTrack.append(track)
//                movePathDist = 0
                walkingController.addTrack(track: track);
                walkingController.movePathDist = 0

                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
                    self.stopLoading()

                    self.refreshMoveInfoStart()
                })
            }
        }

        // let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: locationManager.location?.coordinate.latitude ?? 0, lng: locationManager.location?.coordinate.longitude ?? 0))
        // cameraUpdate.animation = .easeIn
        // mapView.moveCamera(cameraUpdate)
    }

    static func getTextMarker(loc: NMGLatLng, text: String, forceShow: Bool) -> NMFMarker {
        let marker = NMFMarker()
        marker.captionText = text
        marker.captionOffset = -39
        // marker.captionColor = UIColor.white
        marker.captionTextSize = 12
        marker.position = loc
        marker.iconImage = NMFOverlayImage(image: UIImage(named: "marker_start")!)
        marker.width = 37.5
        marker.height = 50

        if (forceShow == true) {
            marker.isForceShowIcon = true
            marker.isForceShowCaption = true
        } else {
            marker.isHideCollidedMarkers = true
        }

        return marker
    }

    // MARK: - Move Timer (Distance, TimeSec)
//    var movedSec: Double = 0
//    var movedDist: Double = 0

    override func endAppearanceTransition() {
        if isBeingDismissed {
            refreshMoveInfoStop(isSafeStop: false)
        }
        super.endAppearanceTransition()
    }

    func refreshMoveInfoStart() {
        refreshMoveInfoStop(isSafeStop: true)

        walkingController?.movedSec = 0
        walkingController?.movedDist = 0
        walkingController?.refreshMoveInfoStart();

        self.mapTopView.hideMapTipView()
        self.mapTopView.showMapNavView()
        self.mapTopView.mapNavView?.timeLabel.text = "00:00:00"
        self.mapTopView.mapNavView?.distLabel.text = "0.00 km"

        btnPee.isHidden = false
        btnPoo.isHidden = false
        btnMrk.isHidden = false
    }

    func refreshMoveInfoPause() {

    }

    func refreshMoveInfoStop(isSafeStop: Bool) {
        
        walkingController?.refreshMoveInfoStop()

        if (isSafeStop == false) {
            self.mapTopView.hideMapNavView()
            self.mapTopView.showMapTipView()

            btnPee.isHidden = true
            btnPoo.isHidden = true
            btnMrk.isHidden = true
        }
    }

    func statusViewTimerCallback() {
        if UIApplication.shared.applicationState != .background {
            refreshMoveInfoView()
        }
    }

    func refreshMoveInfoData() {
        walkingController?.refreshMoveInfoData()
    }
    
    func refreshMoveInfoView() {
        guard let movedSec = walkingController?.movedSec, let movedDist = walkingController?.movedDist else {
            return
        }
        
        let seconds: UInt = UInt(movedSec)
        let minutes = seconds / 60
        let hours = minutes / 60
        let strMovedTime = String(format: "%02d:%02d:%02d", hours, minutes % 60, seconds % 60)
        self.mapTopView.mapNavView?.timeLabel.text = String(strMovedTime)

        let distKm: Double = movedDist / Double(1000)
        self.mapTopView.mapNavView?.distLabel.text = String(format: "%.2f km", distKm)

        if (mapBottomView != nil) {
            mapBottomView.refresh(time: strMovedTime, dist: String(format: "%.2f km", distKm))
        }
    }

    // MARK: - EventMark
    var arrEventMarker: Array<NMFMarker>? = nil

    enum EventMark: Int {
        case PEE
        case POO
        case MRK
        case IMG
    }

    static var markerPeeImg: UIImage? = nil
    static var markerpooImg: UIImage? = nil
    static var markerMrkImg: UIImage? = nil
    static var markerPicImg: UIImage? = nil

    static func getEventMarker(loc: NMGLatLng, event: EventMark) -> NMFMarker {
        var markerImg: UIImage? = nil
        if (event == .PEE) {
            if (markerPeeImg == nil) {
                markerPeeImg = NMapViewController.getEventMarkerImg(event: event)
                markerImg = markerPeeImg
            } else {
                markerImg = markerPeeImg
            }
        } else if (event == .POO) {
            if (markerpooImg == nil) {
                markerpooImg = NMapViewController.getEventMarkerImg(event: event)
                markerImg = markerpooImg
            } else {
                markerImg = markerpooImg
            }
        } else if (event == .MRK) {
            if (markerMrkImg == nil) {
                markerMrkImg = NMapViewController.getEventMarkerImg(event: event)
                markerImg = markerMrkImg
            } else {
                markerImg = markerMrkImg
            }
        } else if (event == .IMG) {
            if (markerPicImg == nil) {
                markerPicImg = NMapViewController.getEventMarkerImg(event: event)
                markerImg = markerPicImg
            } else {
                markerImg = markerPicImg
            }
        }

        let marker = NMFMarker()
        marker.position = loc
        marker.iconImage = NMFOverlayImage(image: markerImg!)
        marker.width = 33
        marker.height = 33
        marker.anchor = CGPoint(x: 0.5, y: 0.5)

        return marker
    }

    static func getEventMarkerImg(event: EventMark) -> UIImage? {
        var bgColor: UIColor? = nil
        var innerImg: UIImage? = nil
        if (event == .PEE) {
            bgColor = UIColor(hex: "#FFEEBF00")
            innerImg = UIImage(named: "marker_pee")
        } else if (event == .POO) {
            bgColor = UIColor(hex: "#FF956A5C")
            innerImg = UIImage(named: "marker_poop")
        } else if (event == .MRK) {
            bgColor = UIColor(hex: "#FF4AB0F5")
            innerImg = UIImage(named: "marker_marking")
        } else if (event == .IMG) {
            bgColor = UIColor(hex: "#FFFFFFFF")
            innerImg = UIImage(named: "icon_camera")
        }

        if (innerImg != nil)
        {
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: 28, height: 28))
            let image = renderer.image { ctx in
                ctx.cgContext.setFillColor(bgColor!.cgColor)
                ctx.cgContext.addEllipse(in: CGRect(x: 0, y: 0, width: 28, height: 28))
                ctx.cgContext.drawPath(using: .fill)
                ctx.cgContext.draw(innerImg!.cgImage!, in: CGRect(x: 6, y: 6, width: 16, height: 16), byTiling: false)
            }

            return image.rotate(radians: .pi)
        }

        return nil
    }

    // MARK: - MapBottomViewProtocol
    func mapBottomViewOnExit() {
        stopWalkingProcess()

        bottomSheetVC?.hideBottomSheetAndGoBack()
        bottomSheetVC = nil

        mapBottomView = nil

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.performSegue(withIdentifier: "showPost", sender: self)
        })
    }

    func mapBottomViewOnContinue() {
        bottomSheetVC?.hideBottomSheetAndGoBack()
        bottomSheetVC = nil

        mapBottomView = nil
        
        // ZoomLevel을 이전으로 되돌린다
        loadMapCameraData()
    }
    
    func loadMapCameraData() {
        DispatchQueue.main.async {
            self.mapView.zoomLevel = self.mapZoomLevel
            self.mapView.positionMode = self.mapPositionMode
        }
    }

    func saveMapCameraData() {
        mapZoomLevel = mapView.zoomLevel
        mapPositionMode = mapView.positionMode
    }



    // MARK: - CAMERA
    @IBOutlet weak var btnCamera: UIButton!
    @IBAction func onBtnCamera(_ sender: Any) {
        #if targetEnvironment(simulator)
            //fatalError()
            self.showToast(msg: "Simulator에서는 카메라가 동작하지 않아요")
            return
        #endif

        guard let walkingController = walkingController else { return }
        
        if walkingController.arrImageFromCamera.count >= 5 {
            showToast(msg: "사진은 최대 5장까지만 가능해요")
            return
        }

        AVCaptureDevice.requestAccess(for: .video) { [weak self] isAuthorized in
            guard isAuthorized else {
                self?.showAlertGoToSetting()
                return
            }
        }

        DispatchQueue.main.async {
            let pickerController = UIImagePickerController() // must be used from main thread only
            pickerController.sourceType = .camera
            pickerController.allowsEditing = false
            pickerController.mediaTypes = ["public.image"]
            // 만약 비디오가 필요한 경우,
            //      imagePicker.mediaTypes = ["public.movie"]
            //      imagePicker.videoQuality = .typeHigh
            pickerController.delegate = self
            self.present(pickerController, animated: true)
        }
    }

    func showAlertGoToSetting() {
        let alertController = UIAlertController(
            title: "현재 카메라 사용에 대한 접근 권한이 없습니다.",
            message: "설정 > {앱 이름}탭에서 접근을 활성화 할 수 있습니다.",
            preferredStyle: .alert
        )
        let cancelAlert = UIAlertAction(
            title: "취소",
            style: .cancel
        ) { _ in
            alertController.dismiss(animated: true, completion: nil)
        }
        let goToSettingAlert = UIAlertAction(
            title: "설정으로 이동하기",
            style: .default) { _ in
            guard
                let settingURL = URL(string: UIApplication.openSettingsURLString),
                UIApplication.shared.canOpenURL(settingURL)
                else { return }
            UIApplication.shared.open(settingURL, options: [:])
        }
        [cancelAlert, goToSettingAlert]
            .forEach(alertController.addAction(_:))
        DispatchQueue.main.async {
            self.present(alertController, animated: true) // must be used from main thread only
        }
    }

    // MARK: - NEXT PAGE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showPost") {
            let dest = segue.destination
            guard let vc = dest as? WalkPostViewController else { return }
            guard let walkingController = walkingController else { return }
            
            // vc.mapSnapImg = _mapSnapImg
            vc.arrImageFromCamera = walkingController.arrImageFromCamera
            vc.arrTrack = walkingController.arrTrack
            vc.movedSec = walkingController.movedSec
            vc.movedDist = walkingController.movedDist
            vc.selectedPets = selectedPets
        }
    }
}

extension NMapViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            picker.dismiss(animated: true)
            return
        }
        
        guard let walkingController = walkingController else { return }
        walkingController.arrImageFromCamera.append(image)
        selectEventMarkPet(mark: .IMG)

        picker.dismiss(animated: true, completion: nil)
        // // 비디오인 경우 - url로 받는 형태
        // guard let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL else {
        //     picker.dismiss(animated: true, completion: nil)
        //     return
        // }
        // let video = AVAsset(url: url)
    }
}
