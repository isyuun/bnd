//
//  PetProfileMemberItemView.swift
//  PetTip
//
//  Created by carebiz on 1/27/24.
//

import UIKit

class PetProfileMemberItemView: UIView {
    
    public var didDismissJoin: (()-> Void)?
    
    private var memberList: MemberList?
    
    @IBOutlet weak var iv_profile: UIImageView!
    @IBOutlet weak var vw_managerMark: UIView!
    @IBOutlet weak var lb_memberNm: UILabel!
    @IBOutlet weak var btn_status: UIControl!
    @IBOutlet weak var lb_status: UILabel!
    @IBOutlet weak var cr_statusAreaWidth: NSLayoutConstraint!
    @IBOutlet weak var lb_endDt: UILabel!
    @IBOutlet weak var btn_dismissJoin: UIControl!
    @IBOutlet weak var cr_dissmissJoinBtnWidth: NSLayoutConstraint!
    @IBOutlet weak var cr_dissmissJoinBtnHeight: NSLayoutConstraint!
    
    public func initialize(memberList: MemberList) {
        self.memberList = memberList
        
        if memberList.mngrType == "M" {
            vw_managerMark.isHidden = false
        } else {
            vw_managerMark.isHidden = true
        }
        
        vw_managerMark.layer.cornerRadius = 4
        
        lb_memberNm.text = memberList.nckNm
        
        btn_status.layer.borderWidth = 1
        btn_status.layer.cornerRadius = 8
        btn_dismissJoin.isHidden = true
        
        btn_dismissJoin.layer.cornerRadius = 8
        btn_dismissJoin.backgroundColor = UIColor.init(hex: "#FF4783F5")
        
        cr_dissmissJoinBtnWidth.constant = 0
        cr_dissmissJoinBtnHeight.constant = 0
        if memberList.mngrType == "M" {
            btn_status.layer.borderColor = UIColor.init(hex: "#FF4783F5")?.cgColor
            btn_status.backgroundColor = UIColor.init(hex: "#FF4783F5")
            lb_status.textColor = UIColor.white
            lb_status.text = "관리중"
            lb_endDt.isHidden = true
            
        } else if memberList.mngrType == "I" {
            btn_status.layer.borderColor = UIColor.init(hex: "#FF4783F5")?.cgColor
            btn_status.backgroundColor = UIColor.clear
            lb_status.textColor = UIColor.init(hex: "#FF4783F5")
            lb_status.text = "참여중"
            lb_endDt.isHidden = true
            
        } else if memberList.mngrType == "C" {
            btn_status.layer.borderColor = UIColor.init(hex: "#FFDDDDDD")?.cgColor
            btn_status.backgroundColor = UIColor.init(hex: "#FFDDDDDD")
            lb_status.textColor = UIColor.darkText
            lb_status.text = "동행중단"
            cr_statusAreaWidth.constant = 58
            lb_endDt.text = memberList.endDt
            lb_endDt.isHidden = false
        }
    }
    
    @IBAction func onStatus(_ sender: Any) {
        guard let memberList = memberList else { return }
        
        if memberList.mngrType == "I" {
            
            
            if self.lb_status.text == "참여중" {
                UIView.animate(withDuration: 0.5) {
                    self.lb_status.text = "참여를 중단하시겠습니까?"
                    self.cr_statusAreaWidth.constant = 140
                    self.layoutIfNeeded()
                    
                } completion: { flag in
                    self.btn_dismissJoin.isHidden = false
                    UIView.animate(withDuration: 0.5) {
                        self.cr_dissmissJoinBtnWidth.constant = 30
                        self.cr_dissmissJoinBtnHeight.constant = 24
                        self.layoutIfNeeded()
                    } completion: { flag in }
                }
                
            } else {
                UIView.animate(withDuration: 0.5) {
                    self.cr_dissmissJoinBtnWidth.constant = 0
                    self.cr_dissmissJoinBtnHeight.constant = 0
                    self.layoutIfNeeded()
                } completion: { flag in
                    self.btn_dismissJoin.isHidden = true
                    
                    UIView.animate(withDuration: 0.5) {
                        self.lb_status.text = "참여중"
                        self.cr_statusAreaWidth.constant = 44
                        self.layoutIfNeeded()
                        
                    } completion: { flag in }
                }
            }
        }
    }
    
    @IBAction func onDismissJoin(_ sender: Any) {
        didDismissJoin?()
    }
}
