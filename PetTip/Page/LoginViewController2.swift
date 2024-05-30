//
//  LoginViewController2.swift
//  PetTip
//
//  Created by isyuun on 2024/4/19.
//

import UIKit

class LoginViewController2: LoginViewController {

    // override func keyboardWillShow(_ notification: NSNotification) {
    //     super.keyboardWillShow(notification)
    //     // 키보드 높이 가져오기
    //     if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
    //         // 스크롤뷰의 콘텐츠 영역을 키보드의 높이만큼 조정
    //         let insets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
    //         scroll.contentInset = insets
    //         scroll.scrollIndicatorInsets = insets
    //         scroll.scroll(to: .bottom)
    //     }
    // }
    //
    // override func keyboardWillHide(_ notification: NSNotification) {
    //     super.keyboardWillHide(notification)
    //     // 키보드가 사라질 때 스크롤뷰의 콘텐츠 영역을 원래대로 돌려놓음
    //     let insets = UIEdgeInsets.zero
    //     scroll.contentInset = insets
    //     scroll.scrollIndicatorInsets = insets
    // }

    @IBOutlet weak var SNSSLoginView: UIView!
    @IBOutlet weak var IDPWLoginView: UIView!

    @IBOutlet weak var vwLoginKakao: UIView!
    @IBOutlet weak var vwLoginNaver: UIView!
    @IBOutlet weak var vwLoginFacebook: UIView!
    @IBOutlet weak var vwLoginGoogle: UIView!
    @IBOutlet weak var vwLoginApple: UIView!

    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var content: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()

        SNSSLoginView.isHidden = false
        vwLoginKakao.isHidden = false
        vwLoginNaver.isHidden = false
        vwLoginFacebook.isHidden = false
        vwLoginGoogle.isHidden = false
        vwLoginApple.isHidden = false

        #if DEBUG
            IDPWLoginView.isHidden = false
            vwLoginFacebook.isHidden = true
            vwLoginGoogle.isHidden = false
        #else
            IDPWLoginView.isHidden = true
            vwLoginFacebook.isHidden = true
            vwLoginGoogle.isHidden = true
        #endif

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scroll.addGestureRecognizer(tap)
    }

    // UITextFieldDelegate 메서드 구현
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        NSLog("[LOG][W][(\(#fileID):\(#line))::\(#function)][ID:\(textField == inputBoxID)][PW:\(textField == inputBoxPW)][textField:\(textField)]")
        let ret = super.textFieldShouldReturn(textField)
        btnLogin.isUserInteractionEnabled = true
        if textField == inputBoxID {
            // usernameTextField에서 리턴 키를 눌렀을 때 passwordTextField로 포커스 이동
            inputBoxPW.becomeFirstResponder()
        } else if textField == inputBoxPW {
            // passwordTextField에서 리턴 키를 눌렀을 때 로그인 처리 메서드 호출
            btnLogin.becomeFirstResponder()
            login()
        }
        return ret
    }
}
