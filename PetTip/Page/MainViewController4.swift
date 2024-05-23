//
//  MainViewController4.swift
//  PetTip
//
//  Created by isyuun on 2024/5/23.
//

import UIKit

class MainViewController4: MainViewController3 {

    override func viewDidLoad() {
        super.viewDidLoad()

        if let key = Global.invttKeyVl, key.count == 6 {
            invitation(key: key)
        }
    }
}
