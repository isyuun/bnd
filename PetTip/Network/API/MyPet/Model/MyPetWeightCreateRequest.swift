//
//  MyPetWeightCreate.swift
//  PetTip
//
//  Created by carebiz on 1/27/24.
//

import Foundation

/*
{
  "crtrYmd": 20230825,
  "ownrPetUnqNo": "P20230808000027",
  "wghtVl": 5.9
}
*/

struct MyPetWeightCreateRequest: Encodable {
    let crtrYmd: String
    let ownrPetUnqNo: String
    let wghtVl: String
}
