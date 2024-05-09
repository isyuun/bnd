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

        guard let petInfo = self.petInfo else { return }
        Global2.setPetImage(imageView: self.iv_profile, pet: petInfo)
    }
}
