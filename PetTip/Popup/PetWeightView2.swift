//
//  PetWeightView2.swift
//  PetTip
//
//  Created by isyuun on 2024/4/29.
//

import UIKit

class PetWeightView2: PetWeightView, UITextViewDelegate {

    override func initialize(viewMode: PetWeightViewMode) {
        super.initialize(viewMode: viewMode)
        tf_weight.keyboardType = .decimalPad
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        NSLog("[LOG][I][PetWeightView2][textField][\(tf_weight == textField)][textField:\(String(describing: textField.text))][range:\(range)][string:\(string)]")
        if tf_weight == textField { return checkOneDecimal(textField: textField, range: range, string: string) }
        return true
    }
}
