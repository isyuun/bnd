//
//  UITextField3.swift
//  PetTip
//
//  Created by isyuun on 2024/5/2.
//
//
// Set the maximum character length of a UITextField
// https://stackoverflow.com/questions/433337/set-the-maximum-character-length-of-a-uitextfield

import UIKit

private var __maxLengths: Int = 0
@IBDesignable
class UITextField3: UITextField2 {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return range.location < __maxLengths // limit to 140 chars
    }
}

extension UITextField3 {
    @IBInspectable var maxLength: Int {
        get {
            if let length = objc_getAssociatedObject(self, &__maxLengths) as? Int {
                return length
            } else {
                return Int.max
            }
        }
        set {
            objc_setAssociatedObject(self, &__maxLengths, newValue, .OBJC_ASSOCIATION_RETAIN)
            addTarget(self, action: #selector(checkMaxLength), for: .editingChanged)
        }
    }
    
    @objc func checkMaxLength(textField: UITextField) {
        guard let prospectiveText = self.text,
            prospectiveText.count > maxLength
            else {
            return
        }
    
        let selection = selectedTextRange
    
        let indexEndOfText = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
        let substring = prospectiveText[..<indexEndOfText]
        text = String(substring)
    
        selectedTextRange = selection
    }
}
