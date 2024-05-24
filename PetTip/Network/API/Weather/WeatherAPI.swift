//
//  WeatherAPI.swift
//  PetTip
//
//  Created by carebiz on 12/12/23.
//

import Foundation
import Alamofire

struct WeatherAPI {
    // static func weather(request: WeatherRequest, completion: @escaping (_ succeed: Weather?, _ failed: Error?) -> Void) {
    //     API.session.request(WeatherTarget.weather(request), interceptor: nil)
    //         .responseDecodable { (response: AFDataResponse<WeatherResponse>) in
    //         switch response.result {
    //         case .success(let response):
    //             completion(response.toDomain, nil)
    //         case .failure(let error):
    //             completion(nil, error)
    //         }
    //     }
    // }
    static func weather(request: WeatherRequest, completion: @escaping (_ succeed: Weather?, _ failed: MyError?) -> Void) {
        API.session.request(WeatherTarget.weather(request), interceptor: nil)
            .responseDecodable { (response: AFDataResponse<WeatherResponse>) in
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
}
