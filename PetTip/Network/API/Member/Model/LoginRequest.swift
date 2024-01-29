//
//  LoginRequest.swift
//  PetTip
//
//  Created by carebiz on 12/10/23.
//

import Foundation

struct LoginRequest: Encodable {
    let appTypNm: String
    let userID: String
    let userPW: String
}
