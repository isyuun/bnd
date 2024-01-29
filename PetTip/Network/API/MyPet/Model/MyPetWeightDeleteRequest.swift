//
//  MyPetWeightDeleteRequest.swift
//  PetTip
//
//  Created by carebiz on 1/27/24.
//

import Foundation

/*
{
  "petDtlUnqNo": "Integer"
}
*/
 
struct MyPetWeightDeleteRequest: Encodable {
    let petDtlUnqNo: Int
}
