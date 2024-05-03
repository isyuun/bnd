//
//  UITextField2.swift
//  PetTip
//
//  Created by isyuun on 2024/5/2.
//

import UIKit

// Set the maximum character length of a UITextField in Swift
// https://stackoverflow.com/questions/31363216/set-the-maximum-character-length-of-a-uitextfield-in-swift
private var __maxLengths = [UITextField: Int]()
extension UITextField {
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
               return 150 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    @objc func fix(textField: UITextField) {
        let t = textField.text
        textField.text = t?.prefix(maxLength).base
    }
}

// // Set the maximum character length of a UITextField
// // https://stackoverflow.com/questions/433337/set-the-maximum-character-length-of-a-uitextfield
// private var kAssociationKeyMaxLength: Int = 0
//
// extension UITextField {
//
//     @IBInspectable var maxLength: Int {
//         get {
//             if let length = objc_getAssociatedObject(self, &kAssociationKeyMaxLength) as? Int {
//                 return length
//             } else {
//                 return Int.max
//             }
//         }
//         set {
//             objc_setAssociatedObject(self, &kAssociationKeyMaxLength, newValue, .OBJC_ASSOCIATION_RETAIN)
//             addTarget(self, action: #selector(checkMaxLength), for: .editingChanged)
//         }
//     }
//
//     @objc func checkMaxLength(textField: UITextField) {
//         guard let prospectiveText = self.text,
//             prospectiveText.count > maxLength
//             else {
//                 return
//         }
//
//         let selection = selectedTextRange
//
//         let indexEndOfText = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
//         let substring = prospectiveText[..<indexEndOfText]
//         text = String(substring)
//
//         selectedTextRange = selection
//     }
// }
