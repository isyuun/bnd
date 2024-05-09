//
//  StoryListViewController2.swift
//  PetTip
//
//  Created by isyuun on 2024/5/2.
//

import UIKit

class StoryListViewController2: StoryListViewController {
    @IBOutlet weak var blankListView: UIStackView!

    override func loadView() {
        super.loadView()
        blankListView(blankListView: self.blankListView)
    }

    override func processNetworkError(_ error: MyError?) {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][error:\(String(describing: error))][\(self.arrStoryList.isEmpty)][\(self.arrStoryList.count)]")
        super.processNetworkError(error)
        showListBlank(show: self.arrStoryList.isEmpty)
    }

    override func story_list(_ isMore: Bool) {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][isMore:\(isMore)][\(self.arrStoryList.isEmpty)][\(self.arrStoryList.count)]")
        code_list(cmmCdData: ["SCH"]) {
            NSLog("[LOG][W][(\(#fileID):\(#line))::\(#function)][Global.schCodeList:\(String(describing: Global.schCodeList))]")
            super.story_list(isMore)
        }
    }
}
