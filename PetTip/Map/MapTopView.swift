//
//  MapTipView.swift
//  PetTip
//
//  Created by carebiz on 11/29/23.
//

import UIKit

class MapTopView : UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }
    
    required init?(coder aDecoder : NSCoder) {
        super.init(coder: aDecoder);
        
        initialize()
    }
    
    private func initialize() {
        self.layer.cornerRadius = 15
        self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        self.layer.masksToBounds = true
        
        self.layer.borderColor = UIColor.init(hex: "#4E608526")?.cgColor
        self.layer.borderWidth = 1
    }
    
    
    
    var mapTipView : UIView?
    
    func showMapTipView() {
        if let view = UINib(nibName: "MapTipView", bundle: nil).instantiate(withOwner: self).first as? UIView {
            mapTipView = view
            view.frame = self.bounds
            self.addSubview(view)
        }
    }
    
    func hideMapTipView() {
        if (mapTipView != nil) {
            mapTipView?.removeFromSuperview()
            mapTipView = nil
        }
    }
    
    
    
    var mapNavView : MapNavView?
    
    func showMapNavView() {
        if let view = UINib(nibName: "MapNavView", bundle: nil).instantiate(withOwner: self).first as? MapNavView {
            mapNavView = view
            view.frame = self.bounds
            self.addSubview(view)
            
            mapNavView?.initialize()
        }
    }
    
    func hideMapNavView() {
        if (mapNavView != nil) {
            mapNavView?.removeFromSuperview()
            mapNavView = nil
        }
    }
}
