//
//  SceneDelegate2.swift
//  PetTip
//
//  Created by isyuun on 2024/4/25.
//

import UIKit
import NaverThirdPartyLogin

class SceneDelegate2: SceneDelegate {

    // 출처: https://doggyfootstep.tistory.com/22 [iOS'DoggyFootstep:티스토리]}
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        // 네이버 로그인 화면이 새로 등장 -> 토큰을 요청하는 코드
        NaverThirdPartyLoginConnection
            .getSharedInstance()
            .receiveAccessToken(URLContexts.first?.url)
    }
}
