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
    }

    override func onBtnCamera(_ sender: Any) {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][sender:\(String(describing: sender))]")
        super.onBtnCamera(sender)
    }

    @IBOutlet weak var btnLocation: UIButton!

    @IBAction func onBtnLocation(_ sender: Any) {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][sender:\(String(describing: sender))]")
    }
}
