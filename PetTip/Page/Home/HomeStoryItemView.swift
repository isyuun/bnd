//
//  HomeStoryItemView.swift
//  PetTip
//
//  Created by carebiz on 12/6/23.
//

import UIKit

class HomeStoryItemView : UICollectionViewCell {
    
    @IBOutlet weak var storyImgView : UIImageView!
    @IBOutlet weak var lb_schTtl : UILabel!
    @IBOutlet weak var lb_petNM : UILabel!
    @IBOutlet weak var lb_cmdtnCnt : UILabel!
    @IBOutlet weak var lb_cmntCnt : UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder : NSCoder) {
        super.init(coder: aDecoder);
    }
    
    func initialize() {
        layer.cornerRadius = 20
    }
}
