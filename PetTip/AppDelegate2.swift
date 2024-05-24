//
//  AppDelegate2.swift
//  PetTip
//
//  Created by carebiz on 11/22/23.
//

import UIKit
import FirebaseCore
import FirebaseMessaging
import UserNotifications
import KakaoSDKAuth
import KakaoSDKCommon
import NaverThirdPartyLogin
import DropDown

// @UIApplicationMain
class AppDelegate2: AppDelegate {
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let ret = super.application(application, didFinishLaunchingWithOptions: launchOptions)

        KakaoSDK.initSDK(appKey: "226344419c2ba87b4309b7d42ac22ae0")

        let instance = NaverThirdPartyLoginConnection.getSharedInstance()
        instance?.isNaverAppOauthEnable = true
        instance?.isInAppOauthEnable = true
        instance?.isOnlyPortraitSupportedInIphone()
        instance?.serviceUrlScheme = kServiceAppUrlScheme   //"net.pettip.PetTip"    //URL Scheme
        instance?.consumerKey = kConsumerKey                //"fk5tuUBi3UzTVQRcBMGK"  //Client ID
        instance?.consumerSecret = kConsumerSecret          //"kbSHyo7KeQ" //Client Secret
        instance?.appName = kServiceAppName                 //"펫팁"    //애플리케이션 이름

        return ret
    }
}
