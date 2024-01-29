//
//  NoticeListItemView.swift
//  PetTip
//
//  Created by carebiz on 1/10/24.
//

import UIKit

class NoticeListItemView: UITableViewCell {
    
    @IBOutlet weak var lb_title: UILabel!
    @IBOutlet weak var lb_subTitle: UILabel!
    @IBOutlet weak var vw_underline: UIView!
    
    func initialize(notice: BBSNtcList) {
        lb_title.textColor = UIColor.init(hex: "#FF222222")
        lb_subTitle.textColor = UIColor.init(hex: "#FF737980")
        vw_underline.backgroundColor = UIColor.init(hex: "#FFE3E9F2")
        
        lb_title.text = notice.pstTTL
        lb_subTitle.text = notice.pstgBgngDt
    }
}
