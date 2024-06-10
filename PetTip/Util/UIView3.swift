//
//  UIView3.swift
//  PetTip
//
//  Created by isyuun on 2024/5/9.
//

import UIKit

extension UIView {
    func child(viewType: UIView.Type) -> UIView? {
        // 뷰 컨트롤러의 뷰 계층을 탐색하여 특정 클래스의 뷰가 있는지 확인
        for s in subviews {
            if s.subviews.count > 0, let v = s.child(viewType: viewType) {
                return v
            }
            if s.isKind(of: viewType) {
                return s
            }
        }
        return nil
    }

    func parent(viewType: UIView.Type) -> UIView? {
        // 뷰 컨트롤러의 뷰 계층을 탐색하여 특정 클래스의 뷰가 있는지 확인
        for s in subviews {
            if s.subviews.count > 0, let v = s.child(viewType: viewType) {
                return s
            }
            if s.isKind(of: viewType) {
                return self
            }
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
