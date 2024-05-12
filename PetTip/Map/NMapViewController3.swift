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
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][naverMapView:\(String(describing: naverMapView))]")
        super.viewDidLoad()

        btnLocation.layer.cornerRadius = 2.0
        btnLocation.layer.borderColor = UIColor.init(hexCode: "e3e9f2").cgColor
        btnLocation.layer.borderWidth = 1
        btnLocation.layer.backgroundColor = UIColor.white.cgColor
        btnLocation.setImage(UIImage(named: "icon-gps1-bgx"), for: .normal)
        btnLocation.setTitle("", for: .normal)
        btnLocation.showShadowLight()
    }

    @IBOutlet weak var btnLocation: UIButton!
    @IBAction func onBtnLocation(_ sender: Any) {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][sender:\(String(describing: sender))]")
    }
}
