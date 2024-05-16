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

    override func onShowCompPetListBottomSheet(_ sender: Any) {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][\(Global.userNckNm)][\(Global.myPetList)][\(Global.dailyLifePetList)]")
        super.onShowCompPetListBottomSheet(sender)
    }

    override func showCompPetListBottomSheet() {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][\(Global.userNckNm)][\(Global.myPetList)][\(Global.dailyLifePetList)]")
        // NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][myPetList:\(String(describing: myPetList))][count:\(String(describing: myPetList?.myPets.count))][myPets:\(String(describing: myPetList?.myPets))]")
        // NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][dailyLifePetList:\(String(describing: dailyLifePetList))][count:\(String(describing: myPetList?.myPets.count))][pets:\(String(describing: dailyLifePetList?.pets))]")

        let myPetList: MyPetList? = self.myPetList

        if(myPetList == nil) {
            self.showSimpleAlert(msg: "등록된 펫이 정보가 없습니다.")
            return
        }

        if (myPetList?.myPets.count == 0) {
            self.showSimpleAlert(msg: "등록된 펫이 목록이 없습니다.")
            return
        }

        var myPets = [MyPet]()

        myPetList?.myPets.forEach { myPet in
            switch (myPet.mngrType) {
            case "M": //관리중
                myPets.append(myPet)
                break
            case "I": //참여중
                myPets.append(myPet)
                break
            case "C": //동행중단
                break
            default:
                break
            }
        }

        myPets.forEach { myPet in
            NSLog("[LOG][I][myPets][petNm:\(myPet.petNm)][mngrType:\(myPet.mngrType)][petMngrYn:\(myPet.petMngrYn)]")
        }

        self.bottomSheetVC = BottomSheetViewController()
        if let bottomSheetVC = self.bottomSheetVC {
            bottomSheetVC.modalPresentationStyle = .overFullScreen
            bottomSheetVC.dismissIndicatorView.isHidden = true
            bottomSheetVC.isDynamicHeight = true
            if let v = UINib(nibName: "CompPetListView", bundle: nil).instantiate(withOwner: self).first as? CompPetListView2 {
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
}
