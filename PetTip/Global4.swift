//
//  Global4.swift
//  PetTip
//
//  Created by isyuun on 2024/5/10.
//

import Foundation

class Global4: Global3 {
    func myPet_list() {
        //self.startLoading()
    
        let request = MyPetListRequest(userId: UserDefaults.standard.value(forKey: "userId")! as! String)
        MyPetAPI.list(request: request) { myPetList, error in
            // self.stopLoading()
    
            if let myPetList = myPetList {
                Global.myPetListBehaviorRelay.accept(myPetList)
            }
    
            // self.processNetworkError(error)
        }
    }
    
    func dailyLife_PetList() {
        //self.startLoading()
    
        let request = PetListRequest(userId: UserDefaults.standard.value(forKey: "userId")! as! String)
        DailyLifeAPI.petList(request: request) { petList, error in
            // self.stopLoading()
    
            if let petList = petList {
                Global.dailyLifePetListBehaviorRelay.accept(petList)
                Global.selectedPetIndexBehaviorRelay.accept(0)
            }
    
            // self.processNetworkError(error)
        }
    }
}
