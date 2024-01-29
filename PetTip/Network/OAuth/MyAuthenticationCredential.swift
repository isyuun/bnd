//
//  MyAuthenticationCredential.swift
//  PetTip
//
//  Created by carebiz on 12/10/23.
//

import Foundation
import Alamofire

struct MyAuthenticationCredential: AuthenticationCredential {
    let accessToken: String
    let refreshToken: String

    var requiresRefresh: Bool = false
}
