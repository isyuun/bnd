//
//  MyPageViewController2.swift
//  PetTip
//
//  Created by isyuun on 2024/4/30.
//

import UIKit

class MyPageViewController2: MyPageViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let count = myPetList.myPets.count
        let index = indexPath.row
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][\(indexPath)][\(index)/\(count)]")
        if index < count - 1 {
            super.tableView(tableView, didSelectRowAt: indexPath)
        }
    }
}
