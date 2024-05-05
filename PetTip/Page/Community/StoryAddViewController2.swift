//
//  StoryAddViewController2.swift
//  PetTip
//
//  Created by isyuun on 2024/5/3.
//

import UIKit

class StoryAddViewController2: StoryAddViewController {
    override func viewDidAppear(_ animated: Bool) {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][animated:\(animated)]")
        super.viewDidAppear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][animated:\(animated)]")
        super.viewDidDisappear(animated)
    }

    @objc override func keyboardWillShow(_ notification: NSNotification) {
        super.keyboardWillShow(notification)

        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = keyboardSize.cgRectValue

        sv_content.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
        sv_content.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)

        let bottomOffset = CGPoint(x: 0, y: sv_content.contentSize.height - sv_content.bounds.height + sv_content.contentInset.bottom)
        if (bottomOffset.y > 0) {
            sv_content.setContentOffset(bottomOffset, animated: true)
        }
    }

    @objc override func keyboardWillHide(_ notification: NSNotification) {
        super.keyboardWillHide(notification)

        sv_content.contentInset = UIEdgeInsets.zero
        sv_content.scrollIndicatorInsets = UIEdgeInsets.zero
    }
}
