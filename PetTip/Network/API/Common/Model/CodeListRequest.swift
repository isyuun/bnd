//
//  CodeListRequest.swift
//  PetTip
//
//  Created by carebiz on 12/29/23.
//

import Foundation

/*
{
  "cmmCdData": [
    "RSN",
    "SCD",
    "REL"
  ]
}
*/
 
struct CodeListRequest: Encodable {
    let cmmCdData: [String]
}
