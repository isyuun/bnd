//
//  DclrCreateRequest.swift
//  PetTip
//
//  Created by carebiz on 12/29/23.
//

import Foundation

/*
{
  "cmntNo": 12,
  "dclrCn": "String",
  "dclrRsnCd": "001",
  "dclrSeCd": "001",
  "schUnqNo": 33
}
*/
 
struct DclrCreateRequest: Encodable {
    let cmntNo : Int
    let dclrCn : String
    let dclrRsnCd : String
    let dclrSeCd : String
    let schUnqNo : Int
}
