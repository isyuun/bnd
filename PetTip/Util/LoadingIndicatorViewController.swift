//
//  UIViewController.swift
//  PetTip
//
//  Created by carebiz on 11/30/23.
//

import UIKit
import NVActivityIndicatorView

class LoadingIndicatorViewController : UIViewController {
    
    var isLoading = false
    
    var loadingMsg = "로딩중" // 위치정보 확인중
    
    var timeoutTimer : Timer? = nil
    
    lazy var loadingBgView : UIView = {
            let bgView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        bgView.backgroundColor = UIColor.init(hex: "#55000000")
            return bgView
    }()
    
    lazy var loadingIdicatorBgView : UIView = {
        let bgView = UIView(frame: CGRect(x: self.view.bounds.width / 2 - 75, y: self.view.bounds.height / 2 - 75, width: 150, height: 150))
        bgView.backgroundColor = UIColor.white
        bgView.layer.cornerRadius = 10
        bgView.showShadowHeavy()
        return bgView
}()
    
    lazy var loadingIndicatorView = NVActivityIndicatorView(frame: CGRect(x: self.view.bounds.width / 2 - 25, y: self.view.bounds.height / 2 - 25 - 20, width: 50, height: 50),
                                            type: .ballScaleRippleMultiple,
                                            color: .magenta,
                                            padding: 0)
    
    lazy var loadingLabel : UILabel = {
        let label = UILabel(frame: CGRect(x: self.view.bounds.width / 2 - 70, y:self.view.bounds.height / 2 + 20, width: 140, height: 25))
        label.text = loadingMsg
        label.textColor = UIColor.darkGray
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    func startLoading() {
        startLoading(msg: loadingMsg)
    }
    
    func startLoading(msg : String) {
        if (isLoading) { return }
        isLoading = true
        
        if (timeoutTimer != nil) { return }
        
        loadingMsg = msg
        
        self.view.addSubview(loadingBgView)
        self.view.addSubview(loadingIdicatorBgView)
        self.view.addSubview(loadingIndicatorView)
        self.view.addSubview(loadingLabel)
        loadingIndicatorView.startAnimating()
        
        timeoutTimer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(timeoutTimerCallback), userInfo: timeoutTimer, repeats: false)
    }
    
    func stopLoading() {
        if (isLoading == false) { return }
        isLoading = false
        
        loadingIndicatorView.stopAnimating()
        loadingIndicatorView.removeFromSuperview()
        loadingLabel.removeFromSuperview()
        loadingIdicatorBgView.removeFromSuperview()
        loadingBgView.removeFromSuperview()
        
        if (timeoutTimer != nil) {
            timeoutTimer?.invalidate()
            timeoutTimer = nil
        }
    }
    
    @objc func timeoutTimerCallback(timer : Timer?) {
        if (timer == nil) { return }
        
        stopLoading()
        timeoutTimer = nil
    }
}
