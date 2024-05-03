//
//  StoryAddViewController2.swift
//  PetTip
//
//  Created by isyuun on 2024/5/3.
//

import UIKit

class StoryAddViewController2: StoryAddViewController {
    override func viewDidAppear(_ animated: Bool) {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][animated:\(animated)]")
        super.viewDidAppear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][animated:\(animated)]")
        super.viewDidDisappear(animated)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][textField:\(textField)][range:\(range)][string:\(string)]")
        // let maxLength = 1
        // let currentString = (textField.text ?? "") as NSString
        // let newString = currentString.replacingCharacters(in: range, with: string)
        // 
        // return newString.count <= maxLength
        return true
    }
}
