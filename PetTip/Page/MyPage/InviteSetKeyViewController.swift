//
//  InviteSetKeyViewController.swift
//  PetTip
//
//  Created by carebiz on 1/5/24.
//

import UIKit

class InviteSetKeyViewController: CommonViewController2 {

    @IBOutlet weak var vw_registIconBg: UIView!

    @IBOutlet weak var lb_1, lb_2, lb_3, lb_4, lb_5, lb_6: UILabel!
    @IBOutlet weak var tf_key: UITextField!

    var arrLb: [UILabel]!

    override func viewDidLoad() {
        super.viewDidLoad()

        showBackTitleBarView()

        showCommonUI()
    }

    func showCommonUI() {
        vw_registIconBg.layer.cornerRadius = vw_registIconBg.bounds.size.width / 2
        vw_registIconBg.layer.masksToBounds = true

        arrLb = [lb_1, lb_2, lb_3, lb_4, lb_5, lb_6]
        for i in 0..<arrLb.count {
            arrLb[i].layer.cornerRadius = 5
            arrLb[i].layer.borderWidth = 1
            arrLb[i].layer.borderColor = UIColor.init(hex: "#FFE3E9F2")?.cgColor
            arrLb[i].backgroundColor = UIColor.white
            arrLb[i].text = ""
        }

        lbStatSel(arrLb[0])

        tf_key.delegate = self
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.tf_key.becomeFirstResponder()
        })

        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(gesture:)))
        tf_key.addGestureRecognizer(longPress)
    }

    @objc func longPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state == UIGestureRecognizer.State.began {

            if let theString = UIPasteboard.general.string, theString.count == 6 {
                tf_key.text = theString
            }
        }
    }

    func lbStatSel(_ lb: UILabel) {
        lb.layer.borderWidth = 2
        lb.layer.borderColor = UIColor.init(hex: "#FF000000")?.cgColor
    }

    func lbStatUnsel(_ lb: UILabel) {
        lb.layer.borderWidth = 1
        lb.layer.borderColor = UIColor.init(hex: "#FFE3E9F2")?.cgColor
    }

    @IBAction func onReg(_ sender: Any) {
        guard let key = tf_key.text, key.count == 6 else {
            showToast(msg: "초대코드가 정상적으로 입력되지 않았어요")
            return
        }

        invtt_setKey(key: key)
    }

    func invtt_setKey(key: String) {
        tf_key.resignFirstResponder()

        self.startLoading()

        let request = MyPetInvttSetKeyRequest(invttKeyVl: key)
        MyPetAPI.invttSetKey(request: request) { response, error in
            self.stopLoading()

            if let response = response {
                if response.statusCode == 200 {
                    self.showAlertPopup(title: "알림", msg: response.resultMessage, didTapOK: {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                            self.invtt_setKey() //self.onBack()
                        })
                    })
                }
                else if response.statusCode == 406 {
                    self.showAlertPopup(title: response.resultMessage, msg: response.detailMessage!)

                } else {
                    self.showAlertPopup(title: "에러", msg: "통신 에러가 발생했어요")
                    //self.showAlertPopup(title: response.resultMessage, msg: response.detailMessage!)
                }
            }

            self.processNetworkError(error)
        }
    }

    func invtt_setKey() { }

    // MARK: - Back TitleBar
    @IBOutlet weak var titleBarView: UIView!

    func showBackTitleBarView() {
        if let view = UINib(nibName: "BackTitleBarView", bundle: nil).instantiate(withOwner: self).first as? BackTitleBarView {
            view.frame = titleBarView.bounds
            view.lb_title.text = "초대코드 등록하기"
            view.delegate = self
            titleBarView.addSubview(view)
            self.title = view.lb_title.text
        }
    }
}

extension InviteSetKeyViewController {

    func textFieldDidChangeSelection(_ textField: UITextField) {

        textField.text = textField.text?.uppercased()

        guard let inputText = textField.text else { return }

        if inputText.count > 6 {
            textField.text?.removeLast()
        }

        for i in 0..<arrLb.count {
            arrLb[i].text = ""
        }
        for i in 0..<inputText.count {
            arrLb[i].text = String(Array(inputText)[i])
        }

        for i in 0..<arrLb.count {
            lbStatUnsel(arrLb[i])
        }
        if textField.text!.count < 6 {
            lbStatSel(arrLb[inputText.count])
        }
    }
}

extension InviteSetKeyViewController: BackTitleBarViewProtocol {

    func onBack() {
        navigationController?.popViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
}
