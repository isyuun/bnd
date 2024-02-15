//
//  MapBottomView.swift
//  PetTip
//
//  Created by carebiz on 12/1/23.
//

import UIKit

class MapBottomView : UIView {
    
    @IBOutlet weak var walkInfoBGView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distLabel: UILabel!
    
    var delegate : MapBottomViewProtocol!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder : NSCoder) {
        super.init(coder: aDecoder);
    }
    
    func initialize() {
        walkInfoBGView.layer.cornerRadius = 20
        walkInfoBGView.layer.masksToBounds = true
    }
    
    func setDelegate(_ _delegate : MapBottomViewProtocol) {
        delegate = _delegate
    }
    
    func refresh(time: String, dist : String) {
        timeLabel.text = time
        distLabel.text = dist
    }
    
    @IBAction func onExit(_ sender: Any) {
        if (delegate != nil) {
            delegate.mapBottomViewOnExit()
        }
    }
    
    @IBAction func onContinue(_ sender: Any) {
        if (delegate != nil) {
            delegate.mapBottomViewOnContinue()
        }
    }
}

protocol MapBottomViewProtocol: AnyObject {
    func mapBottomViewOnExit()
    func mapBottomViewOnContinue()
}
