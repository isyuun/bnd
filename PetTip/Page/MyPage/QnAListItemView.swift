//
//  QnAListItemView.swift
//  PetTip
//
//  Created by carebiz on 1/11/24.
//

import UIKit

class QnAListItemView: UITableViewCell {
    
    @IBOutlet weak var lb_status: UILabel!
    @IBOutlet weak var lb_title: UILabel!
    
    func initialize(qna: BBSQnaList) {
        lb_status.layer.cornerRadius = 7
        lb_status.layer.masksToBounds = true
        lb_status.layer.borderWidth = 1
        
        if qna.pstAnw == 0 {
            lb_status.text = "문의 접수"
            lb_status.textColor = UIColor.init(hex: "#FF333333")
            lb_status.layer.borderColor = UIColor.init(hex: "#FF333333")?.cgColor
            lb_status.backgroundColor = UIColor.white
            
        } else {
            lb_status.text = "답변 완료"
            lb_status.textColor = UIColor.white
            lb_status.layer.borderColor = UIColor.init(hex: "#FF4783F5")?.cgColor
            lb_status.backgroundColor = UIColor.init(hex: "#FF4783F5")
        }

        lb_title.text = qna.pstTTL
    }
}
