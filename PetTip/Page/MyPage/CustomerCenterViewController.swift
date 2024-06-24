//
//  CustomerCenter.swift
//  PetTip
//
//  Created by carebiz on 1/10/24.
//

import UIKit

class CustomerCenterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        showBackTitleBarView()

        showCommonUI()
    }

    private func showCommonUI() { }

    // MARK: - Back TitleBar
    @IBOutlet weak var titleBarView: UIView!

    func showBackTitleBarView() {
        if let view = UINib(nibName: "BackTitleBarView", bundle: nil).instantiate(withOwner: self).first as? BackTitleBarView {
            view.frame = titleBarView.bounds
            view.lb_title.text = "고객센터"
            view.delegate = self
            titleBarView.addSubview(view)
            self.title = view.lb_title.text
        }
    }
}

extension CustomerCenterViewController: BackTitleBarViewProtocol {
    func onBack() {
        navigationController?.popViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
}
