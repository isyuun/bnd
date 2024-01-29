//
//  MyPetRelCloseRequest.swift
//  PetTip
//
//  Created by carebiz on 1/28/24.
//

import Foundation

/*
{
  "ownrPetUnqNo": "P20230808000027",
  "petRelUnqNo": 245
}
*/
 
struct MyPetRelCloseRequest: Encodable {
    let ownrPetUnqNo: String
    let petRelUnqNo: Int
}
