//
//  StoryDetailViewController2.swift
//  PetTip
//
//  Created by isyuun on 2024/5/6.
//

import UIKit

class StoryDetailViewController2: StoryDetailViewController {

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

    override func dailylife_update(lifeView: LifeView) {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][cr_msgAreaHeight:\(String(describing: cr_msgAreaHeight))][vw_msgArea:\(String(describing: vw_msgArea))][lb_msg:\(String(describing: lb_msg))]")
        super.dailylife_update(lifeView: lifeView)
        if let schCN = lifeView.lifeViewData.schCN, schCN.count > 0, schCN != " " {
            self.lb_msg.preferredMaxLayoutWidth = self.lb_msg.frame.size.width
            self.lb_msg.text = lifeView.lifeViewData.schCN
            self.vw_msgArea.translatesAutoresizingMaskIntoConstraints = false
            self.vw_msgArea.isHidden = false
        } else {
            self.vw_msgArea.translatesAutoresizingMaskIntoConstraints = false
            self.vw_msgArea.isHidden = true
            self.vw_msgArea.heightAnchor.constraint(greaterThanOrEqualToConstant: 0).isActive = true
        }
    }
}
