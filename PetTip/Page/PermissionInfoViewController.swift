//
//  PermissionInfoViewController.swift
//  PetTip
//
//  Created by carebiz on 2/21/24.
//

import UIKit

class PermissionInfoViewController: CommonViewController {
    
    @IBAction func onComplete(_ sender: Any) {
        
        let userDef = UserDefaults.standard
        userDef.set(true, forKey: "permissionAgree")
        userDef.synchronize()
        
        if UserDefaults.standard.value(forKey: "accessToken") != nil {
            self.performSegue(withIdentifier: "seguePermissionToMain", sender: self)
            
        } else {
            self.performSegue(withIdentifier: "seguePermissionToLogin", sender: self)
        }
    }
}
