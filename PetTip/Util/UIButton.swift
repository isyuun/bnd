//
//  UIButton.swift
//  PetTip
//
//  Created by carebiz on 11/25/23.
//

import UIKit

extension UIButton {
    
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1.0, height: 1.0))
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0))
        
        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
         
        self.setBackgroundImage(backgroundImage, for: state)
    }
    
    func setAttrTitle(_ title: String, _ fontSize: Int) {
        setAttrTitle(title, fontSize, UIColor.white)
    }
    
    func setAttrTitle(_ title: String, _ fontSize: Int, _ fontColor: UIColor) {
        let attrubutes : [NSAttributedString.Key : Any] = [
            .font : UIFont.systemFont(ofSize: CGFloat(fontSize)),
            .foregroundColor : fontColor
        ]
        setAttributedTitle(NSAttributedString(string: title, attributes: attrubutes), for: .normal)
    }
}
