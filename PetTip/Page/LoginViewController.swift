//
//  LoginViewController.swift
//  PetTip
//
//  Created by carebiz on 12/3/23.
//

import UIKit
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import NaverThirdPartyLogin
import AuthenticationServices

class LoginViewController: CommonViewController2 {

    @IBOutlet weak var loginView: UIView!

    @IBOutlet weak var inputBoxID: UITextField!
    @IBOutlet weak var inputBoxPW: UITextField!

    @IBOutlet weak var btnLoginKakao: UIButton!
    @IBOutlet weak var btnLoginNaver: UIButton!
    @IBOutlet weak var btnLoginFacebook: UIButton!
    @IBOutlet weak var btnLoginGoogle: UIButton!
    @IBOutlet weak var btnLoginApple: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.init(hex: "#FFF6F8FC")

        loginView.layer.cornerRadius = 35
        loginView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        loginView.layer.masksToBounds = true

        inputBoxID.layer.borderColor = UIColor.init(hex: "#E3E9F2")?.cgColor
        inputBoxID.initLeftIconIncludeTextField(iconImg: UIImage(named: "icon_email")!)

        inputBoxPW.layer.borderColor = UIColor.init(hex: "#E3E9F2")?.cgColor
        inputBoxPW.initLeftIconIncludeTextField(iconImg: UIImage(named: "icon_password")!)

        btnLogin.setTitleColor(UIColor.white, for: .normal)
        btnLogin.showShadowMid()

        btnLoginKakao.showShadowMid()
        var imageView = UIImageView(frame: CGRectMake(27, 12, 22, 22))
        imageView.image = UIImage(named: "icon_kakao")
        btnLoginKakao.addSubview(imageView)

        btnLoginNaver.showShadowMid()
        imageView = UIImageView(frame: CGRectMake(27, 12, 22, 22))
        imageView.image = UIImage(named: "icon_naver")
        btnLoginNaver.addSubview(imageView)

        btnLoginFacebook.showShadowMid()
        imageView = UIImageView(frame: CGRectMake(27, 12, 22, 22))
        imageView.image = UIImage(named: "icon_facebook")
        btnLoginFacebook.addSubview(imageView)

        btnLoginGoogle.showShadowMid()
        imageView = UIImageView(frame: CGRectMake(27, 12, 22, 22))
        imageView.image = UIImage(named: "icon_google")
        btnLoginGoogle.addSubview(imageView)

        btnLoginApple.showShadowMid()
        imageView = UIImageView(frame: CGRectMake(27, 12, 22, 22))
        imageView.image = UIImage(named: "icon_apple")
        btnLoginApple.addSubview(imageView)

        if let email = UserDefaults.standard.value(forKey: "email") as? String {
            inputBoxID.text = email
        }

    }

    @IBOutlet weak var btnLogin: UIButton!
    @IBAction func onLogin(_ sender: Any) {
        login()
    }

    func login() {
        inputBoxID.resignFirstResponder()
        inputBoxPW.resignFirstResponder()

        let inputId = inputBoxID.text ?? ""
        let inputPw = inputBoxPW.text ?? ""
        if (inputId.contains("@") && inputId.contains(".")
                && inputPw.count >= 4) {
            member_Login()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.showToast(msg: "아이디 및 패스워드를 확인해주세요")
            })
        }
    }

    func member_Login() {
        startLoading()

        let request = LoginRequest(appTypNm: Util.getModel(), userID: inputBoxID.text!, userPW: inputBoxPW.text!)
        MemberAPI.login(request: request) { login, error in
            self.stopLoading()

            if let login = login {
                let userDef = UserDefaults.standard
                userDef.set(login.accessToken, forKey: "accessToken")
                userDef.set(login.refreshToken, forKey: "refreshToken")
                userDef.set(login.userId, forKey: "userId")
                userDef.set(login.email, forKey: "email")
                userDef.set(login.nckNm, forKey: "nckNm")
                userDef.set("EMAIL", forKey: "method")
                userDef.synchronize()
                // KeychainServiceImpl.shared.accessToken = login.accessToken
                // KeychainServiceImpl.shared.refreshToken = login.refreshToken

                self.trmnlMng(appKeyVl: login.appKeyVl)
            }

            self.processNetworkError(error)
        }
    }

    private func trmnlMng(appKeyVl: String?) {
        if (appKeyVl == nil || appKeyVl == "") || appKeyVl != Global.appKey {

            let request = TrmnlMngRequest(appKey: Global.appKey, appOs: "002", appTypNm: Util.getModel())
            MemberAPI.trmnlMng(request: request) { login, error in
                self.stopLoading()

                self.performSegue(withIdentifier: "segueLoginToMain", sender: self)
            }

        } else {
            self.performSegue(withIdentifier: "segueLoginToMain", sender: self)
        }
    }

    override func processNetworkError(_ error: MyError?) {
        if let error = error {
            if let resCode = error.resCode {
                if resCode == 406 {
                    DispatchQueue.main.async {
                        self.showSimpleAlert(msg: "아이디 및 패스워드를 확인해주세요")
                    }
                    return
                }
            }

            self.showSimpleAlert(title: "Network fail", msg: error.description)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueLoginToFindId") {
            let dest = segue.destination
            guard let vc = dest as? FindIdPwViewController else { return }
            vc.launchTabPageIndex = 0

        } else if (segue.identifier == "segueLoginToFindPw") {
            let dest = segue.destination
            guard let vc = dest as? FindIdPwViewController else { return }
            vc.launchTabPageIndex = 1
        }
    }

    private func snsLogin(userId: String, userPw: String, loginMethod: String) {
        self.startLoading()

        let request = LoginRequest(appTypNm: Util.getModel(), userID: userId, userPW: userPw)
        MemberAPI.login(request: request) { login, error in
            self.stopLoading()

            NSLog("[LOG][W][네트워크][\(String(describing: login))][\(String(describing: error?.resCode))][\(String(describing: error?.description))]")
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
                let snsJoinViewcontroller = UIStoryboard(name: "Member", bundle: nil).instantiateViewController(identifier: "SNSJoinViewcontroller") as SNSJoinViewcontroller
                snsJoinViewcontroller.memberData = MemberJoinData(id: userId, pw: userPw, nick: "", method: loginMethod)
                self.navigationController?.pushViewController(snsJoinViewcontroller, animated: true)
            }
        }
    }

    // MARK: - KAKAO LOGIN
    @IBAction func onLoginKakao(_ sender: Any) {
        startKakaoLogin()
    }

    private func startKakaoLogin() {
        NSLog("[LOG][I][카카오로그인][시작][ST]")
        self.startLoading()

        if (UserApi.isKakaoTalkLoginAvailable()) {
            // 카카오톡 설치된 경우 카톡 실행
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                NSLog("[LOG][I][카카오로그인][카톡][ST][\(String(describing: oauthToken))][\(String(describing: error))]")
                onKakaoLoginCompleted(oauthToken?.accessToken)
            }
        } else {
            // 카카오톡 설치되지 않은 경우 카카오 로그인 웹뷰를 띄운다.
            UserApi.shared.loginWithKakaoAccount(prompts: [.Login]) { oauthToken, error in
                NSLog("[LOG][I][카카오로그인][웹앱][ST][\(String(describing: oauthToken))][\(String(describing: error))]")
                onKakaoLoginCompleted(oauthToken?.accessToken)
            }
        }

        func onKakaoLoginCompleted(_ accessToken: String?) {
            NSLog("[LOG][I][카카오로그인][확인][ST][\(String(describing: accessToken))]")
            self.stopLoading()
            getKakaoUserInfo(accessToken)
        }

        func getKakaoUserInfo(_ accessToken: String?) {
            NSLog("[LOG][I][카카오로그인][로긴][ST][\(String(describing: accessToken))]")
            UserApi.shared.me() { user, error in

                if let email = user?.kakaoAccount?.email, let id = user?.id {
                    self.snsLogin(userId: email, userPw: String(describing: id), loginMethod: "KAKAO")
                } else {
                    self.showSimpleAlert(msg: "KAKAO 로그인에 문제가 발생했어요")
                }
            }
            NSLog("[LOG][I][카카오로그인][로긴][ED][\(String(describing: accessToken))]")
        }
        NSLog("[LOG][I][카카오로그인][시작][ED]")
    }

    // MARK: - NAVER LOGIN
    @IBAction func onLoginNaver(_ sender: Any) {
        startNaverLogin()
    }

    // MARK: - APPLE LOGIN
    @IBAction func onLoginApple(_ sender: Any) {
        startAppleLogin()
    }

    private func startAppleLogin() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

extension LoginViewController: NaverThirdPartyLoginConnectionDelegate {
    // 네이버 로그인 실패 시 호출되는 메서드
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        NSLog("[LOG][I][네이버로그인][실패][oauth20ConnectionDidFinishRequestACTokenWithRefreshToken]")
    }

    // 네이버 로그인 창이 닫혔을 때 호출되는 메서드
    func oauth20ConnectionDidFinishDeleteToken() {
        NSLog("[LOG][I][네이버로그인][취소][oauth20ConnectionDidFinishDeleteToken]")
    }

    // 에러 발생 시 호출되는 메서드
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        NSLog("[LOG][I][네이버로그인][에러][oauth20Connection][\(error.localizedDescription)]")
    }

    // 네이버 로그인 성공 시 호출되는 메서드
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
        NSLog("[LOG][I][네이버로그인][확인][ST][oauth20ConnectionDidFinishRequestACTokenWithAuthCode][\(String(describing: loginInstance))]")
        if loginInstance == nil {
            NSLog("[LOG][E][네이버로그인][확인][NG][oauth20ConnectionDidFinishRequestACTokenWithAuthCode][\(String(describing: loginInstance))]")
            return
        }
        if loginInstance?.accessToken != nil {
            NSLog("[LOG][W][네이버로그인][확인][OK][oauth20ConnectionDidFinishRequestACTokenWithAuthCode][\(String(describing: loginInstance))]")
            self.getNaverUserInfo(loginInstance?.tokenType, loginInstance?.accessToken)
        }
        NSLog("[LOG][I][네이버로그인][확인][ED][oauth20ConnectionDidFinishRequestACTokenWithAuthCode][\(String(describing: loginInstance))]")
    }

    func requestNaverLogin() {
        NSLog("[LOG][I][네이버로그인][요청][requestNaverLogin]")
        guard let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance() else { return }
        loginInstance.delegate = self
        loginInstance.requestThirdPartyLogin()
    }

    func startNaverLogin() {
        NSLog("[LOG][I][네이버로그인][시작][requestNaverLogin]")
        guard let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance() else { return }
        if loginInstance.isValidAccessTokenExpireTimeNow() {
            self.getNaverUserInfo(loginInstance.tokenType, loginInstance.accessToken)
            return
        }
        requestNaverLogin()
    }

    func getNaverUserInfo(_ tokenType: String?, _ accessToken: String?) {
        NSLog("[LOG][I][네이버로그인][로긴][getNaverUserInfo]")
        guard let tokenType = tokenType else { return }
        guard let accessToken = accessToken else { return }

        let urlString = "https://openapi.naver.com/v1/nid/me"
        let session = URLSession.shared
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)

        let authorization = "\(tokenType) \(accessToken)"
        request.addValue(authorization, forHTTPHeaderField: "Authorization")

        session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
            if let responseData = data
            {
                do {
                    let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? NSDictionary
                    let rescode = json?.value(forKey: "resultcode") as? String
                    let message = json?.value(forKey: "message") as? String
                    print("[NAVER][로그인][resultcode:\(String(describing: rescode))][message:\(String(describing: message))]")
                    if let response = json?.value(forKey: "response") as? NSDictionary
                    {
                        let email = response.value(forKey: "email") as? String
                        let _id = response.value(forKey: "id") as? String

                        if let email = email, let _id = _id {
                            self.snsLogin(userId: email, userPw: String(describing: _id), loginMethod: "NAVER")
                        } else {
                            self.showSimpleAlert(msg: "NAVER 로그인에 문제가 발생했어요 [E]\n\(String(describing: message))")
                        }
                    } else {
                        self.requestNaverLogin()
                    }
                } catch {
                    self.showSimpleAlert(msg: "NAVER 로그인에 문제가 발생했어요 [N]")
                }
            }
        }).resume()
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }

        // 처음 애플 로그인 시 이메일은 credential.email 에 들어있다.
        var _email = ""
        if let email = credential.email {
            _email = email
        }
        // 두번째부터는 credential.email은 nil이고, credential.identityToken에 들어있다.
            else {
            // credential.identityToken은 jwt로 되어있고, 해당 토큰을 decode 후 email에 접근해야한다.
            if let tokenString = String(data: credential.identityToken ?? Data(), encoding: .utf8) {
                let email2 = Util.decode(jwtToken: tokenString)["email"] as? String ?? ""
                _email = email2
            }
        }

        // // 처음 애플 로그인 시 이메일은 credential.fullName 에 들어있다.
        // if let fullName = credential.fullName {
        //     // print("이름 : \(fullName.familyName ?? "")\(fullName.givenName ?? "")")
        // }

        // print("userIdentifier : \(credential.user)")
        let user = credential.user

        self.snsLogin(userId: _email, userPw: user, loginMethod: "APPLE")
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        self.showToast(msg: "APPLE 로그인에 문제가 발생했어요")
    }
}
