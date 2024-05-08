//
//  MyPageCompPetListItemView.swift
//  PetTip
//
//  Created by carebiz on 12/31/23.
//

import UIKit
import AlamofireImage

class MyPageCompPetListItemView: UITableViewCell {

    @IBOutlet weak var vw_borderView: UIView!
    @IBOutlet weak var vw_profIvBorder: UIView!
    @IBOutlet weak var iv_prof: UIImageView!
    @IBOutlet weak var lb_title: UILabel!
    @IBOutlet weak var lb_subtitle: UILabel!
    @IBOutlet weak var lb_detail: UILabel!
    @IBOutlet weak var lb_status: UILabel!

    func initialize(myPet: MyPet) {
        vw_borderView.layer.borderWidth = 1
        vw_borderView.layer.cornerRadius = 10
        vw_borderView.layer.borderColor = UIColor.init(hex: "#FFE3E9F2")?.cgColor

        iv_prof.layer.cornerRadius = iv_prof.bounds.size.width / 2
        iv_prof.layer.masksToBounds = true

        vw_profIvBorder.backgroundColor = UIColor.white
        vw_profIvBorder.layer.borderWidth = 1
        vw_profIvBorder.layer.cornerRadius = vw_profIvBorder.bounds.size.width / 2
        vw_profIvBorder.layer.borderColor = UIColor.init(hex: "#4E608526")?.cgColor
        vw_profIvBorder.showShadowMid()

        lb_status.layer.cornerRadius = 5
        lb_status.layer.masksToBounds = true

        setPetImage(imageView: iv_prof, pet: myPet)

        lb_title.text = myPet.petNm
        lb_subtitle.text = myPet.petKindNm
        lb_detail.text = String("\(Util.transDiffDateStr(myPet.petBrthYmd)) | \(myPet.wghtVl)kg | \(myPet.sexTypNm)\(myPet.ntrTypCD == "001" ? "(중성화수술 완료)" : "")")

        lb_status.layer.borderWidth = 1

        switch myPet.mngrType {
        case "M":
            lb_status.text = "관리중"
            lb_status.textColor = UIColor.white
            lb_status.backgroundColor = UIColor.init(hex: "#FF4783f5")
            lb_status.layer.borderColor = UIColor.init(hex: "#FF4783f5")?.cgColor
            break
        case "I":
            lb_status.text = "참여중"
            lb_status.textColor = UIColor.init(hex: "#FF4783f5")
            lb_status.backgroundColor = UIColor.white
            lb_status.layer.borderColor = UIColor.init(hex: "#FF4783f5")?.cgColor
            break
        case "C":
            lb_status.text = "동행중단"
            lb_status.textColor = UIColor.init(hex: "#FF999999")
            lb_status.backgroundColor = UIColor.init(hex: "#FFDDDDDD")
            lb_status.layer.borderColor = UIColor.init(hex: "#FFDDDDDD")?.cgColor
            break
        default:
            lb_status.text = "에러"
            lb_status.textColor = UIColor.init(hex: "#FF999999")
            lb_status.backgroundColor = UIColor.init(hex: "#FFDDDDDD")
            lb_status.layer.borderColor = UIColor.init(hex: "#FFDDDDDD")?.cgColor
            break
        }
    }
}
