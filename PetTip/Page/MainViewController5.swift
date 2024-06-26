//
//  MainViewController5.swift
//  PetTip
//
//  Created by Ahn Je Wook on 6/25/24.
//

import UIKit
import CoreLocation

class MainViewController5: MainViewController4 {

    override func viewDidLoad() {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)]")
        super.viewDidLoad()

        // 화면이 뜨고 여유있게 보여주기
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.checkWalkTrack()
        })
    }
    
    // 이전에 끊긴 데이터가 있가 체크
    func checkWalkTrack() {
        
        guard let appDelegate = AppDelegate4.instance as? AppDelegate4,
              let walkingController = appDelegate.walkingController
        else {
            return
        }
        guard walkingController.checkWalkTrack() == true else {
            return
        }
        showAlertWalkTrack()
    }
    
    // 이전에 끊긴 데이터가 있가 이어하기 문의
    func showAlertWalkTrack() {
        
        let commonConfirmView = UINib(nibName: "CommonConfirmView", bundle: nil).instantiate(withOwner: self).first as! CommonConfirmView
        commonConfirmView.initialize(title: "한참 산책중 이었습니다", msg: "기존 산책을 복원할까요?", cancelBtnTxt: "그만할게요", okBtnTitleTxt: "계속할게요")
        commonConfirmView.didTapCancel = {
            // 데이터 제거
            guard let appDelegate = AppDelegate4.instance as? AppDelegate4 else {
                return
            }
            appDelegate.walkingController?.clearTrackFromUserDefaults()
            self.didTapPopupCancel()
        }
        commonConfirmView.didTapOK = {
            self.checkWalkBtn()
            self.performSegue(withIdentifier: "segueMainToMap", sender: self)
            self.didTapPopupOK()
        }

        popupShow(contentView: commonConfirmView, wSideMargin: 40)
    }



}
