//
//  ResetPassword.swift
//  PetTip
//
//  Created by carebiz on 1/3/24.
//

import Foundation

/*
{
  "email": "aaa@bbb.com",
  "userPW": "1234"
}
*/

struct ResetPasswordRequest: Encodable {
    let email: String
    let userPW: String
}
