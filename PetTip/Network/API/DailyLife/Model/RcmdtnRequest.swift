//
//  RcmdtnRequest.swift
//  PetTip
//
//  Created by carebiz on 12/26/23.
//

import Foundation

/*
{
  "rcmdtnSeCd": "001",
  "schUnqNo": 26
}
*/

struct RcmdtnRequest: Encodable {
    let rcmdtnSeCd : String
    let schUnqNo : Int
}

