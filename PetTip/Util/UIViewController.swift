//
//  UIViewController.swift
//  PetTip
//
//  Created by carebiz on 1/21/24.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func hideBackTitleBarView() {
        if let navigationController = navigationController, !navigationController.isNavigationBarHidden {
            guard let v = view else { return }
            if let c = v.find(ofType: BackTitleBarView.self) as? BackTitleBarView {
                navigationController.title = c.lb_title.text
                // if let p = c.parent(ofType: UIView.self) {
                if let p = c.superview {
                    NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][\(p)][\(c)]")
                    p.Hide()
                }
            }
        }
    }
}
