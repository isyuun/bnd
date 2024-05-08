//
//  CommonViewController2.swift
//  PetTip
//
//  Created by isyuun on 2024/4/19.
//

import UIKit

class CommonViewController2: CommonViewController, UITextFieldDelegate {

    private var toolBar: UIToolbar!
    private var prevButton: UIBarButtonItem!
    private var nextButton: UIBarButtonItem!
    private var doneButton: UIBarButtonItem!
    private var textFields: [UITextField]!

    override func viewDidLoad() {
        super.viewDidLoad()
        // let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        // self.view.addGestureRecognizer(tap)
        initTextFiels()
    }

    //...
    func initTextFiels() {
        // UITextField의 inputAccessoryView 설정
        toolBar = UIToolbar()
        toolBar.sizeToFit()

        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        nextButton = UIBarButtonItem(image: UIImage(systemName: "chevron.down"), style: .done, target: self, action: #selector(nextButtonTapped))
        prevButton = UIBarButtonItem(image: UIImage(systemName: "chevron.up"), style: .done, target: self, action: #selector(prevButtonTapped))
        doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(doneButtonTapped))

        toolBar.items = [prevButton, nextButton, flexibleSpace, doneButton]

        textFields = findAllTextFields(view: self.view)

        for textField in textFields {
            textField.inputAccessoryView = toolBar
            textField.delegate = self
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        NSLog("[LOG][W][(\(#fileID):\(#line))::\(#function)][textField:\(textField)]")
        return false
    }

    @objc func prevButtonTapped() {
        prevButton.isEnabled = true
        nextButton.isEnabled = true
        guard let currentTextField = findFirstResponder() else {
            return
        }

        guard let currentIndex = textFields.firstIndex(of: currentTextField) else {
            return
        }

        let prevIndex = currentIndex - 1
        guard prevIndex >= 0 else {
            return
        }

        let prevTextField = textFields[prevIndex]
        prevTextField.becomeFirstResponder()
        print("prevButtonTapped:\(prevIndex)")
        checkFirstResponder()
    }

    @objc func nextButtonTapped() {
        prevButton.isEnabled = true
        nextButton.isEnabled = true
        guard let currentTextField = findFirstResponder() else {
            return
        }

        guard let currentIndex = textFields.firstIndex(of: currentTextField) else {
            return
        }

        let nextIndex = currentIndex + 1
        guard nextIndex < textFields.count else {
            return
        }

        let nextTextField = textFields[nextIndex]
        nextTextField.becomeFirstResponder()
        print("nextButtonTapped:\(nextIndex)")
        checkFirstResponder()
    }

    func findAllTextFields(view: UIView) -> [UITextField] {
        var textFields: [UITextField] = []

        for subview in view.subviews {
            if let textField = subview as? UITextField {
                textFields.append(textField)
            } else {
                textFields += findAllTextFields(view: subview)
            }
        }

        return textFields
    }

    // 현재 포커스를 가진 UITextField 찾기
    func checkFirstResponder() {
        guard let currentTextField = findFirstResponder() else {
            return
        }

        guard let currentIndex = textFields.firstIndex(of: currentTextField) else {
            return
        }

        if currentIndex == 0 { prevButton.isEnabled = false } else { prevButton.isEnabled = true }
        if currentIndex == textFields.count - 1 { nextButton.isEnabled = false } else { nextButton.isEnabled = true }
    }

    // 현재 포커스를 가진 UITextField 찾기
    func findFirstResponder() -> UITextField? {
        for textField in textFields {
            if textField.isFirstResponder {
                return textField
            }
        }
        return nil
    }

    @objc func doneButtonTapped() {
        // 확인 버튼이 눌렸을 때의 동작 구현
        self.view.endEditing(true)
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
        print("keyboardWillShow\(notification)")
        // guard let userInfo = notification.userInfo else { return }
        // guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        // let keyboardFrame = keyboardSize.cgRectValue
        // // self.view.frame.size.height -= keyboardFrame.height
        checkFirstResponder()
    }

    @objc func keyboardWillHide(_ notification: NSNotification) {
        print("keyboardWillHide\(notification)")
        // guard let userInfo = notification.userInfo else { return }
        // guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        // let keyboardFrame = keyboardSize.cgRectValue
        // // self.view.frame.size.height += keyboardFrame.height
        checkFirstResponder()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
}
