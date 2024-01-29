//
//  PopupContentCommonConfirmView.swift
//  popOver
//
//  Created by carebiz on 12/27/23.
//

import UIKit

class CommonConfirmView: CommonPopupView {
    
    @IBOutlet weak var lb_title: UILabel!
    @IBOutlet weak var lb_msg: UILabel!
    @IBOutlet weak var btn_cancel: UIButton!
    @IBOutlet weak var btn_ok: UIButton!
    
    public var didTapOK: (()-> Void)?
    public var didTapCancel: (()-> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder : NSCoder) {
        super.init(coder: aDecoder);
    }
    
    func initialize(title: String, msg: String, cancelBtnTxt: String?, okBtnTitleTxt: String) {
        btn_cancel.layer.borderWidth = 1
        btn_cancel.layer.borderColor = UIColor.darkGray.cgColor
        btn_cancel.layer.cornerRadius = 5
        
        lb_title.text = title
        lb_msg.text = msg
        
        if let cancelBtnTxt = cancelBtnTxt {
            btn_cancel.setAttrTitle(cancelBtnTxt, 12, UIColor.black)
        } else {
            btn_cancel.isHidden = true
        }
        btn_ok.setAttrTitle(okBtnTitleTxt, 12)
    }
    
    @IBAction func onCancel(_ sender: Any) {
        didTapCancel?()
    }
    
    @IBAction func onOK(_ sender: Any) {
        didTapOK?()
    }
}

