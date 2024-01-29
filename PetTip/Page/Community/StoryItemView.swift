//
//  StoryItemView.swift
//  PetTip
//
//  Created by carebiz on 12/17/23.
//

import UIKit

class StoryItemView : UICollectionViewCell {
    
    @IBOutlet weak var storyImgView : UIImageView!
    @IBOutlet weak var lb_schTtl : UILabel!
    @IBOutlet weak var lb_petNM : UILabel!
    @IBOutlet weak var lb_cmdtnCnt : UILabel!
    @IBOutlet weak var lb_cmntCnt : UILabel!
    
    @IBOutlet weak var cr_imgWidth : NSLayoutConstraint!
    @IBOutlet weak var cr_imgHeight : NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder : NSCoder) {
        super.init(coder: aDecoder);
    }
    
    func initialize(_ _parentWidth: Int, _ _spacing: Int) {
        let calcSize = StoryItemView.getCalcSize(_parentWidth, _spacing)
        cr_imgWidth.constant = calcSize.width
        cr_imgHeight.constant = calcSize.height
        
        layer.cornerRadius = 20
    }
    
    static func getCalcSize(_ _parentWidth: Int, _ _spacing: Int) -> CGSize {
        let imgRatio = 1.4
        let parentCntForOneRow = 2
        
        let calcWidth = Float((_parentWidth - _spacing * (parentCntForOneRow - 1)) / parentCntForOneRow)
        let calcHeight = Float(Double(calcWidth) * imgRatio)
        
        return CGSize(width: CGFloat(calcWidth), height: CGFloat(calcHeight))
    }
}
