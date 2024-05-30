//
//  SceneDelegate2.swift
//  PetTip
//
//  Created by isyuun on 2024/4/25.
//

import UIKit
import NaverThirdPartyLogin
import KakaoSDKAuth
import KakaoSDKUser
import GoogleSignIn

class SceneDelegate2: SceneDelegate {

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)]")

        guard let url = URLContexts.first?.url else { return }

        // [iOS] 네이버 로그인 SDK 연동하기 출처: https://doggyfootstep.tistory.com/22 [iOS'DoggyFootstep:티스토리]}
        // iOS 13.0 이후부터 앱 UI와 관련된 생명주기는 SceneDelegate에서 컨트롤하기 때문에 위와 같은 코드가 필요합니다.
        // 네이버 로그인 화면이 새로 등장 -> 토큰을 요청하는 코드
        NaverThirdPartyLoginConnection
            .getSharedInstance()
            .receiveAccessToken(url)

        // iOS 카카오 로그인 구현하기 출처: https://velog.io/@mandos1995/iOS-%EC%B9%B4%EC%B9%B4%EC%98%A4-%EB%A1%9C%EA%B7%B8%EC%9D%B8-%EA%B5%AC%ED%98%84%ED%95%98%EA%B8%B0
        // Deployment target이 iOS 13 이상
        // AppDelegate.swift 파일 대신 SceneDelegate.swift 파일에 handleOpenUrl()을 추가합니다.
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            _ = AuthController.handleOpenUrl(url: url)
        }

        let _ = GIDSignIn.sharedInstance.handle(url)
    }
}
