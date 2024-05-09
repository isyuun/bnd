//
//  MainViewController.swift
//  PetTip
//
//  Created by carebiz on 12/2/23.
//

import UIKit
import FSPagerView
import CoreLocation
import RxSwift
import RxCocoa
import AlamofireImage

class MainViewController2: MainViewController {
    override func viewDidAppear(_ animated: Bool) {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][\(Global.userNckNm)][\(Global.myPetList)][\(Global.dailyLifePets)]")
        super.viewDidAppear(animated)
        initRx()
    }
}
