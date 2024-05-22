//
//  InviteCreateViewController2.swift
//  PetTip
//
//  Created by isyuun on 2024/5/22.
//

import UIKit

class InviteCreateViewController2: InviteCreateViewController {
    var petNames: [String] = []
    // let petNames: [String] = ["나나", "미미", "랄라"]

    override func onShareKey(_ sender: Any) {
        if let invttKeyVl = self.invttKeyVl {
            let nickName = Global.userNckNmBehaviorRelay.value!
            let petNames = "[\(self.petNames.joined(separator: ", "))]"
            let text = "\(nickName)님이 펫팁으로 초대했어요!"
                + "\n\(petNames) 관리에 동참하시겠어요?"
                + "\n초대코드등록란에 [\(invttKeyVl)]를 입력해주세요."
                + "\n\(Global.DOMAIN)/invitation/\(invttKeyVl)"

            var objectsToShare = [String]()
            objectsToShare.append(text)

            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = self.view

            // 공유하기 기능 중 제외할 기능이 있을 때 사용
            // activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
            self.present(activityVC, animated: true, completion: nil)
        }
    }
}
