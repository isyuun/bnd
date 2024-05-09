//
//  UIView3.swift
//  PetTip
//
//  Created by isyuun on 2024/5/9.
//

import UIKit

class UIView3: UIView2 { }

extension UIView {

    func checkOneDecimal(textField: UITextField, range: NSRange, string: String, decimal: Int = 1) -> Bool {
        // 입력된 문자열이 숫자 또는 소수점인지 확인합니다.
        let allowedCharacterSet = CharacterSet(charactersIn: "0123456789.")
        let replacementCharacterSet = CharacterSet(charactersIn: string)
        if !replacementCharacterSet.isSubset(of: allowedCharacterSet) {
            return false // 숫자 또는 소수점 이외의 문자는 입력할 수 없습니다.
        }

        // 현재 텍스트 필드의 문자열과 입력된 문자열을 합쳐서 소수점을 기준으로 분리합니다.
        if let currentText = textField.text,
            let dotRange = currentText.range(of: "."),
            string == ".",
            let stringRange = Range(range, in: currentText) {
            // 이미 소수점이 있는 상태에서 소수점을 다시 입력하려고 하면 입력을 거부합니다.
            if stringRange.lowerBound <= dotRange.lowerBound {
                return false
            }
        }

        // 소수점 이하 자릿수를 1자리로 제한합니다.
        if let dotIndex = textField.text?.firstIndex(of: ".") {
            let decimalPlaces = textField.text?.distance(from: dotIndex, to: textField.text?.endIndex ?? dotIndex)
            if decimalPlaces == decimal + 1, string != "" {
                return false
            }
        }

        return true
    }

    func checkMaxLength(textField: UITextField, range: NSRange, string: String, maxLength: Int = 0) -> Bool {
        if maxLength == 0 { return true }

        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)

        return newString.count <= maxLength
    }
}
