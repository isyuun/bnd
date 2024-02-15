//
//  MemberTarget.swift
//  PetTip
//
//  Created by carebiz on 12/10/23.
//

import Foundation
import Alamofire

enum MemberTarget {
    case chkNcknm(ChkNcknmRequest)
    case createUser(CreateUserRequest)
    case logout(LogoutRequest)
    case login(LoginRequest)
    case refreshToken(RefreshTokenRequest)
    case resetNcknm(ResetNcknmRequest)
    case resetPassword(ResetPasswordRequest)
    case withdraw(WithdrawRequest)
    case trmnlMng(TrmnlMngRequest)
}

extension MemberTarget: TargetType {
    
    var baseURL: String {
        return String("\(Global.BASE_URI)/member")
    }

    var method: HTTPMethod {
        switch self {
        case .chkNcknm: return .post
        case .createUser: return .post
        case .logout: return .post
        case .login: return .post
        case .refreshToken: return .post
        case .resetNcknm: return .post
        case .resetPassword: return .post
        case .withdraw: return .post
        case .trmnlMng: return .post
        }
    }

    var path: String {
        switch self {
        case .chkNcknm: return "/chk-ncknm"
        case .createUser: return "/create-user"
        case .logout: return "/logOut"
        case .login: return "/login"
        case .refreshToken: return "/refresh-token"
        case .resetNcknm: return "/reset-ncknm"
        case .resetPassword: return "/reset-password"
        case .withdraw: return "/withdraw"
        case .trmnlMng: return "/trmnlMng"
        }
    }

    var parameters: RequestParams {
        switch self {
        case .chkNcknm(let request): return .body(request)
        case .createUser(let request): return .body(request)
        case .logout(let request): return .body(request)
        case .login(let request): return .body(request)
        case .refreshToken(let request): return .body(request)
        case .resetNcknm(let request): return .body(request)
        case .resetPassword(let request): return .body(request)
        case .withdraw(let request): return .body(request)
        case .trmnlMng(let request): return .body(request)
        }
    }
}
