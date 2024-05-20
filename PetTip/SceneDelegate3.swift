//
//  SceneDelegate3.swift
//  PetTip
//
//  Created by isyuun on 2024/5/20.
//

import UIKit

class SceneDelegate3: SceneDelegate2 {
    // func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
    //     //전달된 userActivity의 값을 검증
    //     guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
    //         let incomingURL = userActivity.webpageURL,
    //         let components = URLComponents(url: incomingURL, resolvingAgainstBaseURL: true),
    //         let path = components.path else {
    //         return
    //     }
    // 
    //     //도메인 주소의 쿼리값을 받음
    //     let params = components.queryItems ?? [URLQueryItem]()
    //     print("path = \(incomingURL)")
    //     print("params = \(params)")
    // 
    //     // 검출한 path를 이용하여 어떤 computer를 보여주어야 하는지 결정
    //     if let computer = ItemHandler.sharedInstance.items.filter({ $0.path == components.path }).first {
    //         self.presentDetailViewController(computer)
    //         return true
    //     }
    // 
    //     // 보여주어야할 computer가 결정되지 못하면, application에 URL을 open하도록 요청하여 사파리 연결
    //     let webpageUrl = URL(string: "http://rw-universal-links-final.herokuapp.com")!
    //     application.openURL(webpageUrl)
    // 
    // }
    // 
    // func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    //     for urlContext in URLContexts {
    //         let urlToOpen = urlContext.url
    //         // ...
    //     }
    // }
}
