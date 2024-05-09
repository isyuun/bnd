//
//  Global3.swift
//  PetTip
//
//  Created by isyuun on 2024/5/9.
//

import Foundation

class Global3: Global2 {
    static func code_list(cmmCdData: [String], complete: (() -> Void)?) {
        if Global.schCodeList != nil {
            filterSchCodeListWithoutWalk()
            complete?()
            return
        }

        // self.startLoading()

        let request = CodeListRequest(cmmCdData: cmmCdData)
        CommonAPI.codeList(request: request) { codeList, error in
            // self.stopLoading()

            if let codeList = codeList, let data = codeList.data?[0] {
                Global.schCodeList = data.cdDetailList
                // self.filterSchCodeListWithoutWalk()
                complete?()
            }

            // self.processNetworkError(error)
        }
    }

    private static func filterSchCodeListWithoutWalk() {
        // if let list = Global.schCodeList {
        //     _schCodeList = [CDDetailList]()
        //     for i in 0..<list.count {
        //         if list[i].cdID != "001" {
        //             _schCodeList?.append(list[i])
        //         }
        //     }
        // }
    }
}
