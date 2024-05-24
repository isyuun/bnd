//
//  MemberAPI.swift
//  PetTip
//
//  Created by carebiz on 12/10/23.
//

import Foundation
import Alamofire

struct MemberAPI {

    static func chkNcknm(request: ChkNcknmRequest, completion: @escaping (_ succeed: HTTPURLResponse?, _ failed: MyError?) -> Void) {
        API.session.request(MemberTarget.chkNcknm(request), interceptor: nil)
            .response { resData in
            switch resData.result {
            case .success(_):
                completion(resData.response, nil)
            case .failure(let error):
                let myError = MyError()
                myError.description = "[\(self):\(#line)]\n\(error.localizedDescription)"
                myError.resCode = resData.response?.statusCode ?? 999
                completion(nil, myError)
            }
        }
    }

    static func createUser(request: CreateUserRequest, completion: @escaping (_ succeed: CreateUserResponse?, _ failed: MyError?) -> Void) {
        API.session.request(MemberTarget.createUser(request), interceptor: nil)
            .responseDecodable { (response: AFDataResponse<CreateUserResponse>) in
            switch response.result {
            case .success(let response):
                completion(response, nil)
            case .failure(let error):
                let myError = MyError()
                myError.description = "[\(self):\(#line)]\n\(error.localizedDescription)"
                myError.resCode = if response.response?.statusCode == 200 { 999 } else { response.response?.statusCode ?? 999 }
                completion(nil, myError)
            }
        }
    }

    static func logout(request: LogoutRequest, completion: @escaping (_ succeed: LogoutResponse?, _ failed: MyError?) -> Void) {
        if UserDefaults.standard.value(forKey: "accessToken") == nil
            || UserDefaults.standard.value(forKey: "refreshToken") == nil {
            return
        }

        let authenticator = MyAuthenticator()
        let credential = MyAuthenticationCredential(accessToken: UserDefaults.standard.value(forKey: "accessToken") as! String,
                                                    refreshToken: UserDefaults.standard.value(forKey: "refreshToken") as! String)
        let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator,
                                                                    credential: credential)

        API.session.request(MemberTarget.logout(request), interceptor: myAuthencitationInterceptor)
            .responseDecodable { (response: AFDataResponse<LogoutResponse>) in
            switch response.result {
            case .success(let response):
                completion(response, nil)
            case .failure(let error):
                let myError = MyError()
                myError.description = "[\(self):\(#line)]\n\(error.localizedDescription)"
                myError.resCode = if response.response?.statusCode == 200 { 999 } else { response.response?.statusCode ?? 999 }
                completion(nil, myError)
            }
        }
    }

    static func login(request: LoginRequest, completion: @escaping (_ succeed: Login?, _ failed: MyError?) -> Void) {
        // AF.request(MemberTarget.login(request))
        //     .responseDecodable { (response: AFDataResponse<LoginResponse>) in
        //     print("#response.result: ", response.result)
        // 
        //     switch response.result {
        //     case .success(let response):
        // 
        //         // completion(response.toDomain, nil)
        //         completion(response.statusCode, nil)
        //     case .failure(let error):
        //         completion(nil, error)
        //     }
        // }

        API.session.request(MemberTarget.login(request), interceptor: nil)
            .responseDecodable { (response: AFDataResponse<LoginResponse>) in
            switch response.result {
            case .success(let response):
                completion(response.toDomain, nil)
            case .failure(let error):
                let myError = MyError()
                myError.description = "[\(self):\(#line)]\n\(error.localizedDescription)"
                myError.resCode = if response.response?.statusCode == 200 { 999 } else { response.response?.statusCode ?? 999 }
                completion(nil, myError)
            }
        }
    }

    static func refreshToken(request: RefreshTokenRequest, completion: @escaping (_ succeed: RefreshToken?, _ failed: Error?) -> Void) {
        if UserDefaults.standard.value(forKey: "accessToken") == nil
            || UserDefaults.standard.value(forKey: "refreshToken") == nil {
            return
        }

        let authenticator = MyAuthenticator()
        let credential = MyAuthenticationCredential(accessToken: UserDefaults.standard.value(forKey: "accessToken") as! String,
                                                    refreshToken: UserDefaults.standard.value(forKey: "refreshToken") as! String)
        let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator,
                                                                    credential: credential)

        API.session.request(MemberTarget.refreshToken(request), interceptor: myAuthencitationInterceptor)
            .responseDecodable { (response: AFDataResponse<RefreshTokenResponse>) in
            switch response.result {
            case .success(let response):
                completion(response.toDomain, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }

    static func resetNcknm(request: ResetNcknmRequest, completion: @escaping (_ succeed: HTTPURLResponse?, _ failed: MyError?) -> Void) {
        if UserDefaults.standard.value(forKey: "accessToken") == nil
            || UserDefaults.standard.value(forKey: "refreshToken") == nil {
            return
        }

        let authenticator = MyAuthenticator()
        let credential = MyAuthenticationCredential(accessToken: UserDefaults.standard.value(forKey: "accessToken") as! String,
                                                    refreshToken: UserDefaults.standard.value(forKey: "refreshToken") as! String)
        let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator,
                                                                    credential: credential)

        API.session.request(MemberTarget.resetNcknm(request), interceptor: myAuthencitationInterceptor)
            .response { resData in
            switch resData.result {
            case .success(_):
                completion(resData.response, nil)
            case .failure(let error):
                let myError = MyError()
                myError.description = "[\(self):\(#line)]\n\(error.localizedDescription)"
                myError.resCode = resData.response?.statusCode ?? 999
                completion(nil, myError)
            }
        }
    }

    static func resetPassword(request: ResetPasswordRequest, completion: @escaping (_ succeed: HTTPURLResponse?, _ failed: MyError?) -> Void) {
        API.session.request(MemberTarget.resetPassword(request), interceptor: nil)
            .response { resData in
            switch resData.result {
            case .success(_):
                completion(resData.response, nil)
            case .failure(let error):
                let myError = MyError()
                myError.description = "[\(self):\(#line)]\n\(error.localizedDescription)"
                myError.resCode = resData.response?.statusCode ?? 999
                completion(nil, myError)
            }
        }
    }

    static func withdraw(request: WithdrawRequest, completion: @escaping (_ succeed: HTTPURLResponse?, _ failed: MyError?) -> Void) {
        if UserDefaults.standard.value(forKey: "accessToken") == nil
            || UserDefaults.standard.value(forKey: "refreshToken") == nil {
            return
        }

        let authenticator = MyAuthenticator()
        let credential = MyAuthenticationCredential(accessToken: UserDefaults.standard.value(forKey: "accessToken") as! String,
                                                    refreshToken: UserDefaults.standard.value(forKey: "refreshToken") as! String)
        let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator,
                                                                    credential: credential)

        API.session.request(MemberTarget.withdraw(request), interceptor: myAuthencitationInterceptor)
            .response { resData in
            switch resData.result {
            case .success(_):
                completion(resData.response, nil)
            case .failure(let error):
                let myError = MyError()
                myError.description = "[\(self):\(#line)]\n\(error.localizedDescription)"
                myError.resCode = resData.response?.statusCode ?? 999
                completion(nil, myError)
            }
        }
    }

    static func trmnlMng(request: TrmnlMngRequest, completion: @escaping (_ succeed: TrmnlMngResponse?, _ failed: MyError?) -> Void) {
        if UserDefaults.standard.value(forKey: "accessToken") == nil
            || UserDefaults.standard.value(forKey: "refreshToken") == nil {
            return
        }

        let authenticator = MyAuthenticator()
        let credential = MyAuthenticationCredential(accessToken: UserDefaults.standard.value(forKey: "accessToken") as! String,
                                                    refreshToken: UserDefaults.standard.value(forKey: "refreshToken") as! String)
        let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator,
                                                                    credential: credential)

        API.session.request(MemberTarget.trmnlMng(request), interceptor: myAuthencitationInterceptor)
            .responseDecodable { (response: AFDataResponse<TrmnlMngResponse>) in
            switch response.result {
            case .success(let response):
                completion(response, nil)
            case .failure(let error):
                let myError = MyError()
                myError.description = "[\(self):\(#line)]\n\(error.localizedDescription)"
                myError.resCode = if response.response?.statusCode == 200 { 999 } else { response.response?.statusCode ?? 999 }
                completion(nil, myError)
            }
        }
    }
}
