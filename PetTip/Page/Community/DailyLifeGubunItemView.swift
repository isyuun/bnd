//
//  DailyLifeGubunItemView.swift
//  PetTip
//
//  Created by carebiz on 1/20/24.
//

import UIKit

class DailyLifeGubunItemView: UICollectionViewCell {
    @IBOutlet weak var lb_gubun: UILabel!
    
    func update(_ isSelected : Bool){
        if isSelected {
            stateSelected()
        } else {
            stateNormal()
        }
    }
    
    private func stateSelected() {
        lb_gubun.layer.borderColor = UIColor(hex: "#ff4783f5")?.cgColor // SELECTED COLOR
        lb_gubun.layer.backgroundColor = UIColor(hex: "#ffF6F8FC")?.cgColor // SELECTED COLOR
        
        lb_gubun.layer.shadowColor = UIColor.init(hex: "#4E608533")?.cgColor
        lb_gubun.layer.shadowRadius = 2
        lb_gubun.layer.shadowOpacity = 1
        lb_gubun.layer.shadowOffset = CGSize(width: 1, height: 2)
        
        stateCommon()
    }
    
    private func stateNormal() {
        lb_gubun.layer.borderColor = UIColor(hex: "#ffe3e9f2")?.cgColor // NORMAL COLOR
        lb_gubun.layer.backgroundColor = UIColor(hex: "#ffffffff")?.cgColor // NORMAL COLOR
        
        lb_gubun.layer.shadowColor = UIColor.clear.cgColor
        lb_gubun.layer.shadowRadius = 0
        lb_gubun.layer.shadowOpacity = 0
        lb_gubun.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        stateCommon()
    }
    
    private func stateCommon() {
        lb_gubun.layer.borderWidth = 1
        lb_gubun.layer.cornerRadius = 10
    }
}
