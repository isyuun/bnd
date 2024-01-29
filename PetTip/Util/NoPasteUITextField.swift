//
//  NoPasteUITextField.swift
//  PetTip
//
//  Created by carebiz on 1/6/24.
//

import UIKit

class NoPasteUITextField: UITextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
         if action == #selector(UIResponderStandardEditActions.paste(_:)) {
             return false
         }
         return super.canPerformAction(action, withSender: sender)
    }
 }
