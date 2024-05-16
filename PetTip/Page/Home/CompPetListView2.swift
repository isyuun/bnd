//
//  CompPetListView2.swift
//  PetTip
//
//  Created by isyuun on 2024/5/16.
//

import UIKit
import AlamofireImage

class CompPetListView2: CompPetListView {

    override func onAddPet(_ sender: Any) {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][sender:\(sender)]")
        super.onAddPet(sender)
    }

    override func onPetManage(_ sender: Any) {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][sender:\(sender)]")
        super.onPetManage(sender)

        if (delegate != nil) {
            if let myPets = self.myPets, let indexPath = tableView.indexPathForSelectedRow {
                delegate.onPetManage(myPet: myPets[indexPath.row])
            }
        }
    }
}
