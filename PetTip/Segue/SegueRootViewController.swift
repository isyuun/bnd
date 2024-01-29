//
//  SegueRootViewController.swift
//  PetTip
//
//  Created by carebiz on 11/23/23.
//

import UIKit

class SegueRootViewController : UIViewController {
    
    @IBAction func segueToSubViewController(_ sender: Any) {
        performSegue(withIdentifier: "segueToSubViewController_code", sender: "코드 기입 등 다양한 케이스를 통해 변할 수 있는 값을 넣어 다음 화면 이동시 사용하면 좋습니다.")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueToSubViewController_code") {
            let dest = segue.destination
            guard let vc = dest as? SegueSubViewController else { return }
            vc.testString = sender as? String
        } else if (segue.identifier == "segueToSubViewController_direct") {
            let dest = segue.destination
            guard let vc = dest as? SegueSubViewController else { return }
            vc.testString = "Sender로 데이터를 받을 필요없이 바로 보낼 때 이렇게 스토리보드에서 직접 Action Segue를 연결하면 간편합니다."
        }
    }
}


