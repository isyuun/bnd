//
//  UIView3.swift
//  PetTip
//
//  Created by isyuun on 2024/5/9.
//

import UIKit

extension UIView {
    func find(ofType type: UIView.Type) -> UIView? {
        for subview in subviews {
            if subview.isKind(of: type) {
                return subview
            }
            if let recursiveMatch = subview.find(ofType: type) {
                return recursiveMatch
            }
        }
        return nil
    }

    func parent(ofType type: UIView.Type) -> UIView? {
        var parentView = self.superview
        while parentView != nil {
            if parentView!.isKind(of: type) {
                return parentView
            }
            parentView = parentView?.superview
        }
        return nil
    }
}

extension UIView {
    private enum AssociatedKeys {
        static var originalHeight: CGFloat = 0
    }

    var originalHeight: CGFloat {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.originalHeight) as? CGFloat ?? 0
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.originalHeight, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func Show() {
        if originalHeight == 0 {
            originalHeight = frame.height
        }
        setHeightConstraint(to: originalHeight)
        isHidden = false
    }

    func Hide() {
        if originalHeight == 0 {
            originalHeight = frame.height
        }
        setHeightConstraint(to: 0)
        isHidden = true
    }

    private func setHeightConstraint(to height: CGFloat) {
        if let heightConstraint = constraints.first(where: { $0.firstAttribute == .height }) {
            heightConstraint.constant = height
        } else {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        superview?.layoutIfNeeded()
    }
}
