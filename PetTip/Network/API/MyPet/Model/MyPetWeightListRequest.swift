//
//  MyPetWeightListRequest.swift
//  PetTip
//
//  Created by carebiz on 1/27/24.
//

import Foundation

/*
{
  "ownrPetUnqNo": "P20240118000189"
}
*/
 
struct MyPetWeightListRequest: Encodable {
    let ownrPetUnqNo: String
}
