//
//  CustomTabBar.swift
//  PetTip
//
//  Created by carebiz on 12/2/23.
//

import UIKit

class CustomTabBar : UITabBar {
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        super.sizeThatFits(size)
        var sizeThatFits = super.sizeThatFits(size)
        if #available(iOS 11.0, *), let keyWindow = UIApplication.shared.windows.first, keyWindow.safeAreaInsets.bottom > 0 {
            sizeThatFits.height = 90
        } else {
            sizeThatFits.height = 60
        }
        
        return sizeThatFits
    }
}
