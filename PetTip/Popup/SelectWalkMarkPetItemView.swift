//
//  SelectWalkMarkPetItemView.swift
//  PetTip
//
//  Created by carebiz on 2/3/24.
//

import UIKit

class SelectWalkMarkPetItemView: UIView {
    
    public var didSelect: (()-> Void)?
    
    @IBOutlet weak var vw_btn: UIView!
    @IBOutlet weak var iv_btn: UIImageView!
    @IBOutlet weak var lb_nm: UILabel!
    
    public func initialize() {
        vw_btn.layer.cornerRadius = vw_btn.bounds.width / 2
        vw_btn.backgroundColor = UIColor.white
        
        var image = UIImage.init(named: "walk_active")
        image = image?.withTintColor(UIColor.black)
        iv_btn.image = image
        
        lb_nm.text = "AAAA"
    }
    
    @IBAction func onSelect(_ sender: Any) {
        didSelect?()
    }
}
