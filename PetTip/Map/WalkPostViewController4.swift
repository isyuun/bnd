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
        let newBackButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(WalkPostViewController4.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
    }

    @objc func back(sender: UIBarButtonItem) {
        onBack()
    }
}
