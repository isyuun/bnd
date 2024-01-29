//
//  CommonAPI.swift
//  PetTip
//
//  Created by carebiz on 12/29/23.
//

import Foundation
import Alamofire

struct CommonAPI {
    static func codeList(request: CodeListRequest, completion: @escaping (_ succeed: CodeList?, _ failed: MyError?) -> Void) {
        API.session.request(CommonTarget.codeList(request), interceptor: nil)
            .responseDecodable { (response: AFDataResponse<CodeListResponse>) in
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
    
    static func petList(request: CmmPetListRequest, completion: @escaping (_ succeed: CmmPetListResponse?, _ failed: MyError?) -> Void) {
        API.session.request(CommonTarget.petList(request), interceptor: nil)
            .responseDecodable { (response: AFDataResponse<CmmPetListResponse>) in
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
    
    static func sggList(request: SggListRequest, completion: @escaping (_ succeed: SggListResponse?, _ failed: MyError?) -> Void) {
        API.session.request(CommonTarget.sggList(request), interceptor: nil)
            .responseDecodable { (response: AFDataResponse<SggListResponse>) in
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
    
    static func umdList(request: UmdListRequest, completion: @escaping (_ succeed: UmdListResponse?, _ failed: MyError?) -> Void) {
        API.session.request(CommonTarget.umdList(request), interceptor: nil)
            .responseDecodable { (response: AFDataResponse<UmdListResponse>) in
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
}
