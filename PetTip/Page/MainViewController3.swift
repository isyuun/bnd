//
//  MainViewController3.swift
//  PetTip
//
//  Created by isyuun on 2024/5/21.
//

import UIKit
import FSPagerView

class MainViewController3: MainViewController2 {

    override func viewWillAppear(_ animated: Bool) {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][selectedPetIndex:\(selectedPetIndex)]")
        super.viewWillAppear(animated)
        self.refreshSelectedPetIndex(data: self.selectedPetIndex)
    }

    override func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        self.selectedPetIndex = index
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][index:\(index)][selectedPetIndex:\(selectedPetIndex)]")
        super.pagerView(pagerView, didSelectItemAt: index)
        self.refreshSelectedPetIndex(data: index)
    }

    override func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        self.selectedPetIndex = targetIndex
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][targetIndex:\(targetIndex)][selectedPetIndex:\(selectedPetIndex)]")
        super.pagerViewWillEndDragging(pagerView, targetIndex: targetIndex)
    }

    override func refreshSelectedPetIndex(data: Int?) {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][data:\(String(describing: data))][selectedPetIndex:\(selectedPetIndex)]")
        guard let index = data else { return }

        self.pagerView.reloadData()

        if let petList = self.dailyLifePetList {
            if (petList.pets.count > 0) {
                Global.petRelUnqNo = petList.pets[index].petRelUnqNo

                let pet = petList.pets[index]
                Global2.setPetImage(imageView: self.titleBarPfImageView, petTypCd: pet.petTypCd, petImgAddr: pet.petRprsImgAddr)

                self.titleBarPfNMLabel.text = petList.pets[index].petNm

                self.lbCurrPetKind.text = petList.pets[index].petKindNm
                self.lbCurrPetNm.text = petList.pets[index].petNm

                self.ageLabel.text = petList.pets[index].age
                self.genderLabel.text = petList.pets[index].sexTypNm
                self.weightLabel.text = String(format: "%.1fkg", Float(petList.pets[index].wghtVl))

                self.currPetNMLabel.text = petList.pets[index].petNm

                self.requestCurrPetWeekData(petList.pets[index].ownrPetUnqNo)

            } else {
                self.titleBarPfImageView.image = UIImage(named: "profile_default")
                self.titleBarPfNMLabel.text = "등록된 펫 없음"

                self.lbCurrPetKind.text = ""
                self.lbCurrPetNm.text = "등록된 펫 없음"

                self.currPetNMLabel.text = "댕댕이"

                self.ageLabel.text = "-"
                self.genderLabel.text = "-"
                self.weightLabel.text = "-"

                self.totalWalkTimeLabel.text = "00:00:00"
                self.totalWalkDistLabel.text = "0.0km"
            }
        }

        if (self.selectIdxFromPrevPage == false) {
            self.walkHistoryViewController?.selectIdxFromPrevPage = true
            self.walkHistoryViewController?.dailyLifePetList = self.dailyLifePetList
        } else {
            self.selectIdxFromPrevPage = false
        }
    }
}
