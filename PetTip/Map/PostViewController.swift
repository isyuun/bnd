//
//  PostViewController.swift
//  PetTip
//
//  Created by carebiz on 12/2/23.
//

import UIKit

class PostViewController : CommonViewController {
    
    var mapSnapImg : UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        ivSumMap.image = mapSnapImg
    }
    
    
    
    
    
    // MARK: - UI
    
    @IBOutlet weak var ivSumMap: UIImageView!
    
    @IBOutlet weak var btnComplete: UIButton!
    @IBAction func onBtnComplete(_ sender: Any) {
        self.navigationController!.popToViewController(navigationController!.viewControllers.first!, animated: true)
    }
}
