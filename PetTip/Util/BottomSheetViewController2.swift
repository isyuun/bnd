//
//  BottomSheetViewController2.swift
//  PetTip
//
//  Created by Ahn Je Wook on 6/21/24.
//

import UIKit


class BottomSheetViewController2: BottomSheetViewController {
    
    public var closeHandler: (() -> Void)?
    override func hideBottomSheetAndGoBack() {
        super.hideBottomSheetAndGoBack()
        if closeHandler != nil {
            closeHandler!()
        }
    }
}
