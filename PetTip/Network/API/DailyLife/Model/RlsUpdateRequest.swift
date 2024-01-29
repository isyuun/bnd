//
//  RlsUpdateRequest.swift
//  PetTip
//
//  Created by carebiz on 12/29/23.
//

import Foundation

/*
{
  "rlsYn": "Y or N",
  "schUnqNo": 26
}
*/
 
struct RlsUpdateRequest: Encodable {
    let rlsYn: String
    let schUnqNo: Int
}
