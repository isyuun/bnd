//
//  StoryDetailViewController2.swift
//  PetTip
//
//  Created by isyuun on 2024/5/6.
//

import UIKit

class StoryDetailViewController2: StoryDetailViewController {

    override func dailylife_update(lifeView: LifeView) {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][cr_msgAreaHeight:\(String(describing: cr_msgAreaHeight))][vw_msgArea:\(String(describing: vw_msgArea))][lb_msg:\(String(describing: lb_msg))]")
        super.dailylife_update(lifeView: lifeView)
        if let schCN = lifeView.lifeViewData.schCN, schCN.count > 0, schCN != " " {
            self.lb_msg.preferredMaxLayoutWidth = self.lb_msg.frame.size.width
            self.lb_msg.text = lifeView.lifeViewData.schCN
            self.vw_msgArea.translatesAutoresizingMaskIntoConstraints = false
            self.vw_msgArea.isHidden = false
            // self.vw_msgArea.heightAnchor.constraint(equalToConstant: 37).isActive = true
        } else {
            self.vw_msgArea.translatesAutoresizingMaskIntoConstraints = false
            self.vw_msgArea.isHidden = true
            self.vw_msgArea.heightAnchor.constraint(greaterThanOrEqualToConstant: 0).isActive = true
        }
    }
}
