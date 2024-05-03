//
//  StoryModifyViewController2.swift
//  PetTip
//
//  Created by isyuun on 2024/5/3.
//

import UIKit

class StoryModifyViewController2: StoryModifyViewController {
    override func viewDidAppear(_ animated: Bool) {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][animated:\(animated)]")
        super.viewDidAppear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][animated:\(animated)]")
        super.viewDidDisappear(animated)
    }
}
