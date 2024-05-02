//
//  WinnerListViewController2.swift
//  PetTip
//
//  Created by isyuun on 2024/5/2.
//

import UIKit

class WinnerListViewController2: WinnerListViewController {
    @IBOutlet weak var blankListView: UIStackView!

    override func loadView() {
        super.loadView()
        blankListView(blankListView: self.blankListView)
    }

    override func processNetworkError(_ error: MyError?) {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][error:\(String(describing: error))][\(self.arrWinnerList.isEmpty)][\(self.arrWinnerList.count)]")
        super.processNetworkError(error)
        showListBlank(show: self.arrWinnerList.isEmpty)
    }

    override func winner_list(_ isMore: Bool) {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][isMore:\(String(describing: isMore))][\(self.arrWinnerList.isEmpty)][\(self.arrWinnerList.count)]")
        super.winner_list(isMore)
    }
}
