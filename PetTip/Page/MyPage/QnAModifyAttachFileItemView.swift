//
//  QnAModifyAttachFileItemView.swift
//  PetTip
//
//  Created by carebiz on 1/13/24.
//

import UIKit
import AlamofireImage

class QnAModifyAttachFileItemView: UICollectionViewCell {
    
    @IBOutlet weak var iv_item : UIImageView!
    
    @IBOutlet weak var btn_addItem : UIButton!
    
    @IBOutlet weak var vw_btnRemoveArea : UIView!
    
    @IBOutlet weak var lb_representative : UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder : NSCoder) {
        super.init(coder: aDecoder);
    }
    
    private func initialize() {
        vw_btnRemoveArea.layer.cornerRadius = vw_btnRemoveArea.bounds.size.width / 2
        vw_btnRemoveArea.layer.borderColor = UIColor.init(hex: "#FF222222")?.cgColor
        vw_btnRemoveArea.layer.borderWidth = 1
        
        iv_item.layer.cornerRadius = 10
        iv_item.layer.borderColor = UIColor.init(hex: "#FFE3E9F2")?.cgColor
        iv_item.layer.borderWidth = 1
        iv_item.backgroundColor = UIColor.init(hex: "#FFF6F8FC")
        
        lb_representative?.backgroundColor = UIColor.init(hex: "#88000000")
        lb_representative?.layer.cornerRadius = 10
        lb_representative?.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        lb_representative?.layer.masksToBounds = true
        lb_representative?.isHidden = true
    }
    
    func initialize(pathUri: String, data: AtchHybridData) {
        initialize()
        
        iv_item.contentMode = .scaleAspectFill
        
        if let local = data.local {
            iv_item.image = local
        } else if let remote = data.remote {
            iv_item.af.setImage(
                withURL: URL(string: String("\(pathUri)\(remote.filePathNm)\(remote.atchFileNm)"))!,
                placeholderImage: UIImage(named: "img_blank"),
                filter: AspectScaledToFillSizeFilter(size: iv_item.frame.size)
            )
        }
        
        vw_btnRemoveArea.isHidden = false
    }
    
    func initialize(pathUri: String, data: StoryAtchHybridData) {
        initialize()
        
        iv_item.contentMode = .scaleAspectFill
        
        if let local = data.local {
            iv_item.image = local
        } else if let remote = data.remote {
            iv_item.af.setImage(
                withURL: URL(string: String("\(pathUri)\(remote.filePathNm)\(remote.atchFileNm)"))!,
                placeholderImage: UIImage(named: "img_blank"),
                filter: AspectScaledToFillSizeFilter(size: iv_item.frame.size)
            )
        }
        
        vw_btnRemoveArea.isHidden = false
    }
    
    func markRepresentative(flag: Bool) {
        if flag {
            lb_representative?.isHidden = false
        } else {
            lb_representative?.isHidden = true
        }
    }
    
    func initializeModeAddImage() {
        initialize()
        
        iv_item.contentMode = .center
        iv_item.image = UIImage(named: "picture_plus")
        
        vw_btnRemoveArea.isHidden = true
        
        btn_addItem.addTarget(self, action: #selector(onAddItem(_:)), for: .touchUpInside)
    }
    
    @objc private func onAddItem(_ sender: Any) {
        didOnAddItem?()
    }
    
    @IBAction func onRemoveItem(_ sender: Any) {
        didOnRemoveItem?()
    }
    
    public var didOnAddItem: (()-> Void)?
    public var didOnRemoveItem: (()-> Void)?
}
