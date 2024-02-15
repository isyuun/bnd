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
            if UserDefaults.standard.value(forKey: "accessToken") != nil {
                self.performSegue(withIdentifier: "segueIntroToMain", sender: self)
                
            } else {
                self.performSegue(withIdentifier: "segueIntroToLogin", sender: self)
            }
        })
    }
}
