//
//  WalkPostViewController3.swift
//  PetTip
//
//  Created by Ahn Je Wook on 6/17/24.
//

import UIKit

class WalkPostViewController3: WalkPostViewController2 {
    
    override func viewDidLoad() {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)]")
        super.viewDidLoad()

        self.tabBarController?.tabBar.isHidden = true
        
        showBackTitleBarView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideBackTitleBarView()
    }

    
    // MARK: - Back TitleBar
    @IBOutlet weak var titleBarView : UIView!
    
    var lb_title : UILabel? = nil
    
    func showBackTitleBarView() {
        if let view = UINib(nibName: "BackTitleBarView", bundle: nil).instantiate(withOwner: self).first as? BackTitleBarView {
            view.frame = titleBarView.bounds
            view.lb_title.text = "산책기록"
            view.delegate = self
            lb_title = view.lb_title
            titleBarView.addSubview(view)
            self.title = lb_title?.text
        }
    }
    
}

extension WalkPostViewController3: BackTitleBarViewProtocol {
    func onBack() {
                
        let commonConfirmView = UINib(nibName: "CommonConfirmView", bundle: nil).instantiate(withOwner: self).first as! CommonConfirmView
        commonConfirmView.initialize(title: "글 작성을 그만하시겠습니까?", msg: "작성중인 글은 삭제됩니다.", cancelBtnTxt: "더 작성할래요", okBtnTitleTxt: "나가기")
        commonConfirmView.didTapCancel = {
            self.didTapPopupCancel()
        }
        commonConfirmView.didTapOK = {
            self.navigationController?.popToRootViewController(animated: true)
            self.tabBarController?.tabBar.isHidden = false
            self.didTapPopupOK()
        }

        popupShow(contentView: commonConfirmView, wSideMargin: 40)

    }
}
