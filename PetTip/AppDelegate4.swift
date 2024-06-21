//
//  AppDelegate4.swift
//  PetTip
//
//  Created by Ahn Je Wook on 6/11/24.
//

import UIKit

@main
class AppDelegate4: AppDelegate3 {
    private(set) static var instance: AppDelegate! = nil
    var walkingController: WalkingController2? = nil

    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AppDelegate4.instance = self // << here !!
        let ret = super.application(application, didFinishLaunchingWithOptions: launchOptions)
        walkingController = WalkingController2()
        return ret
    }
}
