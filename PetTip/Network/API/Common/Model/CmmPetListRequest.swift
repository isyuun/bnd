//
//  PetListRequest.swift
//  PetTip
//
//  Created by carebiz on 1/6/24.
//

import Foundation

/*
{
  "petDogSzCd": "",
  "petTypCd": "001"
}
*/
 
struct CmmPetListRequest: Encodable {
    let petDogSzCd: String
    let petTypCd: String
}
