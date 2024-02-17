//
//  CommonDetailImageItemView.swift
//  PetTip
//
//  Created by carebiz on 12/15/23.
//

import UIKit

class CommonDetailImageItemView : UITableViewCell {

    public var didTapImage: (()-> Void)?
    
    @IBOutlet weak var iv_img : UIImageView!
    
    func initialize() {
        
    }
    
    @IBAction func onTapImage(_ sender: Any) {
        didTapImage?()
    }
}
