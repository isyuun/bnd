//
//  TrmnlMngRequest.swift
//  PetTip
//
//  Created by carebiz on 2/15/24.
//

import Foundation

/*
{
  "appKey": "string",
  "appOs": "001",
  "appTypNm": "SM-T975N"
}
*/
 
struct TrmnlMngRequest: Encodable {
    let appKey: String  // PUSH KEY
    let appOs: String   // 앱OS(001:AOS,002:IOS)
    let appTypNm: String
}
