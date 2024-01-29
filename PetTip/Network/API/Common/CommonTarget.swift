//
//  CommonTarget.swift
//  PetTip
//
//  Created by carebiz on 12/29/23.
//

import Foundation
import Alamofire

enum CommonTarget {
    case codeList(CodeListRequest)
    case petList(CmmPetListRequest)
    case sggList(SggListRequest)
    case umdList(UmdListRequest)
}

extension CommonTarget: TargetType {

    var baseURL: String {
        return "http://carepet.hopto.org:8020/api/v1/cmm"
    }

    var method: HTTPMethod {
        switch self {
        case .codeList: return .post
        case .petList: return .post
        case .sggList: return .post
        case .umdList: return .post
        }
    }

    var path: String {
        switch self {
        case .codeList: return "/code-list"
        case .petList: return "/pet-list"
        case .sggList: return "/sgg-list"
        case .umdList: return "/umd-list"
        }
    }

    var parameters: RequestParams {
        switch self {
        case .codeList(let request): return .body(request)
        case .petList(let request): return .body(request)
        case .sggList(let request): return .body(request)
        case .umdList(let request): return .body(request)
        }
    }
}
