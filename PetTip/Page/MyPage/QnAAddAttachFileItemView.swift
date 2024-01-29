//
//  QnAAddAttachFileItemView.swift
//  PetTip
//
//  Created by carebiz on 1/12/24.
//

import UIKit

class QnAAddAttachFileItemView: UICollectionViewCell {
    
    @IBOutlet weak var iv_item : UIImageView!
    
    @IBOutlet weak var btn_addItem : UIButton!
    
    @IBOutlet weak var vw_btnRemoveArea : UIView!
    
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
    }
    
    func initialize(image: UIImage) {
        initialize()
        
        iv_item.contentMode = .scaleAspectFill
        iv_item.image = image
        
        vw_btnRemoveArea.isHidden = false
    }
    
    func initializeModeAddImage() {
        initialize()
        
        iv_item.contentMode = .center
        iv_item.image = UIImage(named: "picture_plus")
//        iv_item.image = UIImage(named: "img_blank")
        
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
