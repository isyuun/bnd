//
//  StoryTarget.swift
//  PetTip
//
//  Created by carebiz on 12/12/23.
//

import Foundation
import Alamofire

enum StoryTarget {
    case realTimeList(RealTimeListRequest)
    case list(StoryListRequest)
}

extension StoryTarget: TargetType {

    var baseURL: String {
        return String("\(Global.BASE_URI)/story")
    }

    var method: HTTPMethod {
        switch self {
        case .realTimeList: return .post
        case .list: return .post
        }
    }

    var path: String {
        switch self {
        case .realTimeList: return "/real-time-list"
        case .list: return "/list"
        }
    }

    var parameters: RequestParams {
        switch self {
        case .realTimeList(let request): return .body(request)
        case .list(let request): return .body(request)
        }
    }
}
