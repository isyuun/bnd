//
//  SelectInvitePetView2.swift
//  PetTip
//
//  Created by isyuun on 2024/5/13.
//

import UIKit
import AlamofireImage

class SelectInvitePetView2: SelectInvitePetView {
    override func onSelectPet(_ sender: Any) {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][\(Global.userNckNm)][\(Global.myPetList)][\(Global.dailyLifePetList)]")
        // super.onSelectPet(sender)

        if isSingleSelectMode == false {
            var selectedItems = [Pet]()
            if let pets = self.pets {
                for i in 0..<pets.count {
                    if itemSelected[i] == true {
                        selectedItems.append(pets[i])
                    }
                }
            }
            if selectedItems.count == 0 {
                parentViewController!.showToast(msg: "펫을 선택해 주세요")
                return
            }

            if deadlineDateTime == "" {
                parentViewController!.showToast(msg: "종료할 일시를 선택해주세요")
                return
            }

            didTapOK?(selectedItems, deadlineDateTime)
        }
    }
}
