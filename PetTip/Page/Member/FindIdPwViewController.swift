//
//  FindIdPwViewController.swift
//  PetTip
//
//  Created by carebiz on 1/15/24.
//

import UIKit

class FindIdPwViewController : UIViewController {
    
    public var launchTabPageIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showBackTitleBarView()
    }
    
    
    
    
    
    var containerViewController: FindIdPwContainerViewController?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueFindIdPwToContainer" {
            containerViewController = segue.destination as? FindIdPwContainerViewController
            if let containerViewController = containerViewController {
                containerViewController.launchTabPageIndex = launchTabPageIndex
            }
        }
    }
    
    
    
    
    
    // MARK: - Back TitleBar
    
    @IBOutlet weak var titleBarView : UIView!
    
    @IBOutlet weak var vw_container : UIView!
    
    func showBackTitleBarView() {
        if let view = UINib(nibName: "BackTitleBarView", bundle: nil).instantiate(withOwner: self).first as? BackTitleBarView {
            view.frame = titleBarView.bounds
            view.lb_title.text = "고객센터"
            view.delegate = self
            titleBarView.addSubview(view)
        }
    }
}





extension FindIdPwViewController: BackTitleBarViewProtocol {
    func onBack() {
        navigationController?.popViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
}
