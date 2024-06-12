//
//  InviteCreateViewController.swift
//  PetTip
//
//  Created by carebiz on 1/5/24.
//

import UIKit

class InviteCreateViewController: CommonViewController {

    @IBOutlet weak var vw_inviteIconBg: UIView!
    @IBOutlet weak var lb_key: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        showBackTitleBarView()

        showCommonUI()
    }

    func showCommonUI() {
        vw_inviteIconBg.layer.cornerRadius = vw_inviteIconBg.bounds.size.width / 2
        vw_inviteIconBg.layer.masksToBounds = true

        lb_key.text = invttKeyVl
    }

    var invttKeyVl: String!

    @IBAction func onCopyKey(_ sender: Any) {
        UIPasteboard.general.string = invttKeyVl

        showToast(msg: "클립보드에 복사되었어요")
    }

    @IBAction func onShareKey(_ sender: Any) {
        var objectsToShare = [String]()
        if let text = invttKeyVl {
            objectsToShare.append(text)
        }

        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view

        // 공유하기 기능 중 제외할 기능이 있을 때 사용
        // activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
        self.present(activityVC, animated: true, completion: nil)
    }

    // MARK: - Back TitleBar
    @IBOutlet weak var titleBarView: UIView!

    func showBackTitleBarView() {
        if let view = UINib(nibName: "BackTitleBarView", bundle: nil).instantiate(withOwner: self).first as? BackTitleBarView {
            view.frame = titleBarView.bounds
            view.lb_title.text = "초대하기"
            view.delegate = self
            titleBarView.addSubview(view)
            self.title = view.lb_title.text
        }
    }
}

extension InviteCreateViewController: BackTitleBarViewProtocol {

    func onBack() {
        navigationController?.popViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
}
