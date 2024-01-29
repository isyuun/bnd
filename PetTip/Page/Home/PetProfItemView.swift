//
//  PetProfView.swift
//  PetTip
//
//  Created by carebiz on 12/5/23.
//

import UIKit
import FSPagerView

//class PetProfItemView : UICollectionViewCell {
class PetProfItemView : FSPagerViewCell {
    
    @IBOutlet weak var profileView : UIView!
    @IBOutlet weak var profileImageView : UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder : NSCoder) {
        super.init(coder: aDecoder);
    }
    
    func initialize() {
        self.profileView.backgroundColor = UIColor.white
        self.profileView.layer.cornerRadius = self.profileView.bounds.size.width / 2
        self.profileView.layer.borderColor = UIColor.init(hex: "#4E608526")?.cgColor
        self.profileView.layer.borderWidth = 1
        self.profileView.layer.masksToBounds = true
        
        self.profileImageView.backgroundColor = UIColor.white
        self.profileImageView.layer.cornerRadius = self.profileImageView.bounds.size.width / 2
        
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 2, height: 4)
        layer.shadowColor = UIColor.init(hex: "#70000000")?.cgColor
    }
}

