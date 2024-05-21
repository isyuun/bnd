//
//  PetModViewController.swift
//  PetTip
//
//  Created by carebiz on 1/28/24.
//

import UIKit
import AlamofireImage

class PetModViewController2: PetModViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setCurrInfo()
    }

    override func onPetType(_ sender: Any) {
        guard let button = sender as? UIButton else { return }
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][sender:\(sender)]")
        super.onPetType(sender)

        let pet = petDetailInfo
        let petImgAddr = pet?.petRprsImgAddr
        let petTypCd = pet?.petTypCd

        var _petTypCd = "001"
        switch button {
        case btn_petTypeDog:
            _petTypCd = "001"
            break
        case btn_petTypeCat:
            _petTypCd = "002"
            break
        default:
            break
        }

        if petTypCd == _petTypCd { Global2.setPetImage(imageView: iv_profile, petTypCd: _petTypCd, petImgAddr: petImgAddr) }
        else { Global2.setPetImage(imageView: iv_profile, petTypCd: _petTypCd) }
    }

    override func onComplete(_ sender: Any) {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][sender:\(sender)]")
        if let petName = tf_petNm.text {
            if containsSpecialCharacter(input: petName) {
                self.showSimpleAlert(msg: "펫명은 특수문자를 사용 할 수 없습니다.")
                tf_petNm.becomeFirstResponder()
                return
            }
        }
        super.onComplete(sender)
    }
}
