//
//  CommonPopupView3.swift
//  PetTip
//
//  Created by isyuun on 2024/5/8.
//

import UIKit
import AlamofireImage

class CommonPopupView3: CommonPopupView2 {
    // MARK: - CONN COMMON CODE-LIST
    internal var schCodeList: [CDDetailList]?

    internal func code_list(cmmCdData: [String], complete: (() -> Void)?) {
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
                self.filterSchCodeListWithoutWalk()
                complete?()
            }

            // self.processNetworkError(error)
        }
    }

    private func filterSchCodeListWithoutWalk() {
        if let list = Global.schCodeList {
            schCodeList = [CDDetailList]()
            for i in 0..<list.count {
                if list[i].cdID != "001" {
                    schCodeList?.append(list[i])
                }
            }
        }
    }
}

extension CommonPopupView {

    internal func setPetImage(imageView: UIImageView, pet: Pet) {
        var named = "profile_default"
        switch pet.petTypCd {
        case "002":
            named = "cat-profile2"
            break
        default:
            break
        }
        NSLog("[LOG][W][(\(#fileID):\(#line))::\(#function)][imageView:\(imageView)][pet:\(pet)][named:\(named)]")
        if let petRprsImgAddr = pet.petRprsImgAddr {
            imageView.af.setImage(
                withURL: URL(string: petRprsImgAddr)!,
                placeholderImage: UIImage(named: named)!,
                filter: AspectScaledToFillSizeFilter(size: imageView.frame.size)
            )
        } else {
            imageView.image = UIImage(named: named)
        }
    }
}
