//
//  CommonViewController2.swift
//  PetTip
//
//  Created by isyuun on 2024/4/19.
//

import UIKit

class CommonViewController2: CommonViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        // self.view.addGestureRecognizer(tap)
    }

    @objc func handleTap(_ sender: Any) {
        self.view.endEditing(true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addKeyboardObserver()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeKeyboardObserver()
    }

    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(_ notification: NSNotification) {
        // guard let userInfo = notification.userInfo else { return }
        // guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        // let keyboardFrame = keyboardSize.cgRectValue
        // // self.view.frame.size.height -= keyboardFrame.height
    }

    @objc func keyboardWillHide(_ notification: NSNotification) {
        // guard let userInfo = notification.userInfo else { return }
        // guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        // let keyboardFrame = keyboardSize.cgRectValue
        // // self.view.frame.size.height += keyboardFrame.height
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }

}
