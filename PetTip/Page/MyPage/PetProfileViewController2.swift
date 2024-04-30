//
//  PetProfileViewController2.swift
//  PetTip
//
//  Created by isyuun on 2024/4/29.
//

import UIKit

class PetProfileViewController2: PetProfileViewController {
    
    override func onAddPetWeight(_ sender: Any) {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][\(sender)]")
        super.onAddPetWeight(sender)
    }

    override func onModifyPetInfo(_ sender: Any) {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][\(sender)]")
        super.onModifyPetInfo(sender)
    }

    override func weight_list() {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][\(String(describing: petInfo))]")
        super.weight_list()
    }
}
