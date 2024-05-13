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
    @IBOutlet weak var tf_title: UITextField2!
    @IBOutlet weak var tv_memo: UITextView2!
    @IBOutlet weak var tf_hashtag: UITextField2!

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][text:\(String(describing: textField.text))][range:\(range)][string:\(string)]")
        switch textField {
        case tf_title:
            return range.location < tf_title.maxLength
        case tf_hashtag:
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
