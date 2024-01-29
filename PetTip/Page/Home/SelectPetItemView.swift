//
//  SelectPetItemView.swift
//  PetTip
//
//  Created by carebiz on 12/9/23.
//

import UIKit

class SelectPetItemView : UICollectionViewCell {
    
    @IBOutlet weak var vwProfIvBorder: UIView!
    @IBOutlet weak var ivProf : UIImageView!
    @IBOutlet weak var lbName: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder : NSCoder) {
        super.init(coder: aDecoder);
    }
    
    func update(_ isSelected : Bool){
        if isSelected {
            stateSelected()
        } else {
            stateNormal()
        }
    }
    
    private func stateSelected() {
        layer.borderColor = UIColor(hex: "#ff4783f5")?.cgColor // SELECTED COLOR
        layer.backgroundColor = UIColor(hex: "#ffF6F8FC")?.cgColor // SELECTED COLOR
        
        layer.shadowColor = UIColor.init(hex: "#4E608533")?.cgColor
        layer.shadowRadius = 2
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 1, height: 2)
        
        stateCommon()
    }
    
    private func stateNormal() {
        layer.borderColor = UIColor(hex: "#ffe3e9f2")?.cgColor // NORMAL COLOR
        layer.backgroundColor = UIColor(hex: "#ffffffff")?.cgColor // NORMAL COLOR
        
        layer.shadowColor = UIColor.clear.cgColor
        layer.shadowRadius = 0
        layer.shadowOpacity = 0
        layer.shadowOffset = CGSize(width: 0, height: 0)
        
        stateCommon()
    }
    
    private func stateCommon() {
        layer.borderWidth = 1
        layer.cornerRadius = 10
        
        ivProf.layer.cornerRadius = ivProf.bounds.size.width / 2
        
        vwProfIvBorder.backgroundColor = UIColor.white
        vwProfIvBorder.layer.borderWidth = 1
        vwProfIvBorder.layer.cornerRadius = vwProfIvBorder.bounds.size.width / 2
        vwProfIvBorder.layer.borderColor = UIColor.init(hex: "#4E608526")?.cgColor
        vwProfIvBorder.showShadowMid()
    }
}
