//
//  MapNavView.swift
//  PetTip
//
//  Created by carebiz on 11/29/23.
//

import UIKit

class MapNavView : UIView {
    
    @IBOutlet weak var profileView : UIView!
    @IBOutlet weak var profileImageView : UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder : NSCoder) {
        super.init(coder: aDecoder);
    }
    
    func initialize() {
        self.profileView.layer.cornerRadius = self.profileView.bounds.size.width / 2
        self.profileView.showShadowMid()
        
        self.profileImageView.layer.cornerRadius = self.profileImageView.bounds.size.width / 2
        self.profileImageView.image = UIImage.init(named: "profile_default")
    }
}
