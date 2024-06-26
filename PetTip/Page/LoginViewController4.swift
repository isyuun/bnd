//
//  LoginViewController4.swift
//  PetTip
//
//  Created by Ahn Je Wook on 6/25/24.
//

import UIKit

class LoginViewController4: LoginViewController3 {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 산책기록 제거
        UserDefaults.standard.removeObject(forKey: "WalkTrackList")
        UserDefaults.standard.synchronize()
    }
}
