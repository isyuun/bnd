//
//  WeatherTarget.swift
//  PetTip
//
//  Created by carebiz on 12/12/23.
//

import Foundation
import Alamofire

enum WeatherTarget {
    case weather(WeatherRequest)
}

extension WeatherTarget: TargetType {

    var baseURL: String {
        return "http://carepet.hopto.org:8020/api/v1/weather"
    }

    var method: HTTPMethod {
        switch self {
        case .weather: return .post
        }
    }

    var path: String {
        switch self {
        case .weather: return ""
        }
    }

    var parameters: RequestParams {
        switch self {
        case .weather(let request): return .body(request)
        }
    }
}
