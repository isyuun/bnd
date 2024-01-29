//
//  UTCTimeViewController.swift
//  PetTip
//
//  Created by carebiz on 11/23/23.
//

import UIKit

class UTCTimeViewController: UIViewController {

    @IBOutlet weak var datetimeLabel: UILabel!

    let viewModel = UTCTimeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel.onUpdated = { [weak self] in
            
            DispatchQueue.main.async {
                
                self?.datetimeLabel?.text = self?.viewModel.dateTimeString
            }
        }
        
        onNow(self)
    }


    @IBAction func onNow(_ sender: Any) {
        
        datetimeLabel.text = "Loading..."
        
        viewModel.reload()
    }
    
    
    @IBAction func onYesterday(_ sender: UIButton) {
        
        viewModel.moveDay(day: -1)
    }
    
    
    @IBAction func onTomorrow(_ sender: Any) {
    
        viewModel.moveDay(day: 1)
    }
}
