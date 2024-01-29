//
//  ViewController.swift
//  PetTip
//
//  Created by carebiz on 11/22/23.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var btnWalk: UIButton!
    @IBAction func onMoveUTCTime(_ sender: Any) {
        performSegue(withIdentifier: "showUTCTime", sender: self)
    }
    
    @IBAction func onMoveUTCTimeRx(_ sender: Any) {
        performSegue(withIdentifier: "showUTCTimeRx", sender: self)
    }
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
//            self.performSegue(withIdentifier: "showNaverMap", sender: self)
        })
    }
}

