//
//  LoginViewController3.swift
//  PetTip
//
//  Created by isyuun on 2024/5/24.
//

import UIKit
import GoogleSignIn

class LoginViewController3: LoginViewController2 {
    override func onLoginKakao(_ sender: Any) {
        super.onLoginKakao(sender)
    }

    override func onLoginNaver(_ sender: Any) {
        super.onLoginNaver(sender)
    }

    override func onLoginApple(_ sender: Any) {
        super.onLoginApple(sender)
    }

    @IBAction func onLoginFacebook(_ sender: Any) {
    }

    @IBAction func onLoginGoogle(_ sender: Any) {
        startGoogleLogin { login, error in
            NSLog("[LOG][W][(\(#fileID):\(#line))::\(#function)][\(String(describing: login))][\(String(describing: error))]")
        }
    }

    private func snsLogin(userId: String, userPw: String, userNick: String = "", loginMethod: String, completion: @escaping (_ succeed: Login?, _ failed: MyError?) -> Void) {
        self.startLoading()

        let request = LoginRequest(appTypNm: Util.getModel(), userID: userId, userPW: userPw)
        MemberAPI.login(request: request) { login, error in
            self.stopLoading()

            NSLog("[LOG][W][(\(#fileID):\(#line))::\(#function)][\(String(describing: login))][\(String(describing: error?.resCode))][\(String(describing: error?.description))]")
            if let login = login {
                let userDef = UserDefaults.standard
                userDef.set(login.accessToken, forKey: "accessToken")
                userDef.set(login.refreshToken, forKey: "refreshToken")
                userDef.set(login.userId, forKey: "userId")
                userDef.set(login.email, forKey: "email")
                userDef.set(login.nckNm, forKey: "nckNm")
                userDef.set(loginMethod, forKey: "method")
                userDef.synchronize()
                // KeychainServiceImpl.shared.accessToken = login.accessToken
                // KeychainServiceImpl.shared.refreshToken = login.refreshToken
                self.trmnlMng(appKeyVl: login.appKeyVl)
            } else {
                let snsJoinViewcontroller = UIStoryboard(name: "Member", bundle: nil).instantiateViewController(identifier: "SNSJoinViewcontroller") as SNSJoinViewController
                snsJoinViewcontroller.memberData = MemberJoinData(id: userId, pw: userPw, nick: userNick, method: loginMethod)
                self.navigationController?.pushViewController(snsJoinViewcontroller, animated: true)
            }
            completion(login, error)
        }
    }


    func startGoogleLogin(completion: @escaping (_ succeed: Login?, _ failed: MyError?) -> Void) {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)]")
        // 출처: https://doggyfootstep.tistory.com/31 [iOS'DoggyFootstep:티스토리]    }
        // rootViewController
        guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else { return }
        // 로그인 진행
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { signInResult, error in
            // guard let result = signInResult else { return }
            guard let user = signInResult?.user else { return }
            guard let profile = signInResult?.user.profile else { return }

            let email = profile.email
            guard let id = user.userID else { return }

            self.snsLogin(userId: email, userPw: id, loginMethod: "GOOGLE") { login, error in
                completion(login, error)
            }
        }
    }
}
