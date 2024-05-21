//
//  AppDelegate3.swift
//  PetTip
//
//  Created by isyuun on 2024/5/20.
//

import UIKit

@UIApplicationMain
class AppDelegate3: AppDelegate2 {

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {

        // Get URL components from the incoming user activity.
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
            let incomingURL = userActivity.webpageURL,
            let components = NSURLComponents(url: incomingURL, resolvingAgainstBaseURL: true) else {
            return false
        }


        // Check for specific URL components that you need.
        guard let path = components.path,
            let params = components.queryItems else {
            return false
        }
        print("path = \(path)")


        if let albumName = params.first(where: { $0.name == "albumname" })?.value,
            let photoIndex = params.first(where: { $0.name == "index" })?.value {


            print("album = \(albumName)")
            print("photoIndex = \(photoIndex)")
            return true


        } else {
            print("Either album name or photo index missing")
            return false
        }
    }
}
