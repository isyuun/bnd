//
//  SceneDelegate3.swift
//  PetTip
//
//  Created by isyuun on 2024/5/20.
//

import UIKit

class SceneDelegate3: SceneDelegate2 {

    func activity(userActivity: NSUserActivity?) {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)]")
        // Get URL components from the incoming user activity.
        guard let userActivity = userActivity,
            userActivity.activityType == NSUserActivityTypeBrowsingWeb,
            let incomingURL = userActivity.webpageURL,
            let components = NSURLComponents(url: incomingURL, resolvingAgainstBaseURL: true) else {
            return
        }

        // Check for specific URL components that you need.
        guard let path = components.path else { return }
        print("path = \(path)")

        guard let app = UIApplication.shared.delegate as? AppDelegate3 else { return }
        app.window = self.window
        app.path(path: path)
    }

    func invitation() {
        guard let app = UIApplication.shared.delegate as? AppDelegate3 else { return }
        app.invitation()
    }

    override func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)]")
        super.scene(scene, willConnectTo: session, options: connectionOptions)

        activity(userActivity: connectionOptions.userActivities.first)

        // guard let params = components.queryItems else { return }
        // print("params = \(params)")
        //
        // if let albumName = params.first(where: { $0.name == "albumname" })?.value,
        //     let photoIndex = params.first(where: { $0.name == "index" })?.value {
        //
        //     print("album = \(albumName)")
        //     print("photoIndex = \(photoIndex)")
        // } else {
        //     print("Either album name or photo index missing")
        // }
        // return
    }

    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)]")
        // window(scene: scene)

        activity(userActivity: userActivity)
        invitation()
    }
}
