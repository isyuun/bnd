//
//  CommonPostViewController.swift
//  PetTip
//
//  Created by isyuun on 2024/5/13.
//

import UIKit
import AlamofireImage
import DropDown

class CommonPostViewController: CommonViewController2 {
    @IBOutlet weak var tf_petName: UITextField2!
    @IBOutlet weak var tf_nickNname: UITextField2!
    @IBOutlet weak var tf_title: UITextField2!
    @IBOutlet weak var tv_memo: UITextView2!
    @IBOutlet weak var tf_hashtag: UITextField2!

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][text:\(String(describing: text))][range:\(range)][string:\(string)]")
        switch textField {
        case tf_petName:
            return range.location < tf_petName.maxLength
        case tf_nickNname:
            return range.location < tf_nickNname.maxLength
        case tf_hashtag:
            // 입력된 문자열이 "#"로 시작하는지 확인
            if let text = text, text.hasPrefix("#") {
                // "#"로 시작하면 텍스트 필드의 텍스트 색상을 파란색으로 변경
                textField.textColor = .blue
            } else {
                // "#"로 시작하지 않으면 기본 텍스트 색상으로 변경
                textField.textColor = .black
            }
            return range.location < tf_hashtag.maxLength
        default:
            break
        }
        return true
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][text:\(String(describing: textView.text))][range:\(range)][text:\(text)]")
        switch textView {
        case tv_memo:
            return range.location < tv_memo.maxLength
        default:
            break
        }
        return true
    }
}
