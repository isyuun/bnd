//
//  CommonViewController4.swift
//  PetTip
//
//  Created by isyuun on 2024/5/8.
//

import UIKit
import AlamofireImage

class CommonViewController4: CommonViewController3 {
    var schCodeList: [CDDetailList]? {
        get {
            return schCodeList()
        }
        set(value) {
            schCodeList(schCodeList: value)
        }
    }
}

// MARK: - CONN COMMON CODE-LIST
private var _schCodeList: [CDDetailList]?

extension CommonViewController {

    internal func code_list(cmmCdData: [String], complete: (() -> Void)?) {
        if Global.schCodeList != nil {
            filterSchCodeListWithoutWalk()
            complete?()
            return
        }

        self.startLoading()

        let request = CodeListRequest(cmmCdData: cmmCdData)
        CommonAPI.codeList(request: request) { codeList, error in
            self.stopLoading()

            if let codeList = codeList, let data = codeList.data?[0] {
                Global.schCodeList = data.cdDetailList
                self.filterSchCodeListWithoutWalk()
                complete?()
            }

            self.processNetworkError(error)
        }
    }

    private func filterSchCodeListWithoutWalk() {
        if let list = Global.schCodeList {
            _schCodeList = [CDDetailList]()
            for i in 0..<list.count {
                if list[i].cdID != "001" {
                    _schCodeList?.append(list[i])
                }
            }
        }
    }

    internal func schCodeList() -> [CDDetailList]? {
        return _schCodeList
    }

    internal func schCodeList(schCodeList: [CDDetailList]?) {
        _schCodeList = schCodeList
    }
}
