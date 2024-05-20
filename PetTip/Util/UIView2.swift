//
//  UIView2.swift
//  PetTip
//
//  Created by isyuun on 2024/5/9.
//

import UIKit

extension UIView {

    func checkOneDecimal(textField: UITextField, range: NSRange, string: String, integer: Int = 5, decimal: Int = 1) -> Bool {
        // 입력된 문자열이 숫자 또는 소수점인지 확인합니다.
        let allowedCharacterSet = CharacterSet(charactersIn: "0123456789.")
        let replacementCharacterSet = CharacterSet(charactersIn: string)
        if !replacementCharacterSet.isSubset(of: allowedCharacterSet) {
            return false // 숫자 또는 소수점 이외의 문자는 입력할 수 없습니다.
        }

        // 현재 텍스트 필드의 문자열과 입력된 문자열을 합쳐서 소수점을 기준으로 분리합니다.
        if let currentText = textField.text {
            let newText = (currentText as NSString).replacingCharacters(in: range, with: string)

            // 이미 소수점이 있는 상태에서 소수점을 다시 입력하려고 하면 입력을 거부합니다.
            if newText.filter({ $0 == "." }).count > 1 {
                return false
            }

            // 소수점 위치를 기준으로 정수 부분과 소수 부분을 분리합니다.
            if let dotIndex = newText.firstIndex(of: ".") {
                let integerPart = newText.prefix(upTo: dotIndex)
                let decimalPart = newText.suffix(from: newText.index(after: dotIndex))

                // 정수 부분의 자릿수를 제한합니다.
                if integerPart.count > integer {
                    return false
                }

                // 소수 부분의 자릿수를 제한합니다.
                if decimalPart.count > decimal {
                    return false
                }
            } else {
                // 소수점이 없으면 정수 부분의 자릿수만 확인합니다.
                if newText.count > integer {
                    return false
                }
            }
        }

        return true
    }
}
