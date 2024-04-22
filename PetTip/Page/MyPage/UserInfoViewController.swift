//
//  UserInfo.swift
//  PetTip
//
//  Created by carebiz on 1/1/24.
//

import UIKit

class UserInfoViewController: CommonViewController {
    
    @IBOutlet weak var vw_nickNmBg: UIView!
    @IBOutlet weak var tf_nickNm: UITextField!
    
    @IBOutlet weak var vw_phoneNumBg: UIView!
    @IBOutlet weak var tf_phoneNum: UITextField!
    
    @IBOutlet weak var vw_pwdBg: UIView!
    @IBOutlet weak var tf_pwd: UITextField!
    
    @IBOutlet weak var vw_pwdReBg: UIView!
    @IBOutlet weak var tf_pwdRe: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showBackTitleBarView()
        
        showCommonUI()
    }
    
    func showCommonUI() {
        vw_nickNmBg.layer.borderWidth = 1
        vw_nickNmBg.layer.cornerRadius = 5
        vw_nickNmBg.layer.borderColor = UIColor.init(hex: "#FFE3E9F2")?.cgColor
        
        vw_phoneNumBg.layer.borderWidth = 1
        vw_phoneNumBg.layer.cornerRadius = 5
        vw_phoneNumBg.layer.borderColor = UIColor.init(hex: "#FFE3E9F2")?.cgColor
        
        vw_pwdBg.layer.borderWidth = 1
        vw_pwdBg.layer.cornerRadius = 5
        vw_pwdBg.layer.borderColor = UIColor.init(hex: "#FFE3E9F2")?.cgColor
        
        vw_pwdReBg.layer.borderWidth = 1
        vw_pwdReBg.layer.cornerRadius = 5
        vw_pwdReBg.layer.borderColor = UIColor.init(hex: "#FFE3E9F2")?.cgColor
        
        tf_nickNm.delegate = self
        tf_phoneNum.delegate = self
        tf_pwd.delegate = self
        tf_pwdRe.delegate = self
        
        if let nckNm = UserDefaults.standard.value(forKey: "nckNm") as? String {
            tf_nickNm.text = nckNm
        }
    }
    
    
    
    
    
    // MARK: - CHECK DUPLICATE NICKNAME
    
    var checkedNcknm: String?
    
    @IBAction func onCheckDuplicate(_ sender: Any) {
        reqCloseKeyboard()
        
        chk_ncknm()
    }
    
    func chk_ncknm() {
        tf_nickNm.resignFirstResponder()
        
        guard let nicknm = tf_nickNm.text else { return }
        
        if containsSpecialCharacter(input: nicknm) {
            self.showAlertPopup(title: "알림", msg: "특수문자는 사용 할 수 없습니다")
            return
        }
        
        startLoading()
        
        let request = ChkNcknmRequest(ncknm: nicknm)
        MemberAPI.chkNcknm(request: request) { data, error in
            self.stopLoading()
            
            if let statusCode = data?.statusCode {
                if statusCode == 200 {
                    self.checkedNcknm = self.tf_nickNm.text
                    self.showAlertPopup(title: "알림", msg: "사용하실 수 있는 닉네임입니다")
                } else if statusCode == 406 {
                    self.showAlertPopup(title: "알림", msg: "이미 사용중인 닉네임입니다")
                }
            }
            
            self.processNetworkError(error)
        }
    }
    
    
    
    
    
    // MARK: - SAVE MODIFIED USER INFO
    
    var isChangedNcknm = false
    var isChangedPwd = false
    
    @IBAction func onModify(_ sender: Any) {
        reqCloseKeyboard()
        
        isChangedNcknm = false
        isChangedPwd = false
        
        var _isChangedNcknm = false
        if let nckNm = UserDefaults.standard.value(forKey: "nckNm") as? String {
            if nckNm != tf_nickNm.text {
                if checkedNcknm == nil || checkedNcknm != tf_nickNm.text {
                    self.showAlertPopup(title: "알림", msg: "닉네임 중복확인을 해주세요")
                    return
                } else {
                    _isChangedNcknm = true
                }
            }
        }
        
        var _isChangedPwd = false
        if tf_pwd.text!.count > 0 || tf_pwdRe.text!.count > 0 {
            if tf_pwd.text!.count == 0 {
                self.showAlertPopup(title: "알림", msg: "변경할 비밀번호를 입력해 주세요")
                return
            } else if tf_pwdRe.text!.count == 0 {
                self.showAlertPopup(title: "알림", msg: "비밀번호 확인를 입력해 주세요")
                return
            } else if tf_pwd.text != tf_pwdRe.text {
                self.showAlertPopup(title: "알림", msg: "비밀번호가 일치하지 않습니다")
                return
            } else if tf_pwd.text?.isAlphanumeric == false {
                self.showAlertPopup(title: "알림", msg: "8~16자 영문/숫자 조합으로 입력해 주세요")
                return
//            } else if tf_pwd.text!.count < 7 || tf_pwd.text!.count > 16 {
//                self.showAlertPopup(title: "알림", msg: "8~16자 영문/숫자 조합으로 입력해 주세요")
//                return
            } else {
                _isChangedPwd = true
            }
        }
        
        if (_isChangedNcknm) {
            isChangedNcknm = _isChangedNcknm
        }
        if (_isChangedPwd) {
            isChangedPwd = _isChangedPwd
        }
        if _isChangedNcknm == false && _isChangedPwd == false {
            self.showAlertPopup(title: "알림", msg: "NO Change Info")
        }
        
        if isChangedNcknm == false && isChangedPwd == true {
            reset_password()
        } else if isChangedNcknm == true {
            reset_ncknm()
        }
    }
    
    func reset_ncknm() {
        guard tf_nickNm.text != nil else { return }
        guard let userId = UserDefaults.standard.value(forKey: "userId") as? String else { return }
        
        startLoading()
        
        let request = ResetNcknmRequest(ncknm: self.tf_nickNm.text!, userID: userId)
        MemberAPI.resetNcknm(request: request) { data, error in
            self.stopLoading()
            
            if let statusCode = data?.statusCode {
                if statusCode == 200 {
                    let userDef = UserDefaults.standard
                    userDef.set(self.tf_nickNm.text, forKey: "nckNm")
                    userDef.synchronize()
                    
                    Global.userNckNmBehaviorRelay.accept(self.tf_nickNm.text)
                    
                    if self.isChangedPwd {
                        self.reset_password()
                    } else {
                        self.showAlertPopup(title: "알림", msg: "닉네임이 변경되었습니다")
                    }
                } else if statusCode == 406 {
                    self.showAlertPopup(title: "알림", msg: "이미 사용중인 닉네임입니다")
                }
            }
            
            self.processNetworkError(error)
        }
    }
    
    func reset_password() {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else { return }
        
        startLoading()
        
        let request = ResetPasswordRequest(email: email, userPW: self.tf_pwd.text!)
        MemberAPI.resetPassword(request: request) { data, error in
            self.stopLoading()
            
            if let statusCode = data?.statusCode {
                if statusCode == 200 {
                    self.tf_pwd.text = ""
                    self.tf_pwdRe.text = ""
                    
                    if self.isChangedNcknm && self.isChangedPwd {
                        self.showAlertPopup(title: "알림", msg: "개인정보가 변경되었습니다")
                    } else if self.isChangedPwd {
                        self.showAlertPopup(title: "알림", msg: "비밀번호가 변경되었습니다")
                    }
                } else if statusCode == 406 {
                    self.showAlertPopup(title: "알림", msg: "비밀번호 변경에 실패했습니다")
                }
            }
            
            self.processNetworkError(error)
        }
    }
    
    
    
    
    
    // MARK: - DELETE USER ACCOUNT
    
    @IBAction func onDeleteAcct(_ sender: Any) {
        reqCloseKeyboard()
        
        let commonConfirmView = UINib(nibName: "CommonConfirmView", bundle: nil).instantiate(withOwner: self).first as! CommonConfirmView
        commonConfirmView.initialize(title: "회원 탈퇴하기", msg: "정말 탈퇴하시겠어요?", cancelBtnTxt: "취소", okBtnTitleTxt: "회원 탈퇴하기")
        commonConfirmView.didTapOK = {
            self.didTapPopupOK()
            self.withdraw()
        }
        commonConfirmView.didTapCancel = {
            self.didTapPopupCancel()
        }
        
        popupShow(contentView: commonConfirmView, wSideMargin: 40)
    }
    
    private func withdraw() {
        startLoading()
        
        let request = WithdrawRequest()
        MemberAPI.withdraw(request: request) { data, error in
            self.stopLoading()
            
            if let statusCode = data?.statusCode {
                if statusCode == 200 {
                    self.showAlertPopup(title: "알림", msg: "회원 탈퇴를 완료했습니다")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                        let userDef = UserDefaults.standard
                        userDef.removeObject(forKey: "accessToken")
                        userDef.removeObject(forKey: "refreshToken")
                        userDef.synchronize()
                        
                        self.moveLoginPage()
                    })
                } else {
                    self.showAlertPopup(title: "알림", msg: "회원 탈퇴에 실패했습니다")
                }
            }
            
            self.processNetworkError(error)
        }
    }
        
        
        
        
    
    // MARK: - Back TitleBar
    
    @IBOutlet weak var titleBarView : UIView!
    
    func showBackTitleBarView() {
        if let view = UINib(nibName: "BackTitleBarView", bundle: nil).instantiate(withOwner: self).first as? BackTitleBarView {
            view.frame = titleBarView.bounds
            view.lb_title.text = "개인정보 수정"
            view.delegate = self
            titleBarView.addSubview(view)
        }
    }
    
    
    
    
    
    // MARK: - KEYBOARD
    
    var keyboardShowOriginHeight = 0
    var keyboardShowChangedHeight = 0
    
    @IBAction func onContentViewTap(_ sender: Any) {
        reqCloseKeyboard()
    }
    
    private func reqCloseKeyboard() {
        tf_nickNm.resignFirstResponder()
        tf_phoneNum.resignFirstResponder()
        tf_pwd.resignFirstResponder()
        tf_pwdRe.resignFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        addKeyboardObserver()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeKeyboardObserver()
    }
    
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = keyboardSize.cgRectValue
        
        if keyboardShowOriginHeight == 0 {
            keyboardShowOriginHeight = Int(self.view.frame.size.height)
        }
        
        self.view.frame.size.height = CGFloat(keyboardShowOriginHeight) - keyboardFrame.height
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        self.view.frame.size.height = CGFloat(keyboardShowOriginHeight)
    }
}





// MARK: - TextViewDelegate

extension UserInfoViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case tf_nickNm:
            vw_nickNmBg.layer.borderWidth = 2
            vw_nickNmBg.layer.borderColor = UIColor.init(hex: "#FF000000")?.cgColor
            break
        case tf_phoneNum:
            vw_phoneNumBg.layer.borderWidth = 2
            vw_phoneNumBg.layer.borderColor = UIColor.init(hex: "#FF000000")?.cgColor
            break
        case tf_pwd:
            vw_pwdBg.layer.borderWidth = 2
            vw_pwdBg.layer.borderColor = UIColor.init(hex: "#FF000000")?.cgColor
            break
        case tf_pwdRe:
            vw_pwdReBg.layer.borderWidth = 2
            vw_pwdReBg.layer.borderColor = UIColor.init(hex: "#FF000000")?.cgColor
            break
        default:
            break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case tf_nickNm:
            vw_nickNmBg.layer.borderWidth = 1
            vw_nickNmBg.layer.borderColor = UIColor.init(hex: "#FFE3E9F2")?.cgColor
            break
        case tf_phoneNum:
            vw_phoneNumBg.layer.borderWidth = 1
            vw_phoneNumBg.layer.borderColor = UIColor.init(hex: "#FFE3E9F2")?.cgColor
            break
        case tf_pwd:
            vw_pwdBg.layer.borderWidth = 1
            vw_pwdBg.layer.borderColor = UIColor.init(hex: "#FFE3E9F2")?.cgColor
            break
        case tf_pwdRe:
            vw_pwdReBg.layer.borderWidth = 1
            vw_pwdReBg.layer.borderColor = UIColor.init(hex: "#FFE3E9F2")?.cgColor
            break
        default:
            break
        }
    }
}





extension UserInfoViewController: BackTitleBarViewProtocol {
    func onBack() {
        navigationController?.popViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
}
