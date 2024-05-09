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
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][indexPath:\(indexPath)][\(index)/\(count)]")
        if index < count {
            super.tableView(tableView, didSelectRowAt: indexPath)
        }
    }

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
}
