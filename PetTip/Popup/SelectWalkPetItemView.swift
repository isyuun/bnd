//
//  SelectWalkPetItemView.swift
//  PetTip
//
//  Created by carebiz on 2/3/24.
//

import UIKit
import AlamofireImage

class SelectWalkPetItemView: UITableViewCell {
    
    @IBOutlet weak var vw_profileBg : UIView!
    @IBOutlet weak var iv_profile : UIImageView!
    @IBOutlet weak var lb_nm : UILabel!
    @IBOutlet weak var iv_chkSelected: UIImageView!
    @IBOutlet weak var vw_chkSelected: UIView!
    
    func initialize(pet: Pet) {
        vw_profileBg.backgroundColor = UIColor.white
        vw_profileBg.layer.cornerRadius = self.vw_profileBg.bounds.size.width / 2
        vw_profileBg.layer.borderColor = UIColor.init(hex: "#4E608526")?.cgColor
        vw_profileBg.layer.borderWidth = 1
        vw_profileBg.layer.masksToBounds = true
        vw_profileBg.layer.shadowRadius = 2
        vw_profileBg.layer.shadowOpacity = 0.2
        vw_profileBg.layer.shadowOffset = CGSize(width: 2, height: 4)
        vw_profileBg.layer.shadowColor = UIColor.init(hex: "#70000000")?.cgColor
        
        iv_profile.backgroundColor = UIColor.white
        iv_profile.layer.cornerRadius = self.iv_profile.bounds.size.width / 2
        
        Global2.setPetImage(imageView: iv_profile, petTypCd: pet.petTypCd, petImgAddr: pet.petRprsImgAddr)

        lb_nm.text = pet.petNm
        
        iv_chkSelected.image = UIImage.imageFromColor(color: UIColor.clear)
        iv_chkSelected.tag = 0
        vw_chkSelected.backgroundColor = UIColor.white
        vw_chkSelected.layer.cornerRadius = 2
        vw_chkSelected.layer.borderWidth = 1
        vw_chkSelected.layer.borderColor = UIColor.init(hex: "#FFE3E9F2")?.cgColor
    }
    
    func setSelect(isSelected: Bool) {
        if isSelected {
            iv_chkSelected.image = UIImage(named: "checkbox_white")
            vw_chkSelected.backgroundColor = UIColor.init(hex: "#FF4783F5")
            
        } else {
            iv_chkSelected.image = UIImage.imageFromColor(color: UIColor.clear)
            vw_chkSelected.backgroundColor = UIColor.white
        }
    }
}
