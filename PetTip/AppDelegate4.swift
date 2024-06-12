//
//  AppDelegate4.swift
//  PetTip
//
//  Created by Ahn Je Wook on 6/11/24.
//

import UIKit

@main
class AppDelegate4: AppDelegate3 {
    var walkingController: WalkingController? = nil;
    
    override func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        walkingController = WalkingController()
        return super.application(application, didFinishLaunchingWithOptions: launchOptions);
    }


}
