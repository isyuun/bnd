//
//  StoryAPI.swift
//  PetTip
//
//  Created by carebiz on 12/12/23.
//

import Foundation
import Alamofire

struct StoryAPI {
    static func realTimeList(request: RealTimeListRequest, completion: @escaping (_ succeed: RealTimeList?, _ failed: Error?) -> Void) {
        API.session.request(StoryTarget.realTimeList(request), interceptor: nil)
            .responseDecodable { (response: AFDataResponse<RealTimeListResponse>) in
                switch response.result {
                case .success(let response):
                    completion(response.toDomain, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
    
    static func list(request: StoryListRequest, completion: @escaping (_ succeed: StoryList?, _ failed: MyError?) -> Void) {
        if UserDefaults.standard.value(forKey: "accessToken") == nil
            || UserDefaults.standard.value(forKey: "refreshToken") == nil  {
            return
        }
        
        let authenticator = MyAuthenticator()
        let credential = MyAuthenticationCredential(accessToken: UserDefaults.standard.value(forKey: "accessToken") as! String,
                                                    refreshToken: UserDefaults.standard.value(forKey: "refreshToken") as! String)
        let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator,
                                                                        credential: credential)
        
        API.session.request(StoryTarget.list(request), interceptor: myAuthencitationInterceptor)
            .responseDecodable { (response: AFDataResponse<StoryListResponse>) in
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
}
