//
//  MyPetDeleteRequest.swift
//  PetTip
//
//  Created by carebiz on 1/28/24.
//

import Foundation

/*
{
  "delYn": "Y",
  "ownrPetUnqNo": "P20230808000027"
}
*/
 
struct MyPetDeleteRequest: Encodable {
    let delYn: String
    let ownrPetUnqNo: String
}
