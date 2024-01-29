//
//  MyPetWeightUpdateRequest.swift
//  PetTip
//
//  Created by carebiz on 1/27/24.
//

import Foundation

/*
{
  "crtrYmd": 20230825,
  "petDtlUnqNo": "Integer",
  "wghtVl": 5.9
}
*/

struct MyPetWeightUpdateRequest: Encodable {
    let crtrYmd: String
    let petDtlUnqNo: Int
    let wghtVl: String
}
