//
//  WalkHistoryPetItemView.swift
//  PetTip
//
//  Created by carebiz on 12/15/23.
//

import UIKit

class WalkHistoryPetItemView : UIView {
    
    @IBOutlet weak var vw_border : UIView!
    @IBOutlet weak var vw_profIvBorder : UIView!
    @IBOutlet weak var iv_prof : UIImageView!
    @IBOutlet weak var lb_nm : UILabel!
    @IBOutlet weak var lb_cnt_poop : UILabel!
    @IBOutlet weak var lb_cnt_pee : UILabel!
    @IBOutlet weak var lb_cnt_marking : UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder : NSCoder) {
        super.init(coder: aDecoder);
    }
    
    func initialize() {
        vw_border.layer.cornerRadius = 10
        vw_border.layer.borderColor = UIColor(hex: "#ffe3e9f2")?.cgColor
        vw_border.layer.borderWidth = 1
        
        iv_prof.layer.cornerRadius = iv_prof.bounds.size.width / 2
        iv_prof.layer.masksToBounds = true
        
        vw_profIvBorder.backgroundColor = UIColor.white
        vw_profIvBorder.layer.borderWidth = 1
        vw_profIvBorder.layer.cornerRadius = vw_profIvBorder.bounds.size.width / 2
        vw_profIvBorder.layer.borderColor = UIColor.init(hex: "#4E608526")?.cgColor
        vw_profIvBorder.showShadowMid()
    }
}
