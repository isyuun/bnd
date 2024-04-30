//
//  AddPetViewController.swift
//  PetTip
//
//  Created by carebiz on 1/6/24.
//

import UIKit

class PetAddViewController2: PetAddViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tf_weight.keyboardType = .decimalPad
    }

    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][\(tf_weight == textField)][textField:\(String(describing: textField.text))][range:\(range)][string:\(string)]")
        if tf_weight == textField { return checkOneDecimal(textField: textField, range: range, string:string) }
        return true
    }
}
