//
//  UIViewController.swift
//  PetTip
//
//  Created by carebiz on 11/30/23.
//

import UIKit
import NVActivityIndicatorView

class LoadingIndicatorViewController: UIViewController {

    var isLoading = false

    var loadingMsg = "로딩중" // 위치정보 확인중

    var timeoutTimer: Timer? = nil

    lazy var loadingBgView: UIView = {
        let bgView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        bgView.backgroundColor = UIColor.init(hex: "#55000000")
        return bgView
    }()

    lazy var loadingIdicatorBgView: UIView = {
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

    lazy var loadingLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: self.view.bounds.width / 2 - 70, y: self.view.bounds.height / 2 + 20, width: 140, height: 25))
        label.text = loadingMsg
        label.textColor = UIColor.darkGray
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textAlignment = NSTextAlignment.center
        return label
    }()

    func startLoading() {
        startLoading(msg: loadingMsg)
    }

    func startLoading(msg: String) {
        if (isLoading) { return }
        isLoading = true

        if (timeoutTimer != nil) { return }

        loadingMsg = msg

        // 출처: https://hongssup.tistory.com/20 [Outgoing Introvert:티스토리]
        DispatchQueue.main.async {
            self.view.addSubview(self.loadingBgView)
            self.view.addSubview(self.loadingIdicatorBgView)
            self.view.addSubview(self.loadingIndicatorView)
            self.view.addSubview(self.loadingLabel)
            self.loadingIndicatorView.startAnimating()
            self.timeoutTimer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(self.timeoutTimerCallback), userInfo: self.timeoutTimer, repeats: false)
        }

    }

    func stopLoading() {
        if (isLoading == false) { return }
        isLoading = false

        // 출처: https://hongssup.tistory.com/20 [Outgoing Introvert:티스토리]
        DispatchQueue.main.async { [self] in
            self.loadingIndicatorView.stopAnimating()
            self.loadingIndicatorView.removeFromSuperview()
            self.loadingLabel.removeFromSuperview()
            self.loadingIdicatorBgView.removeFromSuperview()
            self.loadingBgView.removeFromSuperview()
            if (self.timeoutTimer != nil) {
                self.timeoutTimer?.invalidate()
                timeoutTimer = nil
            }
        }
    }

    @objc func timeoutTimerCallback(timer: Timer?) {
        if (timer == nil) { return }

        stopLoading()
        timeoutTimer = nil
    }
}
