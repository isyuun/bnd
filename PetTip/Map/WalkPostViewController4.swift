//
//  WalkPostViewController4.swift
//  PetTip
//
//  Created by isyuun on 2024/6/25.
//

import UIKit

class WalkPostViewController4: WalkPostViewController3 {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .done, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItem = newBackButton
    }

    @objc func back() {
        onBack()
    }
}
