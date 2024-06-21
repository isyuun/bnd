//
//  NMapViewController5.swift
//  PetTip
//
//  Created by Ahn Je Wook on 6/11/24.
//

import UIKit
import NMapsMap
import AVKit

class NMapViewController5: NMapViewController4 {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][\(String(describing: AppDelegate4.instance as? AppDelegate4))]")
        if let appDelegate = AppDelegate4.instance as? AppDelegate4 {
            walkingController = appDelegate.walkingController
            walkingController?.delegate = self
        }

        // Foreground 상태로 변경될때 호출
        NotificationCenter.default.addObserver(self, selector: #selector(enterForegroundNotification), name: UIScene.willEnterForegroundNotification, object: nil)
        
        self.mapView.positionMode = self.mapPositionMode
        loadMapCameraData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][\(String(describing: AppDelegate4.instance as? AppDelegate4))]")
        if let appDelegate = AppDelegate4.instance as? AppDelegate4 {
            if appDelegate.walkingController?.bWalkingState == false {
                appDelegate.walkingController?.stopContinueLocation();
            }
            appDelegate.walkingController?.delegate = nil
        }
        NotificationCenter.default.removeObserver(self)
    }

    @objc func enterForegroundNotification() {
        print("enterForegroundNotification")
        
        if walkingController?.bWalkingState == true {
            // 데이터 로드
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.loadWalkingProcess()
            })
        }
    }
    
    override func viewDidLoad() {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)]")
        super.viewDidLoad()

        self.tabBarController?.tabBar.isHidden = true
        
        showBackTitleBarView()
        initWalkingInfo()

        self.mapView.positionMode = self.mapPositionMode
        loadMapCameraData()
    }

    
    // MARK: - Back TitleBar
    @IBOutlet weak var titleBarView : UIView!
    var lb_title : UILabel? = nil
    
    func showBackTitleBarView() {
        if let view = UINib(nibName: "BackTitleBarView", bundle: nil).instantiate(withOwner: self).first as? BackTitleBarView {
            view.frame = titleBarView.bounds
            view.lb_title.text = "산책하기"
            view.delegate = self
            lb_title = view.lb_title
            titleBarView.addSubview(view)
            self.title = lb_title?.text
        }
    }
    
    // MARK: - 데이터 로드
    func initWalkingInfo() {
        // walkingController Object 추가
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][\(String(describing: AppDelegate4.instance as? AppDelegate4))]")
        if let appDelegate = AppDelegate4.instance as? AppDelegate4 {
            walkingController = appDelegate.walkingController
            walkingController?.delegate = self
            
            checkWalkingState()
            if walkingController?.bWalkingState == true {
                // 데이터 로드
                loadWalkingProcess()
            } else {
                walkingController?.requestLocation(type: 1)
            }
        }
    }

    func checkWalkingState() {
        if walkingController?.bWalkingState == true {
            btnWalk.tintColor = UIColor.init(hexCode: "F54F68")
            btnWalk.setAttrTitle("산책종료", 14)

            self.mapTopView.hideMapTipView()
            self.mapTopView.showMapNavView()
            self.mapTopView.mapNavView?.timeLabel.text = "00:00:00"
            self.mapTopView.mapNavView?.distLabel.text = "0.00 km"

            btnPee.isHidden = false
            btnPoo.isHidden = false
            btnMrk.isHidden = false
        } else {
            btnWalk.tintColor = UIColor.init(hexCode: "4783F5")
            btnWalk.setAttrTitle("산책하기", 14)

            self.mapTopView.showMapTipView()
            self.mapTopView.hideMapNavView()

            btnPee.isHidden = true
            btnPoo.isHidden = true
            btnMrk.isHidden = true
        }
    }
    
    
    internal override func startWalkingProcess() {
        super.startWalkingProcess()
        
        guard let walkingController = walkingController else {
            return;
        }
        walkingController.startWalkingProcess()
    }
    
    override func showNoPet() {
        super.showNoPet()
        self.onBack()
    }

}


extension NMapViewController: LocationControllerDelegate {
    func didUpdateLocations(_ locations: [CLLocation]) {
        updateCurrLocation(locations);
    }

    func successLocationServiceAuthorization() {
        
    }
    
    func failedLocationServiceAuthorization() {
        let requestLocationServiceAlert = UIAlertController(title: "위치 정보 이용", message: "위치 서비스를 사용할 수 없습니다.\n디바이스의 '설정 > 개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
        let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .default) { _ in

        }
        // let cancel = UIAlertAction(title: "취소", style: .default) { [weak self] _ in
        //     async { await self?.reloadData() }
        // }
        requestLocationServiceAlert.addAction(cancel)
        requestLocationServiceAlert.addAction(goSetting)

        present(requestLocationServiceAlert, animated: true)
    }
    
    func errorLocationService(message: String?) {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][error message : \(message ?? "Location ERROR")]")
    }

    func walkingTimerCallback() {
        statusViewTimerCallback()
    }

    
}

extension NMapViewController5: BackTitleBarViewProtocol {
    func onBack() {
        navigationController?.popViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
}
