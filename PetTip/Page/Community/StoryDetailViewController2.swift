//
//  StoryDetailViewController2.swift
//  PetTip
//
//  Created by isyuun on 2024/5/6.
//

import UIKit

class StoryDetailViewController2: StoryDetailViewController {
    override func viewDidAppear(_ animated: Bool) {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][animated:\(animated)]")
        super.viewDidAppear(animated)
    }

    override func requestLifeViewData() {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][schUnqNo\(String(describing: schUnqNo))]")
        super.requestLifeViewData()
    }
}
