//
//  InviteSetKeyViewController2.swift
//  PetTip
//
//  Created by isyuun on 2024/4/30.
//

import UIKit

class InviteSetKeyViewController2: InviteSetKeyViewController {
    func myPet_list() {
        self.startLoading()

        let request = MyPetListRequest(userId: UserDefaults.standard.value(forKey: "userId")! as! String)
        MyPetAPI.list(request: request) { myPetList, error in
            self.stopLoading()

            if let myPetList = myPetList {
                Global.myPetListBehaviorRelay.accept(myPetList)

                self.dailyLife_PetList()
            }

            self.processNetworkError(error)
        }
    }

    func dailyLife_PetList() {
        self.startLoading()

        let request = PetListRequest(userId: UserDefaults.standard.value(forKey: "userId")! as! String)
        DailyLifeAPI.petList(request: request) { petList, error in
            self.stopLoading()

            if let petList = petList {
                Global.dailyLifePetsBehaviorRelay.accept(petList)
                Global.selectedPetIndexBehaviorRelay.accept(0)

                self.onBack()
            }

            if let error = error {
                self.showSimpleAlert(title: "PetList fail", msg: error.localizedDescription)
            }
        }
    }

    override func invtt_setKey(key: String) {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][\(Global.userNckNm)][\(Global.myPetList)][\(Global.dailyLifePets)]")
        super.invtt_setKey(key: key)
    }

    override func invtt_setKey() {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][\(Global.userNckNm)][\(Global.myPetList)][\(Global.dailyLifePets)]")
        super.invtt_setKey()
        myPet_list()
    }
}
