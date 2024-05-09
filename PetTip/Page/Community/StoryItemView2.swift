//
//  StoryItemView2.swift
//  PetTip
//
//  Created by isyuun on 2024/5/9.
//

import UIKit

class StoryItemView2 : StoryItemView {

    override func initialize(_ _parentWidth: Int, _ _spacing: Int) {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][_parentWidth:\(_parentWidth)][_spacing:\(_spacing)]")
        super.initialize(_parentWidth, _spacing)
    }
}
