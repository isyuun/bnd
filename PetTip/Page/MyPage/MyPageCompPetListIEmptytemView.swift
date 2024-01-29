//
//  MyPageCompPetListIEmptytemView.swift
//  PetTip
//
//  Created by carebiz on 12/31/23.
//

import UIKit

class MyPageCompPetListIEmptytemView: UITableViewCell {
    
    @IBOutlet weak var vw_borderView: UIView!
    
    func initialize() {
        vw_borderView.layer.borderWidth = 1
        vw_borderView.layer.cornerRadius = 10
        vw_borderView.layer.borderColor = UIColor.init(hex: "#FFE3E9F2")?.cgColor
    }
}
