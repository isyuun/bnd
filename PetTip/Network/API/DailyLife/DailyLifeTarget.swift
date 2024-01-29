//
//  DailyLifeTarget.swift
//  PetTip
//
//  Created by carebiz on 12/10/23.
//

import Foundation
import Alamofire

enum DailyLifeTarget {
    case cmntCreate(CmntCreateRequest)
    case cmntDelete(CmntDeleteRequest)
    case cmntRcmdtn(CmntRcmdtnRequest)
    case cmntUpdate(CmntUpdateRequest)
    case create(LifeCreateRequest)
    case dclrCreate(DclrCreateRequest)
    case petList(PetListRequest)
    case rcmdtn(RcmdtnRequest)
    case rlsUpdate(RlsUpdateRequest)
    case update(LifeUpdateRequest)
    case weekRecord(WeekRecordRequest)
    case monthRecord(MonthRecordRequest)
    case view(LifeViewRequest)
}

extension DailyLifeTarget: TargetType {

    var baseURL: String {
        return "http://carepet.hopto.org:8020/api/v1/daily-life"
    }

    var method: HTTPMethod {
        switch self {
        case .cmntCreate: return .post
        case .cmntDelete: return .post
        case .cmntRcmdtn: return .post
        case .cmntUpdate: return .post
        case .create: return .post
        case .dclrCreate: return .post
        case .petList: return .post
        case .rcmdtn: return .post
        case .rlsUpdate: return .post
        case .update: return .post
        case .weekRecord: return .post
        case .monthRecord: return .post
        case .view: return .post
        }
    }

    var path: String {
        switch self {
        case .cmntCreate: return "/cmnt/create"
        case .cmntDelete: return "/cmnt/delete"
        case .cmntRcmdtn: return "/cmnt/rcmdtn"
        case .cmntUpdate: return "/cmnt/update"
        case .create: return "/create"
        case .dclrCreate: return "/dclr/create"
        case .petList: return "/pet/list"
        case .rcmdtn: return "/rcmdtn"
        case .rlsUpdate: return "/rls/update"
        case .update: return "/update"
        case .weekRecord: return "/week/recode"
        case .monthRecord: return "/month/recode"
        case .view: return "/view"
        }
    }

    var parameters: RequestParams {
        switch self {
        case .cmntCreate(let request): return .body(request)
        case .cmntDelete(let request): return .body(request)
        case .cmntRcmdtn(let request): return .body(request)
        case .cmntUpdate(let request): return .body(request)
        case .create(let request): return .body(request)
        case .dclrCreate(let request): return .body(request)
        case .petList(let request): return .body(request)
        case .rcmdtn(let request): return .body(request)
        case .rlsUpdate(let request): return .body(request)
        case .update(let request): return .body(request)
        case .weekRecord(let request): return .body(request)
        case .monthRecord(let request): return .body(request)
        case .view(let request): return .body(request)
        }
    }
}
