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

    var walkingController: WalkingController?

    override func viewDidLoad() {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)]")
        super.viewDidLoad()

        self.tabBarController?.tabBar.isHidden = true
        
        showBackTitleBarView()
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate4 {
            walkingController = appDelegate.walkingController
            walkingController?.delegate = self
        }
    }
    
    @IBAction func onBtnWalkTest(_ sender: Any) {
        
        guard let walkingController = walkingController else {
            return;
        }
        walkingController.startWalkingProcess()
//        walkingController.arrTrack(arrTrack.last)
        
    }

    // MARK: - Back TitleBar
    @IBOutlet weak var titleBarView : UIView!
    
    var lb_title : UILabel? = nil
    
    func showBackTitleBarView() {
//        if let view = UINib(nibName: "BackTitleBarView", bundle: nil).instantiate(withOwner: self).first as? BackTitleBarView {
//            view.frame = titleBarView.bounds
//            view.lb_title.text = "산책하기"
//            view.delegate = self
//            lb_title = view.lb_title
//            titleBarView.addSubview(view)
//        }
    }
}


extension NMapViewController: LocationControllerDelegate {
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
        let requestLocationServiceAlert = UIAlertController(title: "오류사항", message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "확인", style: .default) { _ in

        }
        // let cancel = UIAlertAction(title: "취소", style: .default) { [weak self] _ in
        //     async { await self?.reloadData() }
        // }
        requestLocationServiceAlert.addAction(cancel)
        present(requestLocationServiceAlert, animated: true)

    }
}
