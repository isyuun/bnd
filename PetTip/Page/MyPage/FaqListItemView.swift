//
//  FaqListItemView.swift
//  PetTip
//
//  Created by carebiz on 1/10/24.
//

import UIKit

class FaqListItemView: UITableViewCell {
    
    @IBOutlet weak var vw_arrowBorderCircle: UIView!
    @IBOutlet weak var iv_arrow: UIImageView!
    
    @IBOutlet weak var lb_title: UILabel!
    @IBOutlet weak var lb_detail: UILabel!
    
    @IBOutlet weak var cr_expandAreaHeight: NSLayoutConstraint!
    @IBOutlet weak var vw_expandArea: UIView!
    
    var cr_expandAreaHeightOrigin: NSLayoutConstraint!
    var cr_expandAreaHeightZero: NSLayoutConstraint!
    
    public var didTapExpand: (()-> Void)?
    
    func initialize(faq: BBSFAQList) {
        vw_arrowBorderCircle.layer.borderColor = UIColor.init(hex: "#FFE3E9F2")?.cgColor
        vw_arrowBorderCircle.layer.borderWidth = 1
        vw_arrowBorderCircle.layer.cornerRadius = vw_arrowBorderCircle.bounds.size.width / 2
        vw_arrowBorderCircle.layer.masksToBounds = true
        
        lb_title.text = faq.pstTTL
        lb_detail.text = faq.pstCN
    }
    
    public func toExpand() {
        backgroundColor = UIColor.init(hex: "#FFF6F8FC")
        lb_title.textColor = UIColor.init(hex: "#FF4783F5")
        iv_arrow.image = UIImage(systemName: "chevron.up")
        
        if cr_expandAreaHeightZero != nil {
            cr_expandAreaHeightZero.isActive = false
        }
        cr_expandAreaHeightOrigin = vw_expandArea.heightAnchor.constraint(greaterThanOrEqualToConstant: 32)
        vw_expandArea.addConstraint(cr_expandAreaHeightOrigin)
    }
    
    public func toUnexpand() {
        backgroundColor = UIColor.white
        lb_title.textColor = UIColor.init(hex: "#FF222222")
        iv_arrow.image = UIImage(systemName: "chevron.down")
        
        if cr_expandAreaHeightOrigin != nil {
            cr_expandAreaHeightOrigin.isActive = false
        }
        cr_expandAreaHeightZero = vw_expandArea.heightAnchor.constraint(equalToConstant: 0)
        vw_expandArea.addConstraint(cr_expandAreaHeightZero)
    }
    
    @IBAction func onExpandDetail(_ sender: Any) {
        self.didTapExpand?()
    }
}
