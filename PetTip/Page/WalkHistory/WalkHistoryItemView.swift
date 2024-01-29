//
//  WalkHistoryItemView.swift
//  PetTip
//
//  Created by carebiz on 12/13/23.
//

import UIKit

class WalkHistoryItemView : UIView {
    
    @IBOutlet weak var iv : UIImageView!
    @IBOutlet weak var lb : UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder : NSCoder) {
        super.init(coder: aDecoder);
    }
    
    var isActive : Bool = false
    var isToday : Bool = false
    var text : String = ""
    
    func update() {
        if (isActive) {
            iv.image = UIImage(named: "attendance_active")
            
        } else {
            iv.image = UIImage(named: "attendance_default")
        }

        if (isToday) {
            lb.textColor = UIColor.init(hex: "#FF4783f5")
            lb.backgroundColor = UIColor.white
            
        } else {
            lb.textColor = UIColor.init(hex: "#FFC3D3EC")
            lb.backgroundColor = UIColor.clear
        }
        
        lb.layer.cornerRadius = lb.frame.size.width / 2
        lb.layer.masksToBounds = true
        lb.text = text
    }
}
