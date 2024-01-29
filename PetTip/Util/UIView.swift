//
//  UIView.swift
//  PetTip
//
//  Created by carebiz on 11/30/23.
//

import UIKit

extension UIView {
    
    func showShadowLight() {
        self.layer.shadowColor = UIColor.init(hex: "#70000000")?.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 0.5
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowPath = nil
    }
    
    func showShadowMid() {
        self.layer.shadowColor = UIColor.init(hex: "#70000000")?.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 1
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowPath = nil
    }
    
    func showShadowHeavy() {
        self.layer.shadowColor = UIColor.init(hex: "#70000000")?.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 2
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.layer.shadowPath = nil
    }
}
