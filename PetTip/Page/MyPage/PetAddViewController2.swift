//
//  AddPetViewController.swift
//  PetTip
//
//  Created by carebiz on 1/6/24.
//

import UIKit

class PetAddViewController2: PetAddViewController {

    override func viewDidLoad() {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)]")
        super.viewDidLoad()
        tf_weight.keyboardType = .decimalPad
    }

    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][\(tf_weight == textField)][textField:\(String(describing: textField.text))][range:\(range)][string:\(string)]")
        if tf_weight == textField { return checkOneDecimal(textField: textField, range: range, string: string) }
        return true
    }

    override func onPetType(_ sender: Any) {
        guard let button = sender as? UIButton else { return }
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][sender:\(button)]")
        super.onPetType(sender)

        var petTypCd = "001"
        switch button {
        case btn_petTypeDog:
            petTypCd = "001"
            break
        case btn_petTypeCat:
            petTypCd = "002"
            break
        default:
            break
        }

        Global3.setPetImage(imageView: iv_profile, petTypCd: petTypCd)
    }
}
