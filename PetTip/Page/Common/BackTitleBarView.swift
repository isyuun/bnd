//
//  BackTitleBarView.swift
//  PetTip
//
//  Created by carebiz on 12/14/23.
//

import UIKit

class BackTitleBarView : UIView {
    
    @IBOutlet weak var lb_title : UILabel!
    
    var delegate : BackTitleBarViewProtocol!
    func setDelegate(_ _delegate : BackTitleBarViewProtocol) {
        delegate = _delegate
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder : NSCoder) {
        super.init(coder: aDecoder);
    }
    
    @IBAction func onBack(_ sender: Any) {
        if let _delegate = delegate {
            _delegate.onBack()
        }
    }
}

protocol BackTitleBarViewProtocol: AnyObject {
    func onBack()
}
