//
//  PetProfileViewController2.swift
//  PetTip
//
//  Created by isyuun on 2024/4/29.
//

import UIKit
import AlamofireImage

class PetProfileViewController2: PetProfileViewController {

    override func onAddPetWeight(_ sender: Any) {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][petInfo:\(String(describing: petInfo))][petDetailInfo:\(String(describing: petDetailInfo))]")
        super.onAddPetWeight(sender)
    }

    override func onModifyPetInfo(_ sender: Any) {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][petInfo:\(String(describing: petInfo))][petDetailInfo:\(String(describing: petDetailInfo))]")
        super.onModifyPetInfo(sender)
    }

    override func weight_list() {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][petInfo:\(String(describing: petInfo))][petDetailInfo:\(String(describing: petDetailInfo))]")
        super.weight_list()
    }

    override func showProfileInfo() {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][petInfo:\(String(describing: petInfo))][petDetailInfo:\(String(describing: petDetailInfo))]")
        super.showProfileInfo()

        guard let pet = self.petInfo else { return }
        Global2.setPetImage(imageView: self.iv_profile, petTypCd: pet.petTypCd, petImgAddr: pet.petRprsImgAddr)
    }

    override func initPetWeightGraph() {
        super.initPetWeightGraph()

        // let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        // vw_lineChart.addGestureRecognizer(tapGesture)
    }

    // 탭 제스처 핸들러
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        // 탭된 뷰 확인
        if gesture.view == vw_lineChart {
            // vw_lineChart가 탭되었을 때 수행할 작업 수행
            self.showToast(msg: "길게 누르면 몸무게 수정이 가능합니다.")
        }
    }
}
