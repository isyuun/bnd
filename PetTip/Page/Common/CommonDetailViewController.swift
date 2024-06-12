//
//  CommonDetailViewController.swift
//  PetTip
//
//  Created by carebiz on 12/19/23.
//

import UIKit

class CommonDetailViewController : CommonViewController2 {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        
        showBackTitleBarView()
    }

    // MARK: - Back TitleBar
    @IBOutlet weak var titleBarView : UIView!
    
    var lb_title : UILabel? = nil
    
    func showBackTitleBarView() {
        if let view = UINib(nibName: "BackTitleBarView", bundle: nil).instantiate(withOwner: self).first as? BackTitleBarView {
            view.frame = titleBarView.bounds
            view.lb_title.text = ""
            view.delegate = self
            lb_title = view.lb_title
            titleBarView.addSubview(view)
            self.title = view.lb_title.text
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.title = lb_title?.text
    }
}

extension CommonDetailViewController : BackTitleBarViewProtocol {
    func onBack() {
        navigationController?.popViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
}
