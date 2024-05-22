//
//  InviteSetKeyViewController3.swift
//  PetTip
//
//  Created by isyuun on 2024/5/22.
//

import UIKit

class InviteSetKeyViewController3: InviteSetKeyViewController2 {
    var invttKeyVl: String!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let key = self.invttKeyVl, key.count == 6 {
            self.invttKeyVl = nil
            tf_key.text = key
        }
    }
}
