//
//  QnADetailAttatchFileItemView.swift
//  PetTip
//
//  Created by carebiz on 1/12/24.
//

import UIKit
import AlamofireImage

class QnADetailAttachFileItemView: UICollectionViewCell {
    
    @IBOutlet weak var iv_item : UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder : NSCoder) {
        super.init(coder: aDecoder);
    }
    
    func initialize(pathUri: String, file: File) {
        iv_item.contentMode = .scaleAspectFill
        
        iv_item.af.setImage(
            withURL: URL(string: String("\(pathUri)\(file.filePathNm)\(file.atchFileNm)"))!,
            placeholderImage: UIImage(named: "img_blank"),
            filter: AspectScaledToFillSizeFilter(size: iv_item.frame.size)
        )
    }
}
