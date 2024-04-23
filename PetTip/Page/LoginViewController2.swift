//
//  LoginViewController2.swift
//  PetTip
//
//  Created by isyuun on 2024/4/19.
//

import UIKit

class LoginViewController2: LoginViewController, UITextFieldDelegate {
    
    @IBOutlet weak var SNSSLoginView: UIView!
    @IBOutlet weak var IDPWLoginView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SNSSLoginView.isHidden = false
#if DEBUG
        IDPWLoginView.isHidden = false
#else
        IDPWLoginView.isHidden = true
#endif
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scrollView.addGestureRecognizer(tap)
        
        // UITextField의 delegate 설정
        inputBoxID.delegate = self
        inputBoxPW.delegate = self
    }
    
    // UITextFieldDelegate 메서드 구현
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        NSLog("[W][LOG][텍스트][textFieldShouldReturn][ID:\(textField == inputBoxID)][PW:\(textField == inputBoxPW)][\(textField)]")
        btnLogin.isUserInteractionEnabled = true
        if textField == inputBoxID {
            // usernameTextField에서 리턴 키를 눌렀을 때 passwordTextField로 포커스 이동
            inputBoxPW.becomeFirstResponder()
        } else if textField == inputBoxPW {
            // passwordTextField에서 리턴 키를 눌렀을 때 로그인 처리 메서드 호출
            btnLogin.becomeFirstResponder()
            login()
        }
        return true
    }
    
    override func keyboardWillShow(_ notification: NSNotification) {
        // 키보드 높이 가져오기
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            // 스크롤뷰의 콘텐츠 영역을 키보드의 높이만큼 조정
            let insets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            scrollView.contentInset = insets
            scrollView.scrollIndicatorInsets = insets
            scrollView.scroll(to: .bottom)
        }
    }
    
    override func keyboardWillHide(_ notification: NSNotification) {
        // 키보드가 사라질 때 스크롤뷰의 콘텐츠 영역을 원래대로 돌려놓음
        let insets = UIEdgeInsets.zero
        scrollView.contentInset = insets
        scrollView.scrollIndicatorInsets = insets
    }
    
}
