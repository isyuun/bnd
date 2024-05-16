//
//  MainViewController.swift
//  PetTip
//
//  Created by carebiz on 12/2/23.
//

import UIKit

class MainViewController2: MainViewController {
    override func viewDidAppear(_ animated: Bool) {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][\(Global.userNckNm)][\(Global.myPetList)][\(Global.dailyLifePetList)]")
        super.viewDidAppear(animated)
        initRx()
    }

    override func initRx() {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][\(Global.userNckNm)][\(Global.myPetList)][\(Global.dailyLifePetList)]")
        super.initRx()
    }

    override func refreshMyPetList(data: MyPetList?) {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][data:\(String(describing: data))]")
        super.refreshMyPetList(data: data)
    }

    override func refreshDailyLifePetList(data: PetList?) {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][data:\(String(describing: data))]")
        super.refreshDailyLifePetList(data: data)
    }

    override func showCompPetListBottomSheet() {
        // NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][\(Global.userNckNm)][\(Global.myPetList)][\(Global.dailyLifePetList)]")
        // NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][myPetList:\(String(describing: myPetList))][count:\(String(describing: myPetList?.myPets.count))][myPets:\(String(describing: myPetList?.myPets))]")
        // NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][dailyLifePetList:\(String(describing: dailyLifePetList))][count:\(String(describing: myPetList?.myPets.count))][pets:\(String(describing: dailyLifePetList?.pets))]")
        super.showCompPetListBottomSheet()

        let myPetList: MyPetList? = self.myPetList

        if(myPetList == nil) {
            self.showSimpleAlert(msg: "등록된 펫이 없습니다.")
            return
        }

        if (myPetList?.myPets.count == 0) {
            self.showSimpleAlert(msg: "등록된 펫이 없습니다.")
            return
        }

        var myPets = [MyPet]()

        myPetList?.myPets.forEach { myPet in
            switch (myPet.mngrType) {
            case "M": //관리중
                NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][myPet:\(myPet)]")
                myPets.append(myPet)
                break
            case "I": //참여중
                NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][myPet:\(myPet)]")
                myPets.append(myPet)
                break
            case "C": //동행중단
                break
            default:
                break
            }
        }

        myPetList?.myPets.forEach { myPet in
            NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][petNm:\(myPet.petNm)][mngrType:\(myPet.mngrType)][petMngrYn:\(myPet.petMngrYn)]")
        }
        myPetList?.myPets = myPets
        myPetList?.myPets.forEach { myPet in
            NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][petNm:\(myPet.petNm)][mngrType:\(myPet.mngrType)][petMngrYn:\(myPet.petMngrYn)]")
        }

        bottomSheetVC = BottomSheetViewController()
        bottomSheetVC.modalPresentationStyle = .overFullScreen
        bottomSheetVC.dismissIndicatorView.isHidden = true
        bottomSheetVC.isDynamicHeight = true
        if let v = UINib(nibName: "CompPetListView", bundle: nil).instantiate(withOwner: self).first as? CompPetListView {
            bottomSheetVC.addContentSubView(v: v)
            v.initialize()
            v.setData(myPets)
            v.setDelegate(self)
            compPetListView = v
            if myPets.count > 0 { v.tableView.selectRow(at: NSIndexPath(row: 0, section: 0) as IndexPath, animated: false, scrollPosition: .none) }
        }
        self.present(bottomSheetVC, animated: false, completion: nil)
    }
}
