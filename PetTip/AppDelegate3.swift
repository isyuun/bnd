//
//  AppDelegate3.swift
//  PetTip
//
//  Created by isyuun on 2024/5/20.
//

import UIKit

@UIApplicationMain
class AppDelegate3: AppDelegate2 {

    // override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    //     NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)]")
    //     return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    // }
    //
    // // For iOS 13 and later
    // override func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    //     NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)]")
    //     return super.application(application, configurationForConnecting: connectingSceneSession, options: options)
    // }
    //
    // override func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    //     NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)]")
    //     super.application(application, didDiscardSceneSessions: sceneSessions)
    // }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)]")

        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
            let incomingURL = userActivity.webpageURL,
            let components = NSURLComponents(url: incomingURL, resolvingAgainstBaseURL: true) else {
            return false
        }

        guard let path = components.path else { return false }
        print("path = \(path)")

        self.path(path: path)

        return true
    }

    private var _window: UIWindow?
    var window: UIWindow? {
        get {
            return self._window
        }
        set {
            self._window = newValue
        }
    }

    internal func invitation() {
        if let key = Global.invttKeyVl { self.invitation(key: key) }
    }

    internal func invitation(key: String) {
        NSLog("[LOG][I][ST][(\(#fileID):\(#line))::\(#function)][key:\(key)]")
        // 초기 뷰 컨트롤러를 스토리보드를 통해 인스턴스화합니다.
        let storyboard = UIStoryboard(name: "MyPage", bundle: nil)
        guard let initialViewController = storyboard.instantiateViewController(withIdentifier: "inviteSetKeyViewController") as? InviteSetKeyViewController3 else {
            NSLog("[LOG][I][NG][(\(#fileID):\(#line))::\(#function)][storyboard:\(storyboard)]")
            return
        }
        initialViewController.invttKeyVl = key

        // 현재 윈도우의 rootViewController를 가져옵니다.
        guard let rootViewController = self._window?.rootViewController else {
            NSLog("[LOG][I][NG][(\(#fileID):\(#line))::\(#function)][window:\(String(describing: self._window))][rootViewController:\(String(describing: self._window?.rootViewController))]")
            return
        }

        // 만약 rootViewController가 UINavigationController이면 해당 navigationController에 push합니다.
        if let navigationController = rootViewController as? UINavigationController {
            navigationController.pushViewController(initialViewController, animated: true)
        } else {
            // 만약 rootViewController가 UINavigationController이 아니면 새로운 UINavigationController를 생성하여 rootViewController로 설정합니다.
            let navigationController = UINavigationController(rootViewController: initialViewController)
            self._window?.rootViewController = navigationController
        }
        NSLog("[LOG][I][ED][(\(#fileID):\(#line))::\(#function)][key:\(key)]")
    }

    internal func alert(title: String? = nil, message: String) {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][title:\(String(describing: title))][message:\(message)]")
        var topWindow: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
        topWindow?.rootViewController = UIViewController()
        topWindow?.windowLevel = UIWindow.Level.alert + 1

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel) { _ in
            topWindow?.isHidden = true
            topWindow = nil
        })

        topWindow?.makeKeyAndVisible()
        topWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }

    internal func path(path: String) {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][path:\(path)]")
        let paths = path.split(separator: "/")
        if paths.count < 2 { return } // 경로 길이를 확인합니다.
        let action = String(paths[0])
        let key = String(paths[1])
        switch action {
        case "invitation":
            Global.invttKeyVl = key
            break
        default:
            break
        }
    }
}
