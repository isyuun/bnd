//
//  LoginViewController2.swift
//  PetTip
//
//  Created by isyuun on 2024/4/19.
//

import UIKit

class LoginViewController2: LoginViewController {

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

        // // 키보드 등록 알림을 받음
        // NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        // NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        // 
        // // 스크롤뷰의 콘텐츠 크기 설정
        // scrollView.contentSize = contentView.frame.size
	}


    // override func keyboardWillShow(_ notification: NSNotification) {
    //     super.keyboardWillShow(notification)
    //     // 키보드 높이 가져오기
    //     if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
    //         // 스크롤뷰의 콘텐츠 영역을 키보드의 높이만큼 조정
    //         let insets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
    //         scrollView.contentInset = insets
    //         scrollView.scrollIndicatorInsets = insets
    //     }
    // }
    // 
    // override func keyboardWillHide(_ notification: NSNotification) {
    //     // 키보드가 사라질 때 스크롤뷰의 콘텐츠 영역을 원래대로 돌려놓음
    //     let insets = UIEdgeInsets.zero
    //     scrollView.contentInset = insets
    //     scrollView.scrollIndicatorInsets = insets
    // }
}
