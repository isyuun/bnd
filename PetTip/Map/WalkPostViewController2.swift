//
//  PostViewController2.swift
//  PetTip
//
//  Created by isyuun on 2024/5/6.
//

import UIKit

class WalkPostViewController2: WalkPostViewController {

    // override func keyboardWillShow(_ notification: NSNotification) {
    //     super.keyboardWillShow(notification)
    // 
    //     guard let userInfo = notification.userInfo else { return }
    //     guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
    //     let keyboardFrame = keyboardSize.cgRectValue
    // 
    //     sv_content.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
    //     sv_content.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
    // 
    //     let bottomOffset = CGPoint(x: 0, y: sv_content.contentSize.height - sv_content.bounds.height + sv_content.contentInset.bottom)
    //     if (bottomOffset.y > 0) {
    //         sv_content.setContentOffset(bottomOffset, animated: true)
    //     }
    // }
    // 
    // override func keyboardWillHide(_ notification: NSNotification) {
    //     super.keyboardWillHide(notification)
    // 
    //     sv_content.contentInset = UIEdgeInsets.zero
    //     sv_content.scrollIndicatorInsets = UIEdgeInsets.zero
    // }
    // 
    // func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    //     NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][range:\(range)][string:\(string)]")
    //     switch textField {
    //     case tf_title:
    //         return range.location < tf_title.maxLength
    //     case tf_hashtag:
    //         return range.location < tf_hashtag.maxLength
    //     default:
    //         break
    //     }
    //     return true
    // }
    // 
    // func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    //     NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][range:\(range)][text:\(text)]")
    //     switch textView {
    //     case tv_memo:
    //         return range.location < tv_memo.maxLength
    //     default:
    //         break
    //     }
    //     return true
    // }
}
