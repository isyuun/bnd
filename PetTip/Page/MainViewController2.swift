//
//  MainViewController.swift
//  PetTip
//
//  Created by carebiz on 12/2/23.
//

import UIKit

class MainViewController2: MainViewController {
    override func viewDidLoad() {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][\(Global.userNckNm)][\(Global.myPetList)][\(Global.dailyLifePets)]")
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][\(Global.userNckNm)][\(Global.myPetList)][\(Global.dailyLifePets)]")
        super.viewDidAppear(animated)
        initRx()
    }

    override func initRx() {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][\(Global.userNckNm)][\(Global.myPetList)][\(Global.dailyLifePets)]")
        super.initRx()
    }

    override func requestPageData() {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][\(Global.userNckNm)][\(Global.myPetList)][\(Global.dailyLifePets)]")
        super.requestPageData()
    }

    override func dailyLife_PetList() {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][\(Global.userNckNm)][\(Global.myPetList)][\(Global.dailyLifePets)]")
        super.dailyLife_PetList()
    }

    override func myPet_list() {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][\(Global.userNckNm)][\(Global.myPetList)][\(Global.dailyLifePets)]")
        super.myPet_list()
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
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][\(Global.userNckNm)][\(Global.myPetList)][\(Global.dailyLifePets)]")
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][myPetList:\(String(describing: myPetList))][count:\(String(describing: myPetList?.myPets.count))][\(String(describing: myPetList?.myPets))]")
        // super.showCompPetListBottomSheet()

        guard let dailyLifePets = self.dailyLifePets else {
            self.showToast(msg: "등록된 펫이 없습니다.")
            return
        }

        let pets = dailyLifePets.pets

        if (pets.count == 0) {
            self.showToast(msg: "등록된 펫이 없습니다.")
            return
        }

        bottomSheetVC = BottomSheetViewController()
        bottomSheetVC.modalPresentationStyle = .overFullScreen
        bottomSheetVC.dismissIndicatorView.isHidden = true
        bottomSheetVC.isDynamicHeight = true
        if let v = UINib(nibName: "CompPetListView", bundle: nil).instantiate(withOwner: self).first as? CompPetListView {
            bottomSheetVC.addContentSubView(v: v)
            v.initialize()
            v.setData(pets as Any)
            v.setDelegate(self)
            compPetListView = v
            if pets.count > 0 { v.tableView.selectRow(at: NSIndexPath(row: 0, section: 0) as IndexPath, animated: false, scrollPosition: .none) }
        }
        self.present(bottomSheetVC, animated: false, completion: nil)
    }
}
