//
//  CommonViewController.swift
//  PetTip
//
//  Created by carebiz on 12/2/23.
//

import UIKit
import Toaster

class CommonViewController: LoadingIndicatorViewController {

    func showSimpleAlert(title: String, msg: String) {
        // 출처: https://hongssup.tistory.com/20 [Outgoing Introvert:티스토리]
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
            // let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            // {
            //     (action: UIAlertAction!) in
            //     print("you have pressed the Cancel button")
            // }
            // alertController.addAction(cancelAction)
            let OKAction = UIAlertAction(title: "OK", style: .default)
            {
                (action: UIAlertAction!) in
                print("you have pressed OK button")
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }

    func showSimpleAlert(msg: String) {
        showSimpleAlert(title: "확인", msg: msg)
    }

    private var toast: Toast?
    func showToast(msg: String) {
        self.toast = Toast(text: msg, duration: Delay.short)
        self.toast?.view.bottomOffsetPortrait = 200 //self.view.bounds.size.height / 2
        self.toast?.view.textInsets = UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 25)
        self.toast?.view.font = UIFont.systemFont(ofSize: 18)
        self.toast?.show()
    }

    func processNetworkError(_ error: MyError?) {
        if let error = error {
            NSLog("[LOG][E][(\(#fileID):\(#line))::\(#function)][오류:\(error)][코드:\(error.resCode)][설명:\(error.description)]")
            if error.resCode == 401 {
                let userDef = UserDefaults.standard
                userDef.removeObject(forKey: "accessToken")
                userDef.removeObject(forKey: "refreshToken")
                userDef.synchronize()

                self.showSimpleAlert(msg: "로그인 세션이 만료 되었습니다.\n로그인 화면으로 이동합니다.")
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: {
                    self.moveLoginPage()
                })
                return
            } else if error.resCode == 403 {
                let userDef = UserDefaults.standard
                userDef.removeObject(forKey: "accessToken")
                userDef.removeObject(forKey: "refreshToken")
                userDef.synchronize()

                self.showSimpleAlert(msg: "중복 로그인이 감지되었습니다.\n로그인 화면으로 이동합니다.")
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: {
                    self.moveLoginPage()
                })
                return
            }
            if error.resCode != 200 { self.showSimpleAlert(title: "네트워크 오류발생 [코드:\(error.resCode)]", msg: error.description) }
        }
    }

    // MARK: - MOVE LOGIN PAGE : HTTP 403 Duplicate login JWT Token
    var isAlreadyMoveLoginPage = false
    func moveLoginPage() {
        if isAlreadyMoveLoginPage {
            return
        }
        isAlreadyMoveLoginPage = true

        self.tabBarController?.tabBar.isHidden = true

        let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "LoginViewController") as UIViewController
        self.navigationController?.pushViewController(loginVC, animated: true)
    }

    // MARK: - POPUP VIEW
    var popupBgView: UIControl!
    func showAlertPopup(title: String, msg: String) {
        showAlertPopup(title: title, msg: msg, didTapOK: nil)
    }

    func showAlertPopup(title: String, msg: String, didTapOK: (() -> Void)?) {
        let commonConfirmView = UINib(nibName: "CommonConfirmView", bundle: nil).instantiate(withOwner: self).first as! CommonConfirmView
        commonConfirmView.initialize(title: title, msg: msg, cancelBtnTxt: nil, okBtnTitleTxt: "확인")
        commonConfirmView.didTapOK = {
            self.didTapPopupOK()
            didTapOK?()
        }
        commonConfirmView.didTapCancel = {
            self.didTapPopupCancel()
        }

        popupShow(contentView: commonConfirmView, wSideMargin: 40)
    }

    func showComfirmPopup(title: String, msg: String, didTapOK: (() -> Void)?) {
        let commonConfirmView = UINib(nibName: "CommonConfirmView", bundle: nil).instantiate(withOwner: self).first as! CommonConfirmView
        commonConfirmView.initialize(title: title, msg: msg, cancelBtnTxt: "취소", okBtnTitleTxt: "확인")
        commonConfirmView.didTapOK = {
            self.didTapPopupOK()
            didTapOK?()
        }
        commonConfirmView.didTapCancel = {
            self.didTapPopupCancel()
        }

        popupShow(contentView: commonConfirmView, wSideMargin: 40)
    }
}

// MARK: - PopupModalDelegate
extension CommonViewController: PopupModalDelegate {
    func didTapPopupCancel() {
        self.dismiss(animated: true)
        if (popupBgView != nil) {
            popupBgView.isHidden = true
        }
    }

    func didTapPopupOK() {
        self.dismiss(animated: true)
        if (popupBgView != nil) {
            popupBgView.isHidden = true
        }
    }
}
