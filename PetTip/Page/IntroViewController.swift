//
//  IntroViewController.swift
//  PetTip
//
//  Created by carebiz on 12/4/23.
//

import UIKit

class IntroViewController : CommonViewController {
    
    override func viewDidLoad() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            if let accessToken = UserDefaults.standard.value(forKey: "accessToken") {
                self.performSegue(withIdentifier: "segueIntroToMain", sender: self)
//                self.performSegue(withIdentifier: "segueIntroToTest", sender: self)
            } else {
                self.performSegue(withIdentifier: "segueIntroToLogin", sender: self)
            }
        })
    }
}
