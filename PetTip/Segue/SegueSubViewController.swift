//
//  SegueSubViewController.swift
//  PetTip
//
//  Created by carebiz on 11/23/23.
//

import UIKit

class SegueSubViewController : UIViewController {
    
    @IBOutlet weak var senderTestLabel: UILabel!
    
    var testString : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        senderTestLabel.text = testString
    }
}
