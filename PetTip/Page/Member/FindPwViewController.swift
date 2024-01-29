//
//  FindPwViewController.swift
//  PetTip
//
//  Created by carebiz on 1/15/24.
//

import UIKit

class FindPwViewController: CommonViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showCommonUI()
    }
    
    
    
    
    @IBOutlet weak var tf_id: UITextField!
    @IBOutlet weak var tf_phoneNum: UITextField!
    @IBOutlet weak var tf_authCode: UITextField!
    
    func showCommonUI() {
        tf_id.delegate = self
        inputTextNormalUI(view: tf_id)
        
        tf_phoneNum.delegate = self
        inputTextNormalUI(view: tf_phoneNum)
        
        tf_authCode.delegate = self
        inputTextNormalUI(view: tf_authCode)
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
    
    @IBAction func onContentViewTap(_ sender: Any) {
        reqCloseKeyboard()
    }
    
    private func reqCloseKeyboard() {
        tf_id.resignFirstResponder()
        tf_phoneNum.resignFirstResponder()
        tf_authCode.resignFirstResponder()
    }
}





extension FindPwViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        inputTextSelectedUI(view: textField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        inputTextNormalUI(view: textField)
    }
}

