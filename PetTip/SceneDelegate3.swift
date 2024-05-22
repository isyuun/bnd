//
//  SceneDelegate3.swift
//  PetTip
//
//  Created by isyuun on 2024/5/20.
//

import UIKit

class SceneDelegate3: SceneDelegate2 {

    override func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)]")
        super.scene(scene, willConnectTo: session, options: connectionOptions)

        // Get URL components from the incoming user activity.
        guard let userActivity = connectionOptions.userActivities.first,
            userActivity.activityType == NSUserActivityTypeBrowsingWeb,
            let incomingURL = userActivity.webpageURL,
            let components = NSURLComponents(url: incomingURL, resolvingAgainstBaseURL: true) else {
            return
        }

        // Check for specific URL components that you need.
        guard let path = components.path else { return }
        print("path = \(path)")

        self.path(path: path)

        guard let params = components.queryItems else { return }
        print("params = \(params)")

        // if let albumName = params.first(where: { $0.name == "albumname" })?.value,
        //     let photoIndex = params.first(where: { $0.name == "index" })?.value {
        //
        //     print("album = \(albumName)")
        //     print("photoIndex = \(photoIndex)")
        // } else {
        //     print("Either album name or photo index missing")
        // }
        return
    }

    func path(path: String) {
        let paths = path.split(separator: "/")
        if paths.count < 1 { return }
        let action = String(paths[0])
        let key = String(paths[1])
        switch action {
        case "invitation":
            invitation(invttKeyVl: key)
            break
        default:
            break
        }
    }

    // var window: UIWindow?

    func invitation(invttKeyVl: String) {
        // 윈도우를 생성합니다.
        self.window = UIWindow(frame: UIScreen.main.bounds)

        // 초기 뷰 컨트롤러를 인스턴스화합니다.
        let initialViewController = InviteSetKeyViewController3()
        initialViewController.invttKeyVl = invttKeyVl

        // 윈도우의 루트 뷰 컨트롤러를 설정합니다.
        self.window?.rootViewController = initialViewController

        // 윈도우를 보이게 만듭니다.
        self.window?.makeKeyAndVisible()
    }
}
