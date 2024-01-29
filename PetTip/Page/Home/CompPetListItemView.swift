//
//  TestTableViewCellInSheetView.swift
//  PetTip
//
//  Created by carebiz on 12/8/23.
//

import UIKit

class CompPetListItemView : UITableViewCell {
    
    @IBOutlet weak var viewGuide: UIView!
    @IBOutlet weak var vwProfIvBorder: UIView!
    @IBOutlet weak var ivProf : UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbSubtitle: UILabel!
    @IBOutlet weak var lbNone: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if (selected) {
            stateSelected()
        } else {
            stateNormal()
        }
    }
    
    private func stateSelected() {
        viewGuide.layer.borderColor = UIColor(hex: "#ff4783f5")?.cgColor // SELECTED COLOR
        viewGuide.layer.backgroundColor = UIColor(hex: "#ffF6F8FC")?.cgColor // SELECTED COLOR
        
        viewGuide.layer.shadowColor = UIColor.init(hex: "#4E608533")?.cgColor
        viewGuide.layer.shadowRadius = 2
        viewGuide.layer.shadowOpacity = 1
        viewGuide.layer.shadowOffset = CGSize(width: 1, height: 2)
        
        stateCommon()
    }
    
    private func stateNormal() {
        viewGuide?.layer.borderColor = UIColor(hex: "#ffe3e9f2")?.cgColor // NORMAL COLOR
        viewGuide?.layer.backgroundColor = UIColor(hex: "#ffffffff")?.cgColor // NORMAL COLOR
        
        viewGuide.layer.shadowColor = UIColor.clear.cgColor
        viewGuide.layer.shadowRadius = 0
        viewGuide.layer.shadowOpacity = 0
        viewGuide.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        stateCommon()
    }
    
    private func stateCommon() {
        viewGuide.layer.borderWidth = 1
        viewGuide.layer.cornerRadius = 10
        
        ivProf.layer.cornerRadius = ivProf.bounds.size.width / 2
        ivProf.layer.masksToBounds = true
        
        vwProfIvBorder.backgroundColor = UIColor.white
        vwProfIvBorder.layer.borderWidth = 1
        vwProfIvBorder.layer.cornerRadius = vwProfIvBorder.bounds.size.width / 2
        vwProfIvBorder.layer.borderColor = UIColor.init(hex: "#4E608526")?.cgColor
        vwProfIvBorder.showShadowMid()
        
        lbTitle.textColor = UIColor.init(hex: "#ff222222")
        lbSubtitle.textColor = UIColor.init(hex: "#ff737980")
    }
}

