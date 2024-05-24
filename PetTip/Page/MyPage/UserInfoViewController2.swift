//
//  UserInfoViewController2.swift
//  PetTip
//
//  Created by isyuun on 2024/5/14.
//

import UIKit

class UserInfoViewController2: UserInfoViewController {

    // override func keyboardWillShow(_ notification: NSNotification) {
    //     super.keyboardWillShow(notification)
    //
    //     guard let userInfo = notification.userInfo else { return }
    //     guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
    //     let keyboardFrame = keyboardSize.cgRectValue
    //
    //     if keyboardShowOriginHeight == 0 {
    //         keyboardShowOriginHeight = Int(self.view.frame.size.height)
    //     }
    //
    //     self.view.frame.size.height = CGFloat(keyboardShowOriginHeight) - keyboardFrame.height
    // }
    //
    // override func keyboardWillHide(_ notification: NSNotification) {
    //     super.keyboardWillHide(notification)
    //
    //     self.view.frame.size.height = CGFloat(keyboardShowOriginHeight)
    // }
}
