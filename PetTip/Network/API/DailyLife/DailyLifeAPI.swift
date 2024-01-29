//
//  DailyLifeAPI.swift
//  PetTip
//
//  Created by carebiz on 12/10/23.
//

import Foundation
import Alamofire

struct DailyLifeAPI {
    static func cmntCreate(request: CmntCreateRequest, completion: @escaping (_ succeed: CmntCreate?, _ failed: MyError?) -> Void) {
        if UserDefaults.standard.value(forKey: "accessToken") == nil
            || UserDefaults.standard.value(forKey: "refreshToken") == nil  {
            return
        }
        
        let authenticator = MyAuthenticator()
        let credential = MyAuthenticationCredential(accessToken: UserDefaults.standard.value(forKey: "accessToken") as! String,
                                                    refreshToken: UserDefaults.standard.value(forKey: "refreshToken") as! String)
        let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator,
                                                                        credential: credential)
        
        API.session.request(DailyLifeTarget.cmntCreate(request), interceptor: myAuthencitationInterceptor)
            .responseDecodable { (response: AFDataResponse<CmntCreateResponse>) in
                switch response.result {
                case .success(let response):
                    completion(response.toDomain, nil)
                case .failure(let error):
                    let myError = MyError()
                    myError.description = error.localizedDescription
                    myError.resCode = response.response?.statusCode
                    completion(nil, myError)
                }
            }
    }
    
    static func cmntDelete(request: CmntDeleteRequest, completion: @escaping (_ succeed: CmntDelete?, _ failed: MyError?) -> Void) {
        if UserDefaults.standard.value(forKey: "accessToken") == nil
            || UserDefaults.standard.value(forKey: "refreshToken") == nil  {
            return
        }
        
        let authenticator = MyAuthenticator()
        let credential = MyAuthenticationCredential(accessToken: UserDefaults.standard.value(forKey: "accessToken") as! String,
                                                    refreshToken: UserDefaults.standard.value(forKey: "refreshToken") as! String)
        let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator,
                                                                        credential: credential)
        
        API.session.request(DailyLifeTarget.cmntDelete(request), interceptor: myAuthencitationInterceptor)
            .responseDecodable { (response: AFDataResponse<CmntDeleteResponse>) in
                switch response.result {
                case .success(let response):
                    completion(response.toDomain, nil)
                case .failure(let error):
                    let myError = MyError()
                    myError.description = error.localizedDescription
                    myError.resCode = response.response?.statusCode
                    completion(nil, myError)
                }
            }
    }
    
    static func cmntRcmdtn(request: CmntRcmdtnRequest, completion: @escaping (_ succeed: CmntRcmdtn?, _ failed: MyError?) -> Void) {
        if UserDefaults.standard.value(forKey: "accessToken") == nil
            || UserDefaults.standard.value(forKey: "refreshToken") == nil  {
            return
        }
        
        let authenticator = MyAuthenticator()
        let credential = MyAuthenticationCredential(accessToken: UserDefaults.standard.value(forKey: "accessToken") as! String,
                                                    refreshToken: UserDefaults.standard.value(forKey: "refreshToken") as! String)
        let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator,
                                                                        credential: credential)
        
        API.session.request(DailyLifeTarget.cmntRcmdtn(request), interceptor: myAuthencitationInterceptor)
            .responseDecodable { (response: AFDataResponse<CmntRcmdtnResponse>) in
                switch response.result {
                case .success(let response):
                    completion(response.toDomain, nil)
                case .failure(let error):
                    let myError = MyError()
                    myError.description = error.localizedDescription
                    myError.resCode = response.response?.statusCode
                    completion(nil, myError)
                }
            }
    }
    
    static func cmntUpdate(request: CmntUpdateRequest, completion: @escaping (_ succeed: CmntUpdate?, _ failed: MyError?) -> Void) {
        if UserDefaults.standard.value(forKey: "accessToken") == nil
            || UserDefaults.standard.value(forKey: "refreshToken") == nil  {
            return
        }
        
        let authenticator = MyAuthenticator()
        let credential = MyAuthenticationCredential(accessToken: UserDefaults.standard.value(forKey: "accessToken") as! String,
                                                    refreshToken: UserDefaults.standard.value(forKey: "refreshToken") as! String)
        let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator,
                                                                        credential: credential)
        
        API.session.request(DailyLifeTarget.cmntUpdate(request), interceptor: myAuthencitationInterceptor)
            .responseDecodable { (response: AFDataResponse<CmntUpdateResponse>) in
                switch response.result {
                case .success(let response):
                    completion(response.toDomain, nil)
                case .failure(let error):
                    let myError = MyError()
                    myError.description = error.localizedDescription
                    myError.resCode = response.response?.statusCode
                    completion(nil, myError)
                }
            }
    }
    
    static func dclrCreateStory(request: DclrCreateRequest, completion: @escaping (_ succeed: DclrCreateStory?, _ failed: MyError?) -> Void) {
        if UserDefaults.standard.value(forKey: "accessToken") == nil
            || UserDefaults.standard.value(forKey: "refreshToken") == nil  {
            return
        }
        
        let authenticator = MyAuthenticator()
        let credential = MyAuthenticationCredential(accessToken: UserDefaults.standard.value(forKey: "accessToken") as! String,
                                                    refreshToken: UserDefaults.standard.value(forKey: "refreshToken") as! String)
        let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator,
                                                                        credential: credential)
        
        API.session.request(DailyLifeTarget.dclrCreate(request), interceptor: myAuthencitationInterceptor)
            .responseDecodable { (response: AFDataResponse<DclrCreateStoryResponse>) in
                switch response.result {
                case .success(let response):
                    completion(response.toDomain, nil)
                case .failure(let error):
                    let myError = MyError()
                    myError.description = error.localizedDescription
                    myError.resCode = response.response?.statusCode
                    completion(nil, myError)
                }
            }
    }
    
    static func create(request: LifeCreateRequest, completion: @escaping (_ succeed: LifeCreateResponse?, _ failed: MyError?) -> Void) {
        if UserDefaults.standard.value(forKey: "accessToken") == nil
            || UserDefaults.standard.value(forKey: "refreshToken") == nil  {
            return
        }
        
        let authenticator = MyAuthenticator()
        let credential = MyAuthenticationCredential(accessToken: UserDefaults.standard.value(forKey: "accessToken") as! String,
                                                    refreshToken: UserDefaults.standard.value(forKey: "refreshToken") as! String)
        let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator,
                                                                        credential: credential)
        
        API.session.request(DailyLifeTarget.create(request), interceptor: myAuthencitationInterceptor)
            .responseDecodable { (response: AFDataResponse<LifeCreateResponse>) in
                switch response.result {
                case .success(let response):
                    completion(response, nil)
                case .failure(let error):
                    let myError = MyError()
                    myError.description = error.localizedDescription
                    myError.resCode = response.response?.statusCode
                    completion(nil, myError)
                }
            }
    }
    
    static func dclrCreateCmnt(request: DclrCreateRequest, completion: @escaping (_ succeed: DclrCreateCmnt?, _ failed: MyError?) -> Void) {
        if UserDefaults.standard.value(forKey: "accessToken") == nil
            || UserDefaults.standard.value(forKey: "refreshToken") == nil  {
            return
        }
        
        let authenticator = MyAuthenticator()
        let credential = MyAuthenticationCredential(accessToken: UserDefaults.standard.value(forKey: "accessToken") as! String,
                                                    refreshToken: UserDefaults.standard.value(forKey: "refreshToken") as! String)
        let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator,
                                                                        credential: credential)
        
        API.session.request(DailyLifeTarget.dclrCreate(request), interceptor: myAuthencitationInterceptor)
            .responseDecodable { (response: AFDataResponse<DclrCreateCmntResponse>) in
                switch response.result {
                case .success(let response):
                    completion(response.toDomain, nil)
                case .failure(let error):
                    let myError = MyError()
                    myError.description = error.localizedDescription
                    myError.resCode = response.response?.statusCode
                    completion(nil, myError)
                }
            }
    }
    
    static func petList(request: PetListRequest, completion: @escaping (_ succeed: PetList?, _ failed: Error?) -> Void) {
        API.session.request(DailyLifeTarget.petList(request), interceptor: nil)
            .responseDecodable { (response: AFDataResponse<PetListResponse>) in
                switch response.result {
                case .success(let response):
                    completion(response.toDomain, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
    
    static func rcmdtn(request: RcmdtnRequest, completion: @escaping (_ succeed: LifeView?, _ failed: MyError?) -> Void) {
        if UserDefaults.standard.value(forKey: "accessToken") == nil
            || UserDefaults.standard.value(forKey: "refreshToken") == nil  {
            return
        }
        
        let authenticator = MyAuthenticator()
        let credential = MyAuthenticationCredential(accessToken: UserDefaults.standard.value(forKey: "accessToken") as! String,
                                                    refreshToken: UserDefaults.standard.value(forKey: "refreshToken") as! String)
        let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator,
                                                                        credential: credential)
        
        API.session.request(DailyLifeTarget.rcmdtn(request), interceptor: myAuthencitationInterceptor)
            .responseDecodable { (response: AFDataResponse<RcmdtnResponse>) in
                switch response.result {
                case .success(let response):
                    completion(response.toDomain, nil)
                case .failure(let error):
                    let myError = MyError()
                    myError.description = error.localizedDescription
                    myError.resCode = response.response?.statusCode
                    completion(nil, myError)
                }
            }
    }
    
    static func rlsUpdate(request: RlsUpdateRequest, completion: @escaping (_ succeed: RlsUpdate?, _ failed: MyError?) -> Void) {
        if UserDefaults.standard.value(forKey: "accessToken") == nil
            || UserDefaults.standard.value(forKey: "refreshToken") == nil  {
            return
        }
        
        let authenticator = MyAuthenticator()
        let credential = MyAuthenticationCredential(accessToken: UserDefaults.standard.value(forKey: "accessToken") as! String,
                                                    refreshToken: UserDefaults.standard.value(forKey: "refreshToken") as! String)
        let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator,
                                                                        credential: credential)
        
        API.session.request(DailyLifeTarget.rlsUpdate(request), interceptor: myAuthencitationInterceptor)
            .responseDecodable { (response: AFDataResponse<RlsUpdateResponse>) in
                switch response.result {
                case .success(let response):
                    completion(response.toDomain, nil)
                case .failure(let error):
                    let myError = MyError()
                    myError.description = error.localizedDescription
                    myError.resCode = response.response?.statusCode
                    completion(nil, myError)
                }
            }
    }
    
    static func update(request: LifeUpdateRequest, completion: @escaping (_ succeed: LifeUpdate?, _ failed: MyError?) -> Void) {
        if UserDefaults.standard.value(forKey: "accessToken") == nil
            || UserDefaults.standard.value(forKey: "refreshToken") == nil  {
            return
        }
        
        let authenticator = MyAuthenticator()
        let credential = MyAuthenticationCredential(accessToken: UserDefaults.standard.value(forKey: "accessToken") as! String,
                                                    refreshToken: UserDefaults.standard.value(forKey: "refreshToken") as! String)
        let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator,
                                                                        credential: credential)
        
        API.session.request(DailyLifeTarget.update(request), interceptor: myAuthencitationInterceptor)
            .responseDecodable { (response: AFDataResponse<LifeUpdateResponse>) in
                switch response.result {
                case .success(let response):
                    completion(response.toDomain, nil)
                case .failure(let error):
                    let myError = MyError()
                    myError.description = error.localizedDescription
                    myError.resCode = response.response?.statusCode
                    completion(nil, myError)
                }
            }
    }
    
    static func weekRecord(request: WeekRecordRequest, completion: @escaping (_ succeed: WeekRecord?, _ failed: MyError?) -> Void) {
        if UserDefaults.standard.value(forKey: "accessToken") == nil
            || UserDefaults.standard.value(forKey: "refreshToken") == nil  {
            return
        }
        
        let authenticator = MyAuthenticator()
        let credential = MyAuthenticationCredential(accessToken: UserDefaults.standard.value(forKey: "accessToken") as! String,
                                                    refreshToken: UserDefaults.standard.value(forKey: "refreshToken") as! String)
        let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator,
                                                                        credential: credential)
        
        API.session.request(DailyLifeTarget.weekRecord(request), interceptor: myAuthencitationInterceptor)
            .responseDecodable { (response: AFDataResponse<WeekRecordResponse>) in
                switch response.result {
                case .success(let response):
                    completion(response.toDomain, nil)
                case .failure(let error):
                    let myError = MyError()
                    myError.description = error.localizedDescription
                    myError.resCode = response.response?.statusCode
                    completion(nil, myError)
                }
            }
    }
    
    static func monthRecord(request: MonthRecordRequest, completion: @escaping (_ succeed: MonthRecord?, _ failed: MyError?) -> Void) {
        if UserDefaults.standard.value(forKey: "accessToken") == nil
            || UserDefaults.standard.value(forKey: "refreshToken") == nil  {
            return
        }
        
        let authenticator = MyAuthenticator()
        let credential = MyAuthenticationCredential(accessToken: UserDefaults.standard.value(forKey: "accessToken") as! String,
                                                    refreshToken: UserDefaults.standard.value(forKey: "refreshToken") as! String)
        let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator,
                                                                        credential: credential)
        
        API.session.request(DailyLifeTarget.monthRecord(request), interceptor: myAuthencitationInterceptor)
            .responseDecodable { (response: AFDataResponse<MonthRecordResponse>) in
                switch response.result {
                case .success(let response):
                    completion(response.toDomain, nil)
                case .failure(let error):
                    let myError = MyError()
                    myError.description = error.localizedDescription
                    myError.resCode = response.response?.statusCode
                    completion(nil, myError)
                }
            }
    }
    
    static func view(request: LifeViewRequest, completion: @escaping (_ succeed: LifeView?, _ failed: MyError?) -> Void) {
        if UserDefaults.standard.value(forKey: "accessToken") == nil
            || UserDefaults.standard.value(forKey: "refreshToken") == nil  {
            return
        }
        
        let authenticator = MyAuthenticator()
        let credential = MyAuthenticationCredential(accessToken: UserDefaults.standard.value(forKey: "accessToken") as! String,
                                                    refreshToken: UserDefaults.standard.value(forKey: "refreshToken") as! String)
        let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator,
                                                                        credential: credential)
        
        API.session.request(DailyLifeTarget.view(request), interceptor: myAuthencitationInterceptor)
            .responseDecodable { (response: AFDataResponse<LifeViewResponse>) in
                switch response.result {
                case .success(let response):
                    completion(response.toDomain, nil)
                case .failure(let error):
                    let myError = MyError()
                    myError.description = error.localizedDescription
                    myError.resCode = response.response?.statusCode
                    completion(nil, myError)
                }
            }
    }
    
    static func upload(request: LifeUploadRequest, completion: @escaping (_ succeed: LifeUploadResponse?, _ failed: MyError?) -> Void) {
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
            for i in 0..<request.arrFile.count {
                multipartFormData.append(request.arrFile[i].jpegData(compressionQuality: 0.7)!,
                                         withName: "files",
                                         fileName: "image\(i).jpg",
                                         mimeType: "image/*")
            }
        }, to: "http://carepet.hopto.org:8020/api/v1/daily-life/upload",
                           usingThreshold: UInt64.init(),
                           method: .post,
                           headers: header,
                           interceptor: myAuthencitationInterceptor)
        .validate()
        .responseDecodable(completionHandler: { (response: AFDataResponse<LifeUploadResponse>) in
            switch response.result {
            case .success(let response):
                completion(response, nil)
            case .failure(let error):
                let myError = MyError()
                myError.description = error.localizedDescription
                myError.resCode = response.response?.statusCode
                completion(nil, myError)
            }
        })
    }
}
