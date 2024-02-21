//
//  SNSJoinViewcontroller.swift
//  PetTip
//
//  Created by carebiz on 1/30/24.
//

import UIKit
import WebKit

class SNSJoinViewcontroller: CommonViewController {
    
    public var memberData: MemberJoinData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        
        showBackTitleBarView()
        
        showCommonUI()
    }
    
    
    
    
    @IBOutlet weak var vw_chkAgreeAllBg: UIView!
    @IBOutlet weak var btn_chkAgreeAll: UIButton!
    @IBOutlet weak var iv_chkAgreeAll: UIImageView!
    @IBOutlet weak var vw_chkAgreeAll: UIView!
    @IBOutlet weak var lb_chkAgreeAll: UILabel!
    
    @IBOutlet weak var btn_chkAgreeTerm1: UIButton!
    @IBOutlet weak var iv_chkAgreeTerm1: UIImageView!
    @IBOutlet weak var btn_expandAgreeTerm1: UIButton!
    @IBOutlet weak var wv_agreeTerm1Detail: WKWebView!
    @IBOutlet weak var iv_agreeTerm1Detail: UIImageView!
    @IBOutlet weak var cr_agreeTerm1DetailAreaHeight: NSLayoutConstraint!
    
    @IBOutlet weak var btn_chkAgreeTerm2: UIButton!
    @IBOutlet weak var iv_chkAgreeTerm2: UIImageView!
    @IBOutlet weak var btn_expandAgreeTerm2: UIButton!
    @IBOutlet weak var wv_agreeTerm2Detail: WKWebView!
    @IBOutlet weak var iv_agreeTerm2Detail: UIImageView!
    @IBOutlet weak var cr_agreeTerm2DetailAreaHeight: NSLayoutConstraint!
    
    @IBOutlet weak var btn_chkAgreeTerm3: UIButton!
    @IBOutlet weak var iv_chkAgreeTerm3: UIImageView!
    @IBOutlet weak var btn_expandAgreeTerm3: UIButton!
    @IBOutlet weak var wv_agreeTerm3Detail: WKWebView!
    @IBOutlet weak var iv_agreeTerm3Detail: UIImageView!
    @IBOutlet weak var cr_agreeTerm3DetailAreaHeight: NSLayoutConstraint!
    
    @IBOutlet weak var vw_nickNmBg: UIView!
    @IBOutlet weak var tf_nickNm: UITextField!
    @IBOutlet weak var btn_nickDupChk: UIButton!
    
    private func showCommonUI() {
        vw_chkAgreeAllBg.layer.cornerRadius = 12
        vw_chkAgreeAllBg.layer.borderWidth = 1
        vw_chkAgreeAllBg.layer.borderColor = UIColor(hex: "#ff333333")?.cgColor
        vw_chkAgreeAll.backgroundColor = UIColor.white
        vw_chkAgreeAll.layer.cornerRadius = 2
        vw_chkAgreeAll.layer.borderWidth = 1
        vw_chkAgreeAll.layer.borderColor = UIColor.init(hex: "#FFE3E9F2")?.cgColor
        iv_chkAgreeAll.image = UIImage.imageFromColor(color: UIColor.clear)
        btn_chkAgreeAll.isSelected = false
        
        iv_chkAgreeTerm1.image = UIImage.init(named: "checkbox_white")!.withTintColor(UIColor.init(hex: "#FFB5B9BE")!, renderingMode: .alwaysOriginal)
        btn_chkAgreeTerm1.isSelected = false
        cr_agreeTerm1DetailAreaHeight.isActive = false
        let constraint1 = NSLayoutConstraint(item: wv_agreeTerm1Detail as Any, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 0)
        cr_agreeTerm1DetailAreaHeight = constraint1
        wv_agreeTerm1Detail.addConstraint(constraint1)
        iv_agreeTerm1Detail.image = UIImage(systemName: "chevron.down")
        wv_agreeTerm1Detail.load(URLRequest(url: URL(string: Global.URL_TERMS_1)!))
        
        iv_chkAgreeTerm2.image = UIImage.init(named: "checkbox_white")!.withTintColor(UIColor.init(hex: "#FFB5B9BE")!, renderingMode: .alwaysOriginal)
        btn_chkAgreeTerm2.isSelected = false
        cr_agreeTerm2DetailAreaHeight.isActive = false
        let constraint2 = NSLayoutConstraint(item: wv_agreeTerm2Detail as Any, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 0)
        cr_agreeTerm2DetailAreaHeight = constraint2
        wv_agreeTerm2Detail.addConstraint(constraint2)
        iv_agreeTerm2Detail.image = UIImage(systemName: "chevron.down")
        wv_agreeTerm2Detail.load(URLRequest(url: URL(string: Global.URL_TERMS_2)!))

        iv_chkAgreeTerm3.image = UIImage.init(named: "checkbox_white")!.withTintColor(UIColor.init(hex: "#FFB5B9BE")!, renderingMode: .alwaysOriginal)
        btn_chkAgreeTerm3.isSelected = false
        cr_agreeTerm3DetailAreaHeight.isActive = false
        let constraint3 = NSLayoutConstraint(item: wv_agreeTerm3Detail as Any, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 0)
        cr_agreeTerm3DetailAreaHeight = constraint3
        wv_agreeTerm3Detail.addConstraint(constraint3)
        iv_agreeTerm3Detail.image = UIImage(systemName: "chevron.down")
        wv_agreeTerm3Detail.load(URLRequest(url: URL(string: Global.URL_TERMS_3)!))

        tf_nickNm.text = memberData?.nick
        tf_nickNm.delegate = self
        inputTextNormalUI(view: vw_nickNmBg)
        btn_nickDupChk.isHidden = true
    }
    
    private func inputTextSelectedUI(view: UIView) {
        view.layer.cornerRadius = 4
        
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor(hex: "#FF000000")?.cgColor // SELECTED COLOR
    }
    
    private func inputTextNormalUI(view: UIView) {
        view.layer.cornerRadius = 4
        
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(hex: "#ffe3e9f2")?.cgColor // NORMAL COLOR
    }
    
    @IBAction func onCheck(_ sender: Any) {
        switch sender as? UIButton {
        case btn_chkAgreeAll:
            btn_chkAgreeAll.isSelected.toggle()
            if btn_chkAgreeAll.isSelected {
                vw_chkAgreeAllBg.layer.borderColor = UIColor(hex: "#FF4783F5")?.cgColor
                vw_chkAgreeAllBg.backgroundColor = UIColor(hex: "#FFF6F8FC")
                vw_chkAgreeAll.backgroundColor = UIColor.init(hex: "#FF4783F5")
                iv_chkAgreeAll.image = UIImage(named: "checkbox_white")
                lb_chkAgreeAll.textColor = UIColor.init(hex: "#FF4783F5")
                
                btn_chkAgreeTerm1.isSelected = false
                btn_chkAgreeTerm2.isSelected = false
                btn_chkAgreeTerm3.isSelected = false
                onCheck(btn_chkAgreeTerm1 as Any)
                onCheck(btn_chkAgreeTerm2 as Any)
                onCheck(btn_chkAgreeTerm3 as Any)
                
            } else {
                vw_chkAgreeAllBg.layer.borderColor = UIColor(hex: "#ff333333")?.cgColor
                vw_chkAgreeAllBg.backgroundColor = UIColor.clear
                vw_chkAgreeAll.backgroundColor = UIColor.white
                iv_chkAgreeAll.image = UIImage.imageFromColor(color: UIColor.clear)
                lb_chkAgreeAll.textColor = UIColor.darkText
                
                btn_chkAgreeTerm1.isSelected = true
                btn_chkAgreeTerm2.isSelected = true
                btn_chkAgreeTerm3.isSelected = true
                onCheck(btn_chkAgreeTerm1 as Any)
                onCheck(btn_chkAgreeTerm2 as Any)
                onCheck(btn_chkAgreeTerm3 as Any)
            }
            break
            
        case btn_chkAgreeTerm1:
            btn_chkAgreeTerm1.isSelected.toggle()
            if btn_chkAgreeTerm1.isSelected {
                iv_chkAgreeTerm1.image = UIImage.init(named: "checkbox_white")!.withTintColor(UIColor.init(hex: "#FF4783F5")!, renderingMode: .alwaysOriginal)
                
            } else {
                iv_chkAgreeTerm1.image = UIImage.init(named: "checkbox_white")!.withTintColor(UIColor.init(hex: "#FFB5B9BE")!, renderingMode: .alwaysOriginal)
            }
            break
        
        case btn_chkAgreeTerm2:
            btn_chkAgreeTerm2.isSelected.toggle()
            if btn_chkAgreeTerm2.isSelected {
                iv_chkAgreeTerm2.image = UIImage.init(named: "checkbox_white")!.withTintColor(UIColor.init(hex: "#FF4783F5")!, renderingMode: .alwaysOriginal)
                
            } else {
                iv_chkAgreeTerm2.image = UIImage.init(named: "checkbox_white")!.withTintColor(UIColor.init(hex: "#FFB5B9BE")!, renderingMode: .alwaysOriginal)
            }
            break
            
        case btn_chkAgreeTerm3:
            btn_chkAgreeTerm3.isSelected.toggle()
            if btn_chkAgreeTerm3.isSelected {
                iv_chkAgreeTerm3.image = UIImage.init(named: "checkbox_white")!.withTintColor(UIColor.init(hex: "#FF4783F5")!, renderingMode: .alwaysOriginal)
                
            } else {
                iv_chkAgreeTerm3.image = UIImage.init(named: "checkbox_white")!.withTintColor(UIColor.init(hex: "#FFB5B9BE")!, renderingMode: .alwaysOriginal)
            }
            break
            
        default:
            break
        }
    }
    
    @IBAction func onExpand(_ sender: Any) {
        switch sender as? UIButton {
        case btn_expandAgreeTerm1:
            btn_expandAgreeTerm1.isSelected.toggle()
            if btn_expandAgreeTerm1.isSelected {
                iv_agreeTerm1Detail.image = UIImage(systemName: "chevron.up")
                UIView.animate(withDuration: 0.25) {
                    self.cr_agreeTerm1DetailAreaHeight.isActive = false
                    let constraint = NSLayoutConstraint(item: self.wv_agreeTerm1Detail as Any, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 200)
                    self.cr_agreeTerm1DetailAreaHeight = constraint
                    self.wv_agreeTerm1Detail.addConstraint(constraint)
                    self.view.layoutIfNeeded()
                } completion: { Bool in }
                
            } else {
                iv_agreeTerm1Detail.image = UIImage(systemName: "chevron.down")
                UIView.animate(withDuration: 0.25) {
                    self.cr_agreeTerm1DetailAreaHeight.isActive = false
                    let constraint = NSLayoutConstraint(item: self.wv_agreeTerm1Detail as Any, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 0)
                    self.cr_agreeTerm1DetailAreaHeight = constraint
                    self.wv_agreeTerm1Detail.addConstraint(constraint)
                    self.view.layoutIfNeeded()
                } completion: { Bool in }
            }
            break
        
        case btn_expandAgreeTerm2:
            btn_expandAgreeTerm2.isSelected.toggle()
            if btn_expandAgreeTerm2.isSelected {
                iv_agreeTerm2Detail.image = UIImage(systemName: "chevron.up")
                UIView.animate(withDuration: 0.25) {
                    self.cr_agreeTerm2DetailAreaHeight.isActive = false
                    let constraint = NSLayoutConstraint(item: self.wv_agreeTerm2Detail as Any, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 200)
                    self.cr_agreeTerm2DetailAreaHeight = constraint
                    self.wv_agreeTerm2Detail.addConstraint(constraint)
                    self.view.layoutIfNeeded()
                } completion: { Bool in }
                
            } else {
                iv_agreeTerm2Detail.image = UIImage(systemName: "chevron.down")
                UIView.animate(withDuration: 0.25) {
                    self.cr_agreeTerm2DetailAreaHeight.isActive = false
                    let constraint = NSLayoutConstraint(item: self.wv_agreeTerm2Detail as Any, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 0)
                    self.cr_agreeTerm2DetailAreaHeight = constraint
                    self.wv_agreeTerm2Detail.addConstraint(constraint)
                    self.view.layoutIfNeeded()
                } completion: { Bool in }
            }
            break
            
        case btn_expandAgreeTerm3:
            btn_expandAgreeTerm3.isSelected.toggle()
            if btn_expandAgreeTerm3.isSelected {
                iv_agreeTerm3Detail.image = UIImage(systemName: "chevron.up")
                UIView.animate(withDuration: 0.25) {
                    self.cr_agreeTerm3DetailAreaHeight.isActive = false
                    let constraint = NSLayoutConstraint(item: self.wv_agreeTerm3Detail as Any, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 200)
                    self.cr_agreeTerm3DetailAreaHeight = constraint
                    self.wv_agreeTerm3Detail.addConstraint(constraint)
                    self.view.layoutIfNeeded()
                } completion: { Bool in }
                
            } else {
                iv_agreeTerm3Detail.image = UIImage(systemName: "chevron.down")
                UIView.animate(withDuration: 0.25) {
                    self.cr_agreeTerm3DetailAreaHeight.isActive = false
                    let constraint = NSLayoutConstraint(item: self.wv_agreeTerm3Detail as Any, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 0)
                    self.cr_agreeTerm3DetailAreaHeight = constraint
                    self.wv_agreeTerm3Detail.addConstraint(constraint)
                    self.view.layoutIfNeeded()
                } completion: { Bool in }
            }
            break
            
        default:
            break
        }
    }
    
    
    
    
    
    // MARK: - CHECK DUPLICATE NICKNAME
    
    var checkedNcknm: String?
    
    @IBAction func onCheckDuplicate(_ sender: Any) {
        self.view.endEditing(true)
     
        guard let nicknm = tf_nickNm.text else { return }
        
        startLoading()
        
        let request = ChkNcknmRequest(ncknm: nicknm)
        MemberAPI.chkNcknm(request: request) { data, error in
            self.stopLoading()
            
            if let statusCode = data?.statusCode {
                if statusCode == 200 {
                    self.checkedNcknm = self.tf_nickNm.text
                    self.showAlertPopup(title: "알림", msg: "사용하실 수 있는 닉네임입니다")
                } else if statusCode == 406 {
                    self.showAlertPopup(title: "알림", msg: "이미 사용중인 닉네임입니다")
                }
            }
            
            self.processNetworkError(error)
        }
    }
    
    
    
    
    
    // MARK: - CONN COMPLETE
    
    @IBAction func onComplete(_ sender: Any) {
        self.view.endEditing(true)
        
        guard let memberData = memberData else { return }
        
        if btn_chkAgreeTerm1.isSelected == false || btn_chkAgreeTerm2.isSelected == false || btn_chkAgreeTerm3.isSelected == false {
            showToast(msg: "약관에 동의해주세요")
            return
        }
        
        if let nick = tf_nickNm.text {
            if nick.isEmpty {
                showToast(msg: "닉네임을 입력해주세요")
                return
                
            } else if checkedNcknm == nil || checkedNcknm != tf_nickNm.text {
                self.showAlertPopup(title: "알림", msg: "닉네임 중복확인을 해주세요")
                return
                
            } else {
                let petAddViewController = UIStoryboard(name: "Pet", bundle: nil).instantiateViewController(identifier: "PetAddViewController") as PetAddViewController
                petAddViewController.memberData = MemberJoinData(id: memberData.id, pw: memberData.pw, nick: nick, method: memberData.method)
                self.navigationController?.pushViewController(petAddViewController, animated: true)
            }
        }
    }
    
    
    
    
    
    // MARK: - Back TitleBar
    
    @IBOutlet weak var titleBarView : UIView!
    
    func showBackTitleBarView() {
        if let view = UINib(nibName: "BackTitleBarView", bundle: nil).instantiate(withOwner: self).first as? BackTitleBarView {
            view.frame = titleBarView.bounds
            view.lb_title.text = "회원가입"
            view.delegate = self
            titleBarView.addSubview(view)
        }
    }
}





extension SNSJoinViewcontroller: BackTitleBarViewProtocol {
    func onBack() {
        navigationController?.popViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
}





extension SNSJoinViewcontroller: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == tf_nickNm {
            if let text = textField.text, text.count > 0 {
                btn_nickDupChk.isHidden = false
            } else {
                btn_nickDupChk.isHidden = true
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == tf_nickNm {
            inputTextSelectedUI(view: vw_nickNmBg)
        } else {
            inputTextSelectedUI(view: textField)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == tf_nickNm {
            inputTextNormalUI(view: vw_nickNmBg)
        } else {
            inputTextNormalUI(view: textField)
        }
    }
}
