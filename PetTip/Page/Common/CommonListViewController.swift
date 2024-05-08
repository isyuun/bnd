//
//  CommonListViewController.swift
//  PetTip
//
//  Created by isyuun on 2024/5/2.
//

import UIKit

class CommonListViewController: CommonViewController4 {
    private var blankListView: UIStackView?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.showListBlank(show: false)
    }

    internal func blankListView(blankListView: UIStackView?) {
        self.blankListView = blankListView
    }

    internal func showListBlank(show: Bool) {
        self.blankListView?.isHidden = !show
        self.blankListView?.layoutIfNeeded()
    }

    override func processNetworkError(_ error: MyError?) {  }
}
