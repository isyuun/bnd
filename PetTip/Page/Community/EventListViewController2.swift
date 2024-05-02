//
//  EventListViewController2.swift
//  PetTip
//
//  Created by isyuun on 2024/5/1.
//

import UIKit

class EventListViewController2: EventListViewController {
    @IBOutlet weak var blankListView: UIStackView!

    override func loadView() {
        super.loadView()
        blankListView(blankListView: self.blankListView)
    }

    override func processNetworkError(_ error: MyError?) {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][error:\(String(describing: error))][\(self.arrEventList.isEmpty)][\(self.arrEventList.count)]")
        super.processNetworkError(error)
        showListBlank(show: self.arrEventList.isEmpty)
    }

    override func event_list(_ isMore: Bool) {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][isMore:\(isMore)][\(self.arrEventList.isEmpty)][\(self.arrEventList.count)]")
        super.event_list(isMore)
    }
}
