//
//  LogoTitleBar.swift
//  PetTip
//
//  Created by carebiz on 12/4/23.
//

import UIKit

class LogoTitleBarView : UIView {
    
    @IBOutlet weak var iv_logo : UIImageView!
    @IBOutlet weak var btn_back : UIButton!
    @IBOutlet weak var profileView : UIView!
    @IBOutlet weak var profileImageView : UIImageView!
    @IBOutlet weak var profileNameLabel : UILabel!
    
    var delegate : LogoTitleBarViewProtocol!
    func setDelegate(_ _delegate : LogoTitleBarViewProtocol) {
        delegate = _delegate
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder : NSCoder) {
        super.init(coder: aDecoder);
    }
    
    func initialize() {
        self.btn_back.alpha = 0
        self.btn_back.isHidden = true
        
        self.profileView.layer.cornerRadius = self.profileView.bounds.size.width / 2
        self.profileView.showShadowMid()
        
        self.profileImageView.layer.cornerRadius = self.profileImageView.bounds.size.width / 2
        self.profileImageView.image = UIImage.init(named: "profile_default")
    }
    
    @IBAction func onShowSelectMyPet(_ sender: Any) {
        if let _delegate = delegate {
            _delegate.onShowSelectMyPet()
        }
    }
    
    @IBAction func onBack(_ sender: Any) {
        if let _delegate = delegate {
            _delegate.onBack()
        }
    }
    
    func changeLogoToBackBtn() {
        iv_logo.alpha = 1
        btn_back.alpha = 0
        self.btn_back.isHidden = false
        UIView.animate(withDuration: 0.6) {
            self.iv_logo.alpha = 0
            self.btn_back.alpha = 1
        } completion: { flag in
            self.iv_logo.isHidden = true
        }
    }
    
    func changeBackBtnToLogo() {
        iv_logo.alpha = 0
        btn_back.alpha = 1
        self.iv_logo.isHidden = false
        UIView.animate(withDuration: 0.6) {
            self.iv_logo.alpha = 1
            self.btn_back.alpha = 0
        } completion: { flag in
            self.btn_back.isHidden = true
        }
    }
}

protocol LogoTitleBarViewProtocol: AnyObject {
    func onShowSelectMyPet()
    func onBack()
}
