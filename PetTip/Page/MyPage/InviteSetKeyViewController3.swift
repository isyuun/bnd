//
//  InviteSetKeyViewController3.swift
//  PetTip
//
//  Created by isyuun on 2024/5/22.
//

import UIKit

class InviteSetKeyViewController3: InviteSetKeyViewController2 {
    var invttKeyVl: String!

    private func invitation() {
        if let key = self.invttKeyVl, key.count == 6 {
            tf_key.text = key
            tf_key.isHidden = true
            tf_key.resignFirstResponder()
        } else {
            tf_key.text = ""
            tf_key.isHidden = false
            tf_key.becomeFirstResponder()
        }

        self.invttKeyVl = nil
        Global.invttKeyVl = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        invitation()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
