//
//  NMapViewController3.swift
//  PetTip
//
//  Created by isyuun on 2024/5/12.
//

import UIKit
import NMapsMap
import AVKit

class NMapViewController3: NMapViewController {

    override func viewDidLoad() {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][naverMapView:\(String(describing: naverMapView))][mapView:\(String(describing: mapView))]")
        super.viewDidLoad()

        btnLocation.layer.cornerRadius = 2.0
        btnLocation.layer.borderColor = UIColor.init(hexCode: "e3e9f2").cgColor
        btnLocation.layer.borderWidth = 1
        btnLocation.layer.backgroundColor = UIColor.white.cgColor
        btnLocation.setImage(UIImage(named: "icon-gps1-bgx"), for: .normal)
        btnLocation.setTitle("", for: .normal)
        btnLocation.showShadowLight()

        mapView.logoInteractionEnabled = true
        mapView.positionMode = .normal

        updateBtnLocation()
    }

    @IBOutlet weak var btnLocation: UIButton!
    @IBAction func onBtnLocation(_ sender: Any) {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][naverMapView.showLocationButton:\(String(describing: naverMapView.showLocationButton))][mapView.positionMode:\(String(describing: mapView.positionMode))]")
        naverMapView.showLocationButton = false

        switch (mapView.positionMode) {
        case .disabled:
            mapView.positionMode = .normal
            break
        case .normal:
            mapView.positionMode = .direction
            break
        case .direction:
            mapView.positionMode = .compass
            break
        case .compass:
            mapView.positionMode = .normal
            break
        default:
            mapView.positionMode = .normal
            break
        }

        updateBtnLocation()
    }

    func updateBtnLocation() {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)]")
        switch (mapView.positionMode) {
        case .disabled:
            btnLocation.setImage(UIImage(named: "icon-gps1"), for: .normal)
            break
        case .normal:
            btnLocation.setImage(UIImage(named: "icon-gps1-bgx"), for: .normal)
            break
        case .direction:
            btnLocation.setImage(UIImage(named: "icon-gps2-bgx"), for: .normal)
            break
        case .compass:
            btnLocation.setImage(UIImage(named: "icon-gps3-bgx"), for: .normal)
            break
        default:
            btnLocation.setImage(UIImage(named: "icon-gps1-bgx"), for: .normal)
            break
        }
    }

    override func updateCurrLocation(_ locations: [CLLocation]) {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][locations:\(locations)]")
        super.updateCurrLocation(locations)
        updateBtnLocation()
    }

    override func startWalkingProcess() {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)]")
        super.startWalkingProcess()
        mapView.positionMode = .direction
        updateBtnLocation()
    }

    override func stopWalkingProcess() {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)]")
        super.stopWalkingProcess()
        mapView.positionMode = .normal
        updateBtnLocation()
    }
}
