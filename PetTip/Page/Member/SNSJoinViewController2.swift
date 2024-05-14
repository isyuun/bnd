//
//  SNSJoinViewController2.swift
//  PetTip
//
//  Created by isyuun on 2024/4/24.
//

import UIKit

class SNSJoinViewController2: SNSJoinViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var content: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func keyboardWillShow(_ notification: NSNotification) {
        super.keyboardWillShow(notification)
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
        super.keyboardWillHide(notification)
        // 키보드가 사라질 때 스크롤뷰의 콘텐츠 영역을 원래대로 돌려놓음
        let insets = UIEdgeInsets.zero
        scrollView.contentInset = insets
        scrollView.scrollIndicatorInsets = insets
    }
}
