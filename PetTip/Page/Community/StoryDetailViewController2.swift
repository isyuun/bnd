//
//  StoryDetailViewController2.swift
//  PetTip
//
//  Created by isyuun on 2024/5/6.
//

import UIKit

class StoryDetailViewController2: StoryDetailViewController {
    override func viewDidLoad() {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][isRequireRefresh:\(isRequireRefresh)]")
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][isRequireRefresh:\(isRequireRefresh)][animated:\(animated)]")
        super.viewWillAppear(animated)
    }

    override func requestLifeViewData() {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][isRequireRefresh:\(isRequireRefresh)][schUnqNo\(String(describing: schUnqNo))]")
        super.requestLifeViewData()
    }
}
