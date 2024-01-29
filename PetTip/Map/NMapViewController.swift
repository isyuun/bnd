//
//  NMapViewController.swift
//  PetTip
//
//  Created by carebiz on 11/23/23.
//

import UIKit
import NMapsMap

class NMapViewController : LocationViewController, MapBottomViewProtocol {
    
    @IBOutlet weak var naverMapView: NMFNaverMapView!
    var mapView: NMFMapView {
        return naverMapView.mapView
    }
    
    @IBOutlet weak var zoomControlView: NMFZoomControlView!
    @IBOutlet weak var locationButton: NMFLocationButton!
    
    @IBOutlet weak var mapTopView : MapTopView!
    
    var bWalkingState = false
    
    var bottomSheetVC : BottomSheetViewController! = nil
    var mapBottomView : MapBottomView! = nil
    
    var mapSnapImg : UIImage? = nil
    
    @IBOutlet weak var btnWalk: UIButton!
    @IBAction func onBtnWalk(_ sender: Any) {
        if (bWalkingState == true) {
            showTrackSummaryMap()
            
            naverMapView.takeSnapshot(withShowControls: false, complete: {[weak self] (image) in
                self?.mapSnapImg = image
            })
            
            bottomSheetVC = BottomSheetViewController()
            bottomSheetVC.modalPresentationStyle = .overFullScreen
            bottomSheetVC.dismissIndicatorView.isHidden = true
            if let v = UINib(nibName: "MapBottomView", bundle: nil).instantiate(withOwner: self).first as? MapBottomView {
                bottomSheetVC.addContentSubView(v: v)
                v.initialize()
                v.setDelegate(self)
                mapBottomView = v
            }
            self.present(bottomSheetVC, animated: false, completion: nil)
            
        } else {
            startWalkingProcess()
        }
    }
    
    private func startWalkingProcess() {
        bWalkingState = true
        
        btnWalk.tintColor = UIColor.black
        btnWalk.setAttrTitle("산책종료", 14)
        
        startContinueLocation()
        
        pathOverlay = NMFPath()
        pathOverlay.width = 6
        pathOverlay.color = UIColor(hex: "#A0FFDBDB")!
        pathOverlay.outlineWidth = 2
        pathOverlay.outlineColor = UIColor(hex: "#A0FF5000")!
        pathOverlay.mapView = mapView
        
        arrTrack = Array<Track>()
        
        startLoading(msg: "위치정보 확인중")
    }
    
    private func stopWalkingProcess() {
        bWalkingState = false
        
        btnWalk.tintColor = UIColor.init(hexCode: "4783F5")
        btnWalk.setAttrTitle("산책하기", 14)
        
        stopContinueLocation()
        
        if (startMarker != nil) { startMarker.mapView = nil }
        startMarker = nil
        if (endMarker != nil) { endMarker.mapView = nil; }
        endMarker = nil
        
        pathOverlay.mapView = nil
        pathOverlay = nil
        
        if let arrMarker = arrEventMarker {
            for marker in arrMarker {
                marker.mapView = nil
            }
        }
        
        refreshMoveInfoStop(isSafeStop: false)
    }
    
    @IBOutlet weak var btnCamera: UIButton!
    @IBAction func onBtnCamera(_ sender: Any) {
    }
    
    @IBOutlet weak var btnList: UIButton!
    @IBAction func onBtnList(_ sender: Any) {
    }
    
    @IBOutlet weak var btnPee: UIButton!
    @IBAction func onBtnPee(_ sender: Any) {
        if (arrTrack != nil && arrTrack.last != nil && arrTrack.last?.location != nil) {
            let eventMarker = getEventMarker(loc: NMGLatLng(lat: arrTrack.last!.location!.coordinate.latitude, lng: arrTrack.last!.location!.coordinate.longitude), event: .PEE)
            eventMarker.mapView = self.mapView
            
            let track = Track()
            track.location = arrTrack.last?.location
            track.event = .pee
            arrTrack.append(track)
            
            if (arrEventMarker == nil) {
                arrEventMarker = Array<NMFMarker>()
            }
            arrEventMarker?.append(eventMarker)
        }
    }
    
    @IBOutlet weak var btnPoo: UIButton!
    @IBAction func onBtnPoo(_ sender: Any) {
        if (arrTrack != nil && arrTrack.last != nil && arrTrack.last?.location != nil) {
            let eventMarker = getEventMarker(loc: NMGLatLng(lat: arrTrack.last!.location!.coordinate.latitude, lng: arrTrack.last!.location!.coordinate.longitude), event: .POO)
            eventMarker.mapView = self.mapView
            
            let track = Track()
            track.location = arrTrack.last?.location
            track.event = .poo
            arrTrack.append(track)
            
            if (arrEventMarker == nil) {
                arrEventMarker = Array<NMFMarker>()
            }
            arrEventMarker?.append(eventMarker)
        }
    }
    
    @IBOutlet weak var btnMrk: UIButton!
    @IBAction func onBtnMrk(_ sender: Any) {
        if (arrTrack != nil && arrTrack.last != nil && arrTrack.last?.location != nil) {
            let eventMarker = getEventMarker(loc: NMGLatLng(lat: arrTrack.last!.location!.coordinate.latitude, lng: arrTrack.last!.location!.coordinate.longitude), event: .MRK)
            eventMarker.mapView = self.mapView
            
            let track = Track()
            track.location = arrTrack.last?.location
            track.event = .mrk
            arrTrack.append(track)
            
            if (arrEventMarker == nil) {
                arrEventMarker = Array<NMFMarker>()
            }
            arrEventMarker?.append(eventMarker)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.tabBar.isHidden = true
        
        mapView.mapType = .navi
        mapView.isNightModeEnabled = traitCollection.userInterfaceStyle == .dark ? true : false  // default:false
        mapView.positionMode = .direction
        mapView.zoomLevel = 17
        mapView.minZoomLevel = 5.0
        mapView.maxZoomLevel = 18.0
        
//        mapView.locationOverlay.icon = NMFOverlayImage(name: "currentLocation")
//        mapView.locationOverlay.iconWidth = CGFloat(NMF_LOCATION_OVERLAY_SIZE_AUTO)
//        mapView.locationOverlay.iconHeight = CGFloat(NMF_LOCATION_OVERLAY_SIZE_AUTO)
        
//        mapView.locationOverlay.subIcon = NMFOverlayImage(name: "currentLocation")
//        mapView.locationOverlay.subIconWidth = 40
//        mapView.locationOverlay.subIconHeight = 40
////        mapView.locationOverlay.subAnchor = CGPoint(x: 0.4, y: 0.4)
//        mapView.locationOverlay.subAnchor = CGPoint(x: 0.5, y: 1)
        
//        mapView.locationOverlay.circleColor = UIColor.red
        
//        let circleOverlay = NMFCircleOverlay(NMGLatLng(lat: 37.5666102, lng: 126.9783881), radius: 500)                            // 원 위치 및 반지름을 설정합니다.
//        circleOverlay.fillColor = .lightGray        // 원 내부 색을 설정합니다.
//        circleOverlay.outlineColor = .red           // 원 테두리 색을 설정합니다.
//        circleOverlay.outlineWidth = 3              // 원 테두리 두께를 설정합니다.
//        circleOverlay.mapView = naverMapView.mapView
             
        naverMapView.showCompass = false
        naverMapView.showIndoorLevelPicker = true
        
        naverMapView.showZoomControls = false
        zoomControlView.mapView = naverMapView.mapView;
        
        naverMapView.showLocationButton = false;
        locationButton.mapView = naverMapView.mapView;
        
//        mapView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        
        btnWalk.layer.cornerRadius = 10.0
        btnWalk.tintColor = UIColor.init(hexCode: "4783F5")
        btnWalk.setAttrTitle("산책하기", 14)
        btnWalk.showShadowMid()
        
        btnCamera.layer.cornerRadius = 2.0
        btnCamera.layer.borderColor = UIColor.init(hexCode: "e3e9f2").cgColor
        btnCamera.layer.borderWidth = 1
        btnCamera.layer.backgroundColor = UIColor.white.cgColor
        btnCamera.setImage(UIImage(named: "icon_camera"), for:.normal)
        btnCamera.setTitle("", for: .normal)
        btnCamera.showShadowLight()
        
        btnList.layer.cornerRadius = 2.0
        btnList.layer.borderColor = UIColor.init(hexCode: "e3e9f2").cgColor
        btnList.layer.borderWidth = 1
        btnList.layer.backgroundColor = UIColor.white.cgColor
        btnList.setImage(UIImage(named: "icon_list"), for:.normal)
        btnList.setTitle("", for: .normal)
        btnList.showShadowLight()
        
        btnPee.layer.cornerRadius = btnPee.layer.bounds.width / 2
        btnPee.layer.borderColor = UIColor.init(hexCode: "e3e9f2").cgColor
        btnPee.layer.borderWidth = 1
        btnPee.layer.backgroundColor = UIColor.white.cgColor
        btnPee.setImage(UIImage(named: "icon_pee"), for:.normal)
        btnPee.setTitle("", for: .normal)
        btnPee.showShadowLight()
        btnPee.isHidden = true
        
        btnPoo.layer.cornerRadius = btnPoo.layer.bounds.width / 2
        btnPoo.layer.borderColor = UIColor.init(hexCode: "e3e9f2").cgColor
        btnPoo.layer.borderWidth = 1
        btnPoo.layer.backgroundColor = UIColor.white.cgColor
        btnPoo.setImage(UIImage(named: "icon_poop"), for:.normal)
        btnPoo.setTitle("", for: .normal)
        btnPoo.showShadowLight()
        btnPoo.isHidden = true
        
        btnMrk.layer.cornerRadius = btnMrk.layer.bounds.width / 2
        btnMrk.layer.borderColor = UIColor.init(hexCode: "e3e9f2").cgColor
        btnMrk.layer.borderWidth = 1
        btnMrk.layer.backgroundColor = UIColor.white.cgColor
        btnMrk.setImage(UIImage(named: "icon_marking"), for:.normal)
        btnMrk.setTitle("", for: .normal)
        btnMrk.showShadowLight()
        btnMrk.isHidden = true
        
        requestLocation(type: 1)
        
        self.mapTopView.showMapTipView()
        
        
        // testCode...
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
            //self.mapTopView.showMapNavView()
        })
        // testCode...
    }
    
    func showTrackSummaryMap() {
        if (arrTrack == nil || arrTrack.count <= 0) { return }
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
    
    var startMarker : NMFMarker!
    var endMarker : NMFMarker!
    
    var pathOverlay : NMFPath!
    var arrTrack : Array<Track>!
    var movePathDist : Double = 0
    
    override func updateCurrLocation(_ locations: [CLLocation]) {
        super.updateCurrLocation(locations)
        
        guard let recentLoc = locations.last else { return }
        
        if (locationReqType == 1) {
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: recentLoc.coordinate.latitude, lng: recentLoc.coordinate.longitude), zoomTo: 2)
            cameraUpdate.animation = .easeIn
            cameraUpdate.animationDuration = 1
            mapView.moveCamera(cameraUpdate)
            mapView.positionMode = .direction
            
        } else if (locationReqType == 2) {
            if (startMarker == nil) {
                startMarker = getTextMarker(loc: NMGLatLng(lat: recentLoc.coordinate.latitude, lng: recentLoc.coordinate.longitude), text: "출발", forceShow: false)
                startMarker.mapView = self.naverMapView.mapView
            }
            
            let track = Track()
            track.location = recentLoc
            track.event = .non
            
            if (arrTrack != nil && arrTrack.count > 0) {
                if (arrTrack.last!.location!.distance(from: track.location!) >= 10) {
                    arrTrack.append(track)
                 
                    movePathDist += arrTrack[arrTrack.count - 1].location!.distance(from: arrTrack[arrTrack.count - 2].location!)
                    
                    if (arrTrack.count == 2) {
                        pathOverlay.path = NMGLineString(points: [
                            NMGLatLng(lat: arrTrack[0].location!.coordinate.latitude, lng: arrTrack[0].location!.coordinate.longitude),
                            NMGLatLng(lat: arrTrack[1].location!.coordinate.latitude, lng: arrTrack[1].location!.coordinate.longitude) ])
                        pathOverlay.mapView = mapView
                        
                    } else if (arrTrack.count > 2) {
                        let path = pathOverlay.path
                        path.addPoint(NMGLatLng(lat: arrTrack.last!.location!.coordinate.latitude, lng: arrTrack.last!.location!.coordinate.longitude))
                        pathOverlay.path = path
                        pathOverlay.mapView = mapView
                    }
                }
                
            } else {
                arrTrack.append(track)
                movePathDist = 0
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
                    self.stopLoading()
                    
                    self.refreshMoveInfoStart()
                })
            }
        }
        
//        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: locationManager.location?.coordinate.latitude ?? 0, lng: locationManager.location?.coordinate.longitude ?? 0))
//                    cameraUpdate.animation = .easeIn
//                    mapView.moveCamera(cameraUpdate)
    }
    
    func getTextMarker(loc : NMGLatLng, text : String, forceShow : Bool) -> NMFMarker {
        let marker = NMFMarker()
        marker.captionText = text
        marker.captionOffset = -39
//        marker.captionColor = UIColor.white
        marker.captionTextSize = 12
        marker.position = loc
        marker.iconImage = NMFOverlayImage(image: UIImage(named: "marker_start")!)
        marker.width = 37.5;
        marker.height = 50;
        
        if (forceShow == true) {
            marker.isForceShowIcon = true
            marker.isForceShowCaption = true
        } else {
            marker.isHideCollidedMarkers = true
        }
        
        return marker
    }
    
    
    
    
    
    // MARK: - Move Timer (Distance, TimeSec)
    
    var movedSec : Double = 0
    var movedDist : Double = 0
    
    override func viewDidDisappear(_ animated: Bool) {
        refreshMoveInfoStop(isSafeStop: false)
    }

    var statusViewTimer : Timer?
    
    func refreshMoveInfoStart() {
        refreshMoveInfoStop(isSafeStop: true)

        movedSec = 0
        movedDist = 0

        self.mapTopView.hideMapTipView()
        self.mapTopView.showMapNavView()
        self.mapTopView.mapNavView?.timeLabel.text = "00:00:00"
        self.mapTopView.mapNavView?.distLabel.text = "0.00 km"
        
        statusViewTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(statusViewTimerCallback), userInfo: nil, repeats: true)
        
        btnPee.isHidden = false
        btnPoo.isHidden = false
        btnMrk.isHidden = false
    }
    
    func refreshMoveInfoPause() {
        
    }
    
    func refreshMoveInfoStop(isSafeStop : Bool) {
        if (statusViewTimer != nil && statusViewTimer!.isValid) {
            statusViewTimer!.invalidate()
        }
        
        if (isSafeStop == false) {
            self.mapTopView.hideMapNavView()
            self.mapTopView.showMapTipView()
            
            btnPee.isHidden = true
            btnPoo.isHidden = true
            btnMrk.isHidden = true
        }
    }
    
    @objc func statusViewTimerCallback() {
        let state = UIApplication.shared.applicationState
        switch state {
        case .background:
            refreshMoveInfoData()
            break
        
        default:
            refreshMoveInfoData()
            refreshMoveInfoView()
        }
    }
    
    func refreshMoveInfoData() {
        movedSec += 1
        movedDist = movePathDist
    }
    
    func refreshMoveInfoView() {
        let seconds : UInt = UInt(movedSec)
        let minutes = seconds / 60
        let hours = minutes / 60
        let strMovedTime = String(format: "%02d:%02d:%02d", hours, minutes % 60, seconds % 60)
        self.mapTopView.mapNavView?.timeLabel.text = String(strMovedTime)
        
        let distKm : Double = movedDist / Double(1000)
        self.mapTopView.mapNavView?.distLabel.text = String(format: "%.2f km", distKm)
        
        if (mapBottomView != nil) {
            mapBottomView.timeLabel.text = String(strMovedTime)
            mapBottomView.distLabel.text = String(format: "%.2f km", distKm)
        }
    }
    
    
    
    
    
    // MARK: - EventMark
    
    var arrEventMarker : Array<NMFMarker>? = nil
    
    enum EventMark : Int {
        case PEE
        case POO
        case MRK
    }
    
    var markerPeeImg : UIImage? = nil
    var markerpooImg : UIImage? = nil
    var markerMrkImg : UIImage? = nil
    
    func getEventMarker(loc : NMGLatLng, event : EventMark) -> NMFMarker {
        var markerImg : UIImage? = nil
        if (event == .PEE) {
            if (markerPeeImg == nil) {
                markerPeeImg = getEventMarkerImg(event: event)
                markerImg = markerPeeImg
            } else {
                markerImg = markerPeeImg
            }
        } else if (event == .POO) {
            if (markerpooImg == nil) {
                markerpooImg = getEventMarkerImg(event: event)
                markerImg = markerpooImg
            } else {
                markerImg = markerpooImg
            }
        } else if (event == .MRK) {
            if (markerMrkImg == nil) {
                markerMrkImg = getEventMarkerImg(event: event)
                markerImg = markerMrkImg
            } else {
                markerImg = markerMrkImg
            }
        }
        
        let marker = NMFMarker()
        marker.position = loc
        marker.iconImage = NMFOverlayImage(image: markerImg!)
        marker.width = 33;
        marker.height = 33;
        marker.anchor = CGPoint(x: 0.5, y: 0.5)
        
        return marker
    }
    
    func getEventMarkerImg(event : EventMark) -> UIImage? {
        var bgColor : UIColor? = nil
        var innerImg : UIImage? = nil
        if (event == .PEE) {
            bgColor = UIColor(hex: "#FFEEBF00")
            innerImg = UIImage(named: "marker_pee")
        } else if (event == .POO) {
            bgColor = UIColor(hex: "#FF956A5C")
            innerImg = UIImage(named: "marker_poop")
        } else if (event == .MRK) {
            bgColor = UIColor(hex: "#FF4AB0F5")
            innerImg = UIImage(named: "marker_marking")
        }
        
        if (innerImg != nil)
        {
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: 28, height: 28))
            let image = renderer.image { ctx in
                ctx.cgContext.setFillColor(bgColor!.cgColor)
                ctx.cgContext.addEllipse(in: CGRect(x: 0, y: 0, width: 28, height: 28))
                ctx.cgContext.drawPath(using:.fill)
                ctx.cgContext.draw(innerImg!.cgImage!, in: CGRect(x: 6, y: 6, width: 16, height: 16), byTiling: false)
            }
            
            return image.rotate(radians: .pi)
        }
        
        return nil
    }
    
    
    
    
    
    // MARK: - MapBottomViewProtocol
    
    func mapBottomViewOnExit() {
        stopWalkingProcess()
        
        bottomSheetVC.hideBottomSheetAndGoBack()
        bottomSheetVC = nil
        
        mapBottomView = nil
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.performSegue(withIdentifier: "showPost", sender: self)
        })
    }
    
    func mapBottomViewOnContinue() {
        bottomSheetVC.hideBottomSheetAndGoBack()
        bottomSheetVC = nil
        
        mapBottomView = nil
    }
    
    
    
    
    
    // MARK: - NEXT PAGE
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showPost") {
            let dest = segue.destination
            guard let vc = dest as? PostViewController else { return }
            if let _mapSnapImg = mapSnapImg {
                vc.mapSnapImg = _mapSnapImg
            }
        }
    }
}
