//
//  MyPetAPI.swift
//  PetTip
//
//  Created by carebiz on 12/10/23.
//

import Foundation
import Alamofire

struct MyPetAPI {
    static func create(request: MyPetCreateRequest, completion: @escaping (_ succeed: MyPetCreateResponse?, _ failed: MyError?) -> Void) {
        let authenticator = MyAuthenticator()
        let credential = MyAuthenticationCredential(accessToken: UserDefaults.standard.value(forKey: "accessToken") as! String,
                                                    refreshToken: UserDefaults.standard.value(forKey: "refreshToken") as! String)
        let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator,
                                                                    credential: credential)

        let header: HTTPHeaders = [
            "Content-Type": "multipart/form-data",
            "accept": "application/json"
        ]

        API.session.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(request.petRelCd.data(using: .utf8)!, withName: "petRelCd")
            multipartFormData.append(request.petNm.data(using: .utf8)!, withName: "petNm")
            multipartFormData.append(request.petRegNo.data(using: .utf8)!, withName: "petRegNo")
            multipartFormData.append(request.stdgSggCd.data(using: .utf8)!, withName: "stdgSggCd")
            multipartFormData.append(request.petInfoUnqNo.data(using: .utf8)!, withName: "petInfoUnqNo")
            multipartFormData.append(request.petBrthYmd.data(using: .utf8)!, withName: "petBrthYmd")
            multipartFormData.append(request.stdgUmdCd.data(using: .utf8)!, withName: "stdgUmdCd")
            multipartFormData.append(request.delYn.data(using: .utf8)!, withName: "delYn")

            if let file = request.file {
                multipartFormData.append(file.jpegData(compressionQuality: 0.7)!,
                                         withName: "file",
                                         fileName: "profile.jpg",
                                         mimeType: "image/*")
            }

            multipartFormData.append(request.ntrTypCd.data(using: .utf8)!, withName: "ntrTypCd")
            multipartFormData.append(request.petRprsYn.data(using: .utf8)!, withName: "petRprsYn")
            multipartFormData.append(request.sexTypCd.data(using: .utf8)!, withName: "sexTypCd")
            multipartFormData.append(request.petMngrYn.data(using: .utf8)!, withName: "petMngrYn")
            multipartFormData.append(request.stdgCtpvCd.data(using: .utf8)!, withName: "stdgCtpvCd")
            multipartFormData.append("\(request.wghtVl)".data(using: .utf8)!, withName: "wghtVl")

        }, to: String("\(Global.BASE_URI)/mypet/create"),
                           usingThreshold: UInt64.init(),
                           method: .post,
                           headers: header,
                           interceptor: myAuthencitationInterceptor)
            .validate()
            .responseDecodable(completionHandler: { (response: AFDataResponse<MyPetCreateResponse>) in
            switch response.result {
            case .success(let response):
                completion(response, nil)
            case .failure(let error):
                let myError = MyError()
                myError.description = "[\(self):\(#line)]\n\(error.localizedDescription)"
                myError.resCode = if response.response?.statusCode == 200 { 999 } else { response.response?.statusCode ?? 999 }
                completion(nil, myError)
            }
        })
    }

    static func delete(request: MyPetDeleteRequest, completion: @escaping (_ succeed: MyPetDeleteResponse?, _ failed: MyError?) -> Void) {
        let authenticator = MyAuthenticator()
        let credential = MyAuthenticationCredential(accessToken: UserDefaults.standard.value(forKey: "accessToken") as! String,
                                                    refreshToken: UserDefaults.standard.value(forKey: "refreshToken") as! String)
        let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator,
                                                                    credential: credential)

        API.session.request(MyPetTarget.delete(request), interceptor: myAuthencitationInterceptor)
            .responseDecodable { (response: AFDataResponse<MyPetDeleteResponse>) in
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

    static func update(request: MyPetUpdateRequest, completion: @escaping (_ succeed: MyPetUpdateResponse?, _ failed: MyError?) -> Void) {
        let authenticator = MyAuthenticator()
        let credential = MyAuthenticationCredential(accessToken: UserDefaults.standard.value(forKey: "accessToken") as! String,
                                                    refreshToken: UserDefaults.standard.value(forKey: "refreshToken") as! String)
        let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator,
                                                                    credential: credential)

        let header: HTTPHeaders = [
            "Content-Type": "multipart/form-data",
            "accept": "application/json"
        ]

        API.session.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(request.ownrPetUnqNo.data(using: .utf8)!, withName: "ownrPetUnqNo")
            multipartFormData.append(request.petRelCd.data(using: .utf8)!, withName: "petRelCd")
            multipartFormData.append(request.petNm.data(using: .utf8)!, withName: "petNm")
            multipartFormData.append(request.petRegNo.data(using: .utf8)!, withName: "petRegNo")
            multipartFormData.append(request.stdgSggCd.data(using: .utf8)!, withName: "stdgSggCd")
            multipartFormData.append(request.petInfoUnqNo.data(using: .utf8)!, withName: "petInfoUnqNo")
            multipartFormData.append(request.petBrthYmd.data(using: .utf8)!, withName: "petBrthYmd")
            multipartFormData.append(request.stdgUmdCd.data(using: .utf8)!, withName: "stdgUmdCd")
            multipartFormData.append(request.delYn.data(using: .utf8)!, withName: "delYn")

            if let file = request.file {
                multipartFormData.append(file.jpegData(compressionQuality: 0.7)!,
                                         withName: "file",
                                         fileName: "profile.jpg",
                                         mimeType: "image/*")
            }

            multipartFormData.append(request.ntrTypCd.data(using: .utf8)!, withName: "ntrTypCd")
            multipartFormData.append(request.petRprsYn.data(using: .utf8)!, withName: "petRprsYn")
            multipartFormData.append(request.sexTypCd.data(using: .utf8)!, withName: "sexTypCd")
            multipartFormData.append(request.petMngrYn.data(using: .utf8)!, withName: "petMngrYn")
            multipartFormData.append(request.stdgCtpvCd.data(using: .utf8)!, withName: "stdgCtpvCd")

        }, to: String("\(Global.BASE_URI)/mypet/update"),
                           usingThreshold: UInt64.init(),
                           method: .post,
                           headers: header,
                           interceptor: myAuthencitationInterceptor)
            .validate()
            .responseDecodable(completionHandler: { (response: AFDataResponse<MyPetUpdateResponse>) in
            switch response.result {
            case .success(let response):
                completion(response, nil)
            case .failure(let error):
                let myError = MyError()
                myError.description = "[\(self):\(#line)]\n\(error.localizedDescription)"
                myError.resCode = if response.response?.statusCode == 200 { 999 } else { response.response?.statusCode ?? 999 }
                completion(nil, myError)
            }
        })
    }

    static func list(request: MyPetListRequest, completion: @escaping (_ succeed: MyPetList?, _ failed: MyError?) -> Void) {
        let authenticator = MyAuthenticator()
        let credential = MyAuthenticationCredential(accessToken: UserDefaults.standard.value(forKey: "accessToken") as! String,
                                                    refreshToken: UserDefaults.standard.value(forKey: "refreshToken") as! String)
        let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator,
                                                                    credential: credential)

        API.session.request(MyPetTarget.list(request), interceptor: myAuthencitationInterceptor)
            .responseDecodable { (response: AFDataResponse<MyPetListResponse>) in
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

    static func detail(request: MyPetDetailRequest, completion: @escaping (_ succeed: MyPetDetailResponse?, _ failed: MyError?) -> Void) {
        let authenticator = MyAuthenticator()
        let credential = MyAuthenticationCredential(accessToken: UserDefaults.standard.value(forKey: "accessToken") as! String,
                                                    refreshToken: UserDefaults.standard.value(forKey: "refreshToken") as! String)
        let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator,
                                                                    credential: credential)

        API.session.request(MyPetTarget.detail(request), interceptor: myAuthencitationInterceptor)
            .responseDecodable { (response: AFDataResponse<MyPetDetailResponse>) in
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

    static func invttCreate(request: MyPetInvttCreateRequest, completion: @escaping (_ succeed: MyPetInvttCreateData?, _ failed: MyError?) -> Void) {
        let authenticator = MyAuthenticator()
        let credential = MyAuthenticationCredential(accessToken: UserDefaults.standard.value(forKey: "accessToken") as! String,
                                                    refreshToken: UserDefaults.standard.value(forKey: "refreshToken") as! String)
        let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator,
                                                                    credential: credential)

        API.session.request(MyPetTarget.invttCreate(request), interceptor: myAuthencitationInterceptor)
            .responseDecodable { (response: AFDataResponse<MyPetInvttCreateResponse>) in
            switch response.result {
            case .success(let response):
                completion(response.data, nil)
            case .failure(let error):
                let myError = MyError()
                myError.description = "[\(self):\(#line)]\n\(error.localizedDescription)"
                myError.resCode = if response.response?.statusCode == 200 { 999 } else { response.response?.statusCode ?? 999 }
                completion(nil, myError)
            }
        }
    }

    static func invttSetKey(request: MyPetInvttSetKeyRequest, completion: @escaping (_ succeed: MyPetInvttSetKeyResponse?, _ failed: MyError?) -> Void) {
        let authenticator = MyAuthenticator()
        let credential = MyAuthenticationCredential(accessToken: UserDefaults.standard.value(forKey: "accessToken") as! String,
                                                    refreshToken: UserDefaults.standard.value(forKey: "refreshToken") as! String)
        let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator,
                                                                    credential: credential)

        API.session.request(MyPetTarget.invttSetKey(request), interceptor: myAuthencitationInterceptor)
            .responseDecodable { (response: AFDataResponse<MyPetInvttSetKeyResponse>) in
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

    static func weightCreate(request: MyPetWeightCreateRequest, completion: @escaping (_ succeed: MyPetWeightCreateResponse?, _ failed: MyError?) -> Void) {
        let authenticator = MyAuthenticator()
        let credential = MyAuthenticationCredential(accessToken: UserDefaults.standard.value(forKey: "accessToken") as! String,
                                                    refreshToken: UserDefaults.standard.value(forKey: "refreshToken") as! String)
        let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator,
                                                                    credential: credential)

        API.session.request(MyPetTarget.weightCreate(request), interceptor: myAuthencitationInterceptor)
            .responseDecodable { (response: AFDataResponse<MyPetWeightCreateResponse>) in
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

    static func weightList(request: MyPetWeightListRequest, completion: @escaping (_ succeed: MyPetWeightListResponse?, _ failed: MyError?) -> Void) {
        let authenticator = MyAuthenticator()
        let credential = MyAuthenticationCredential(accessToken: UserDefaults.standard.value(forKey: "accessToken") as! String,
                                                    refreshToken: UserDefaults.standard.value(forKey: "refreshToken") as! String)
        let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator,
                                                                    credential: credential)

        API.session.request(MyPetTarget.weightList(request), interceptor: myAuthencitationInterceptor)
            .responseDecodable { (response: AFDataResponse<MyPetWeightListResponse>) in
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

    static func weightUpdate(request: MyPetWeightUpdateRequest, completion: @escaping (_ succeed: MyPetWeightUpdateResponse?, _ failed: MyError?) -> Void) {
        let authenticator = MyAuthenticator()
        let credential = MyAuthenticationCredential(accessToken: UserDefaults.standard.value(forKey: "accessToken") as! String,
                                                    refreshToken: UserDefaults.standard.value(forKey: "refreshToken") as! String)
        let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator,
                                                                    credential: credential)

        API.session.request(MyPetTarget.weightUpdate(request), interceptor: myAuthencitationInterceptor)
            .responseDecodable { (response: AFDataResponse<MyPetWeightUpdateResponse>) in
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

    static func weightDelete(request: MyPetWeightDeleteRequest, completion: @escaping (_ succeed: MyPetWeightDeleteResponse?, _ failed: MyError?) -> Void) {
        let authenticator = MyAuthenticator()
        let credential = MyAuthenticationCredential(accessToken: UserDefaults.standard.value(forKey: "accessToken") as! String,
                                                    refreshToken: UserDefaults.standard.value(forKey: "refreshToken") as! String)
        let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator,
                                                                    credential: credential)

        API.session.request(MyPetTarget.weightDelete(request), interceptor: myAuthencitationInterceptor)
            .responseDecodable { (response: AFDataResponse<MyPetWeightDeleteResponse>) in
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

    static func relClose(request: MyPetRelCloseRequest, completion: @escaping (_ succeed: MyPetRelCloseResponse?, _ failed: MyError?) -> Void) {
        let authenticator = MyAuthenticator()
        let credential = MyAuthenticationCredential(accessToken: UserDefaults.standard.value(forKey: "accessToken") as! String,
                                                    refreshToken: UserDefaults.standard.value(forKey: "refreshToken") as! String)
        let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator,
                                                                    credential: credential)

        API.session.request(MyPetTarget.relClose(request), interceptor: myAuthencitationInterceptor)
            .responseDecodable { (response: AFDataResponse<MyPetRelCloseResponse>) in
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
