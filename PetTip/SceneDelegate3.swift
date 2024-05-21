//
//  SceneDelegate3.swift
//  PetTip
//
//  Created by isyuun on 2024/5/20.
//

import UIKit

class SceneDelegate3: SceneDelegate2 {

    override func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        super.scene(scene, willConnectTo: session, options: connectionOptions)

        // Get URL components from the incoming user activity.
        guard let userActivity = connectionOptions.userActivities.first,
            userActivity.activityType == NSUserActivityTypeBrowsingWeb,
            let incomingURL = userActivity.webpageURL,
            let components = NSURLComponents(url: incomingURL, resolvingAgainstBaseURL: true) else {
            return
        }


        // Check for specific URL components that you need.
        guard let path = components.path,
            let params = components.queryItems else {
            return
        }
        print("path = \(path)")


        if let albumName = params.first(where: { $0.name == "albumname" })?.value,
            let photoIndex = params.first(where: { $0.name == "index" })?.value {

            print("album = \(albumName)")
            print("photoIndex = \(photoIndex)")
        } else {
            print("Either album name or photo index missing")
        }
    }
}
