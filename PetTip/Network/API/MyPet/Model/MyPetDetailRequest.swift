//
//  MyPetDetailRequest.swift
//  PetTip
//
//  Created by carebiz on 1/27/24.
//

import Foundation

/*
{
  "ownrPetUnqNo": "P20230808000027",
  "petRprsYn": "Y",
  "userId": "String"
}
*/

struct MyPetDetailRequest: Encodable {
    let ownrPetUnqNo: String
    let petRprsYn: String
    let userId: String
}

