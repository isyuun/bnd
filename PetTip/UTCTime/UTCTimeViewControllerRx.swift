//
//  UTCTimeViewControllerRx.swift
//  PetTip
//
//  Created by carebiz on 11/23/23.
//

import UIKit
import RxSwift
import RxCocoa

class UTCTimeViewControllerRx: UIViewController {

    @IBOutlet weak var datetimeLabel: UILabel!

    let viewModel = UTCTimeViewModelRx()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        viewModel.onUpdated = { [weak self] in
//            
//            DispatchQueue.main.async {
//                
//                self?.datetimeLabel?.text = self?.viewModel.dateTimeString
//            }
//        }
        viewModel.dateTimeString.bind(to: datetimeLabel.rx.text).disposed(by: disposeBag)
        
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
