//
//  WalkHistoryWeekListItemView.swift
//  PetTip
//
//  Created by carebiz on 12/13/23.
//

import UIKit

class WalkHistoryWeekListItemView : UITableViewCell {
 
    @IBOutlet weak var vw_bg : UIView!
    @IBOutlet weak var lb_member : UILabel!
    @IBOutlet weak var lb_date : UILabel!
    @IBOutlet weak var lb_walker : UILabel!
    @IBOutlet weak var lb_time : UILabel!
    @IBOutlet weak var lb_dist : UILabel!
    
    func initialize() {
        vw_bg.layer.borderWidth = 1
        vw_bg.layer.borderColor = UIColor(hex: "#FFe3e9f2")?.cgColor
        vw_bg.layer.cornerRadius = 10
        
        lb_date.layer.borderWidth = 1
        lb_date.layer.borderColor = UIColor(hex: "#FF4783f5")?.cgColor
        lb_date.layer.cornerRadius = 10
    }
    
    var actionBlock: (() -> Void)? = nil
    
    @IBAction func onHistoryDetail(_ sender: Any) {
        actionBlock?()
    }
}
