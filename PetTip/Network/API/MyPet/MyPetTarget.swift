//
//  MyPetTarget.swift
//  PetTip
//
//  Created by carebiz on 12/10/23.
//

import Foundation
import Alamofire

enum MyPetTarget {
    case delete(MyPetDeleteRequest)
    case list(MyPetListRequest)
    case detail(MyPetDetailRequest)
    case invttCreate(MyPetInvttCreateRequest)
    case invttSetKey(MyPetInvttSetKeyRequest)
    case weightCreate(MyPetWeightCreateRequest)
    case weightDelete(MyPetWeightDeleteRequest)
    case weightList(MyPetWeightListRequest)
    case weightUpdate(MyPetWeightUpdateRequest)
    case relClose(MyPetRelCloseRequest)
}

extension MyPetTarget: TargetType {

    var baseURL: String {
        return String("\(Global.BASE_URI)/mypet")
    }

    var method: HTTPMethod {
        switch self {
        case .delete: return .post
        case .list: return .post
        case .detail: return .post
        case .invttCreate: return .post
        case .invttSetKey: return .post
        case .weightCreate: return .post
        case .weightDelete: return .post
        case .weightList: return .post
        case .weightUpdate: return .post
        case .relClose: return .post
        }
    }

    var path: String {
        switch self {
        case .delete: return "/delete"
        case .list: return "/list"
        case .detail: return "/detail"
        case .invttCreate: return "/invtt/create"
        case .invttSetKey: return "/invtt/setKey"
        case .weightCreate: return "/wght/create"
        case .weightDelete: return "/wght/delete"
        case .weightList: return "/wght/list"
        case .weightUpdate: return "/wght/update"
        case .relClose: return "/rel-close"
        }
    }

    var parameters: RequestParams {
        switch self {
        case .delete(let request): return .body(request)
        case .list(let request): return .body(request)
        case .detail(let request): return .body(request)
        case .invttCreate(let request): return .body(request)
        case .invttSetKey(let request): return .body(request)
        case .weightCreate(let request): return .body(request)
        case .weightDelete(let request): return .body(request)
        case .weightList(let request): return .body(request)
        case .weightUpdate(let request): return .body(request)
        case .relClose(let request): return .body(request)
        }
    }

}
