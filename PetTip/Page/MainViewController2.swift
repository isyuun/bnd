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
    override func dailyLife_PetList() {
        NSLog("[LOG][W][(\(#fileID):\(#line))::\(#function)]")
        super.dailyLife_PetList()
    }

    override func myPet_list() {
        NSLog("[LOG][W][(\(#fileID):\(#line))::\(#function)]")
        super.myPet_list()
    }
}
