//
//  BBSApi.swift
//  PetTip
//
//  Created by carebiz on 12/30/23.
//

import Foundation
import Alamofire

struct BBSAPI {
    static func ancmntWinnerList(request: WinnerListRequest, completion: @escaping (_ succeed: WinnerListData?, _ failed: MyError?) -> Void) {
        if UserDefaults.standard.value(forKey: "accessToken") == nil
            || UserDefaults.standard.value(forKey: "refreshToken") == nil  {
            return
        }
        
        let authenticator = MyAuthenticator()
        let credential = MyAuthenticationCredential(accessToken: UserDefaults.standard.value(forKey: "accessToken") as! String,
                                                    refreshToken: UserDefaults.standard.value(forKey: "refreshToken") as! String)
        let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator,
                                                                        credential: credential)
        
        API.session.request(BBSTarget.ancmntWinnerList(request), interceptor: myAuthencitationInterceptor)
            .responseDecodable { (response: AFDataResponse<WinnerListResponse>) in
                switch response.result {
                case .success(let response):
                    completion(response.data, nil)
                case .failure(let error):
                    let myError = MyError()
                    myError.description = error.localizedDescription
                    myError.resCode = response.response?.statusCode
                    completion(nil, myError)
                }
            }
    }
    
    static func ancmntWinnerDtlList(request: WinnerDtlListRequest, completion: @escaping (_ succeed: WinnerDtlListData?, _ failed: MyError?) -> Void) {
        if UserDefaults.standard.value(forKey: "accessToken") == nil
            || UserDefaults.standard.value(forKey: "refreshToken") == nil  {
            return
        }
        
        let authenticator = MyAuthenticator()
        let credential = MyAuthenticationCredential(accessToken: UserDefaults.standard.value(forKey: "accessToken") as! String,
                                                    refreshToken: UserDefaults.standard.value(forKey: "refreshToken") as! String)
        let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator,
                                                                        credential: credential)
        
        API.session.request(BBSTarget.ancmntWinnerDtlList(request), interceptor: myAuthencitationInterceptor)
            .responseDecodable { (response: AFDataResponse<WinnerDtlListResponse>) in
                switch response.result {
                case .success(let response):
                    completion(response.data, nil)
                case .failure(let error):
                    let myError = MyError()
                    myError.description = error.localizedDescription
                    myError.resCode = response.response?.statusCode
                    completion(nil, myError)
                }
            }
    }
    
    static func eventList(request: EventListRequest, completion: @escaping (_ succeed: EventList?, _ failed: MyError?) -> Void) {
        if UserDefaults.standard.value(forKey: "accessToken") == nil
            || UserDefaults.standard.value(forKey: "refreshToken") == nil  {
            return
        }
        
        let authenticator = MyAuthenticator()
        let credential = MyAuthenticationCredential(accessToken: UserDefaults.standard.value(forKey: "accessToken") as! String,
                                                    refreshToken: UserDefaults.standard.value(forKey: "refreshToken") as! String)
        let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator,
                                                                        credential: credential)
        
        API.session.request(BBSTarget.eventList(request), interceptor: myAuthencitationInterceptor)
            .responseDecodable { (response: AFDataResponse<EventListResponse>) in
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
    
    static func eventDtlList(request: EventDtlListRequest, completion: @escaping (_ succeed: EventDtlListData?, _ failed: MyError?) -> Void) {
        if UserDefaults.standard.value(forKey: "accessToken") == nil
            || UserDefaults.standard.value(forKey: "refreshToken") == nil  {
            return
        }
        
        let authenticator = MyAuthenticator()
        let credential = MyAuthenticationCredential(accessToken: UserDefaults.standard.value(forKey: "accessToken") as! String,
                                                    refreshToken: UserDefaults.standard.value(forKey: "refreshToken") as! String)
        let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator,
                                                                        credential: credential)
        
        API.session.request(BBSTarget.eventDtlList(request), interceptor: myAuthencitationInterceptor)
            .responseDecodable { (response: AFDataResponse<EventDtlListResponse>) in
                switch response.result {
                case .success(let response):
                    completion(response.data, nil)
                case .failure(let error):
                    let myError = MyError()
                    myError.description = error.localizedDescription
                    myError.resCode = response.response?.statusCode
                    completion(nil, myError)
                }
            }
    }
    
    static func noticeList(request: NoticeListRequest, completion: @escaping (_ succeed: NoticeListResponse?, _ failed: MyError?) -> Void) {
        API.session.request(BBSTarget.noticeList(request), interceptor: nil)
            .responseDecodable { (response: AFDataResponse<NoticeListResponse>) in
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
    
    static func noticeDtlList(request: NoticeDtlListRequest, completion: @escaping (_ succeed: NoticeDtlListResponse?, _ failed: MyError?) -> Void) {
        API.session.request(BBSTarget.noticeDtlList(request), interceptor: nil)
            .responseDecodable { (response: AFDataResponse<NoticeDtlListResponse>) in
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
    
    static func qnaList(request: QnAListRequest, completion: @escaping (_ succeed: QnAListResponse?, _ failed: MyError?) -> Void) {
        if UserDefaults.standard.value(forKey: "accessToken") == nil
            || UserDefaults.standard.value(forKey: "refreshToken") == nil  {
            return
        }
        
        let authenticator = MyAuthenticator()
        let credential = MyAuthenticationCredential(accessToken: UserDefaults.standard.value(forKey: "accessToken") as! String,
                                                    refreshToken: UserDefaults.standard.value(forKey: "refreshToken") as! String)
        let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator,
                                                                        credential: credential)
        
        API.session.request(BBSTarget.qnaList(request), interceptor: myAuthencitationInterceptor)
            .responseDecodable { (response: AFDataResponse<QnAListResponse>) in
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
    
    static func qnaCreate(request: QnACreateRequest, completion: @escaping (_ succeed: QnADeleteResponse?, _ failed: MyError?) -> Void) {
        if UserDefaults.standard.value(forKey: "accessToken") == nil
            || UserDefaults.standard.value(forKey: "refreshToken") == nil  {
            return
        }
        
        let authenticator = MyAuthenticator()
        let credential = MyAuthenticationCredential(accessToken: UserDefaults.standard.value(forKey: "accessToken") as! String,
                                                    refreshToken: UserDefaults.standard.value(forKey: "refreshToken") as! String)
        let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator,
                                                                        credential: credential)
        
        API.session.request(BBSTarget.qnaCreate(request), interceptor: myAuthencitationInterceptor)
            .responseDecodable { (response: AFDataResponse<QnADeleteResponse>) in
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
    
    static func qnaDelete(request: QnADeleteRequest, completion: @escaping (_ succeed: QnADeleteResponse?, _ failed: MyError?) -> Void) {
        if UserDefaults.standard.value(forKey: "accessToken") == nil
            || UserDefaults.standard.value(forKey: "refreshToken") == nil  {
            return
        }
        
        let authenticator = MyAuthenticator()
        let credential = MyAuthenticationCredential(accessToken: UserDefaults.standard.value(forKey: "accessToken") as! String,
                                                    refreshToken: UserDefaults.standard.value(forKey: "refreshToken") as! String)
        let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator,
                                                                        credential: credential)
        
        API.session.request(BBSTarget.qnaDelete(request), interceptor: myAuthencitationInterceptor)
            .responseDecodable { (response: AFDataResponse<QnADeleteResponse>) in
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
    
    static func qnaUpdate(request: QnAUpdateRequest, completion: @escaping (_ succeed: QnAUpdateResponse?, _ failed: MyError?) -> Void) {
        if UserDefaults.standard.value(forKey: "accessToken") == nil
            || UserDefaults.standard.value(forKey: "refreshToken") == nil  {
            return
        }
        
        let authenticator = MyAuthenticator()
        let credential = MyAuthenticationCredential(accessToken: UserDefaults.standard.value(forKey: "accessToken") as! String,
                                                    refreshToken: UserDefaults.standard.value(forKey: "refreshToken") as! String)
        let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator,
                                                                        credential: credential)
        
        API.session.request(BBSTarget.qnaUpdate(request), interceptor: myAuthencitationInterceptor)
            .responseDecodable { (response: AFDataResponse<QnAUpdateResponse>) in
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
    
    static func qnaDtlList(request: QnADtlListRequest, completion: @escaping (_ succeed: QnADtlListResponse?, _ failed: MyError?) -> Void) {
        if UserDefaults.standard.value(forKey: "accessToken") == nil
            || UserDefaults.standard.value(forKey: "refreshToken") == nil  {
            return
        }
        
        let authenticator = MyAuthenticator()
        let credential = MyAuthenticationCredential(accessToken: UserDefaults.standard.value(forKey: "accessToken") as! String,
                                                    refreshToken: UserDefaults.standard.value(forKey: "refreshToken") as! String)
        let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator,
                                                                        credential: credential)
        
        API.session.request(BBSTarget.qnaDtlList(request), interceptor: myAuthencitationInterceptor)
            .responseDecodable { (response: AFDataResponse<QnADtlListResponse>) in
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
    
    static func faqList(request: FaqListRequest, completion: @escaping (_ succeed: FaqListResponse?, _ failed: MyError?) -> Void) {
        API.session.request(BBSTarget.faqList(request), interceptor: nil)
            .responseDecodable { (response: AFDataResponse<FaqListResponse>) in
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
    
    static func qnaAtchUpload(request: QnAAtchUploadRequest, completion: @escaping (_ succeed: QnAAtchUploadResponse?, _ failed: MyError?) -> Void) {
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
        }, to: String("\(Global.BASE_URI)/bbs/qna/atch/upload"),
                           usingThreshold: UInt64.init(),
                           method: .post,
                           headers: header,
                           interceptor: myAuthencitationInterceptor)
        .validate()
        .responseDecodable(completionHandler: { (response: AFDataResponse<QnAAtchUploadResponse>) in
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
