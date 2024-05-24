//
//  MainViewController4.swift
//  PetTip
//
//  Created by isyuun on 2024/5/23.
//

import UIKit
import CoreLocation

class MainViewController4: MainViewController3 {

    override func viewDidLoad() {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)]")
        super.viewDidLoad()

        if let key = Global.invttKeyVl, key.count == 6 {
            invitation(key: key)
        }
    }

    override func dailyLife_PetList() {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)]")
        super.dailyLife_PetList()
    }

    override func myPet_list() {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)]")
        //self.startLoading()

        let request = MyPetListRequest(userId: UserDefaults.standard.value(forKey: "userId")! as! String)
        MyPetAPI.list(request: request) { myPetList, error in
            self.stopLoading()

            if let myPetList = myPetList {
                Global.myPetListBehaviorRelay.accept(myPetList)
            }

            self.processNetworkError(error)
        }
    }

    override func story_realTimeList() {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)]")
        super.story_realTimeList()
    }

    override func requestLocation(type: Int) {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][type:\(type)]")
        super.requestLocation(type: type)
    }

    override func startContinueLocation() {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)]")
        super.startContinueLocation()
    }

    override func updateCurrLocation(_ locations: [CLLocation]) {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][locations:\(locations)]")
        super.updateCurrLocation(locations)
    }
}
