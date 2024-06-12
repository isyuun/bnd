//
//  JoinViewController.swift
//  PetTip
//
//  Created by carebiz on 1/15/24.
//

import UIKit

class JoinViewController: CommonPostViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.tabBar.isHidden = true

        showBackTitleBarView()

        showCommonUI()
    }

    @IBOutlet weak var tf_id: UITextField!
    @IBOutlet weak var tf_pw: UITextField!
    @IBOutlet weak var tf_pwRe: UITextField!

    @IBOutlet weak var vw_nickNmBg: UIView!
    @IBOutlet weak var tf_nickNm: UITextField3!
    @IBOutlet weak var btn_nickDupChk: UIButton!

    private func showCommonUI() {
        tf_id.delegate = self
        inputTextNormalUI(view: tf_id)

        tf_pw.delegate = self
        inputTextNormalUI(view: tf_pw)

        tf_pwRe.delegate = self
        inputTextNormalUI(view: tf_pwRe)

        tf_nickNm.delegate = self
        inputTextNormalUI(view: vw_nickNmBg)
        btn_nickDupChk.isHidden = true
    }

    private func inputTextSelectedUI(view: UIView) {
        view.layer.cornerRadius = 4

        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor(hex: "#FF000000")?.cgColor // SELECTED COLOR
    }

    private func inputTextNormalUI(view: UIView) {
        view.layer.cornerRadius = 4

        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(hex: "#ffe3e9f2")?.cgColor // NORMAL COLOR
    }

    @IBAction func onContentViewTap(_ sender: Any) {
        reqCloseKeyboard()
    }

    private func reqCloseKeyboard() {
        tf_id.resignFirstResponder()
        tf_pw.resignFirstResponder()
        tf_pwRe.resignFirstResponder()
        tf_nickNm.resignFirstResponder()
    }

    // MARK: - CHECK DUPLICATE NICKNAME
    var checkedNcknm: String?

    @IBAction func onCheckDuplicate(_ sender: Any) {
        reqCloseKeyboard()

        guard let nicknm = tf_nickNm.text else { return }

        if containsSpecialCharacter(input: nicknm) {
            self.showSimpleAlert(msg: "닉네임은 특수문자를 사용 할 수 없습니다.")
            self.tf_nickNm.becomeFirstResponder()
            return
        }

        self.startLoading()

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

    @IBAction func onComplete(_ sender: Any) {
        reqCloseKeyboard()

        if let id = tf_id.text {
            if id.isEmpty {
                showToast(msg: "아이디를 입력해주세요")
                return
            } else if id.isValidEmail == false {
                showToast(msg: "올바른 이메일형식이 아닙니다")
                return
            }
        }

        if let pw = tf_pw.text {
            if pw.isEmpty {
                showToast(msg: "비밀번호를 입력해주세요")
                return
            } else if pw.isAlphanumeric == false {
                showToast(msg: "올바른 비밀번호 형식이 아닙니다")
                return
            }
        }

        if let pwRe = tf_pwRe.text {
            if pwRe.isEmpty {
                showToast(msg: "비밀번호 확인을 입력해주세요")
                return
            } else if pwRe.isAlphanumeric == false {
                showToast(msg: "올바른 비밀번호 형식이 아닙니다")
                return
            }
        }

        if let pw = tf_pw.text, let pwRe = tf_pwRe.text, pw != pwRe {
            showToast(msg: "비밀번호가 일치하지 않습니다")
            return
        }

        if let nick = tf_nickNm.text {
            if nick.isEmpty {
                self.showSimpleAlert(msg: "닉네임을 입력해주세요")
                self.tf_nickNm.becomeFirstResponder()
                return
            } else {
                if containsSpecialCharacter(input: nick) {
                    self.showSimpleAlert(msg: "닉네임은 특수문자를 사용 할 수 없습니다.")
                    self.tf_nickNm.becomeFirstResponder()
                    return
                }
            }
            if checkedNcknm == nil || checkedNcknm != tf_nickNm.text {
                self.showAlertPopup(title: "알림", msg: "닉네임 중복확인을 해주세요")
                self.tf_nickNm.becomeFirstResponder()
                return
            }
        }

        let petAddViewController = UIStoryboard(name: "Pet", bundle: nil).instantiateViewController(identifier: "PetAddViewController") as PetAddViewController
        petAddViewController.memberData = MemberJoinData(id: tf_id.text!, pw: tf_pw.text!, nick: tf_nickNm.text!, method: "EMAIL")
        self.navigationController?.pushViewController(petAddViewController, animated: true)
    }

    // MARK: - Back TitleBar
    @IBOutlet weak var titleBarView: UIView!

    func showBackTitleBarView() {
        if let view = UINib(nibName: "BackTitleBarView", bundle: nil).instantiate(withOwner: self).first as? BackTitleBarView {
            view.frame = titleBarView.bounds
            view.lb_title.text = "회원가입"
            view.delegate = self
            titleBarView.addSubview(view)
        }
    }
}

extension JoinViewController: BackTitleBarViewProtocol {
    func onBack() {
        navigationController?.popViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
}

extension JoinViewController {

    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == tf_nickNm {
            if let text = textField.text, text.count > 0 {
                btn_nickDupChk.isHidden = false
            } else {
                btn_nickDupChk.isHidden = true
            }
        }
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == tf_nickNm {
            inputTextSelectedUI(view: vw_nickNmBg)
        } else {
            inputTextSelectedUI(view: textField)
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == tf_nickNm {
            inputTextNormalUI(view: vw_nickNmBg)
        } else {
            inputTextNormalUI(view: textField)
        }
    }
}

struct MemberJoinData {
    let id: String
    let pw: String
    let nick: String
    let method: String
}
