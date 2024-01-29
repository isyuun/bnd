//
//  CmntRcmdtnRequest.swift
//  PetTip
//
//  Created by carebiz on 12/26/23.
//

import Foundation

/*
 {
 "cmntNo": 16,
 "rcmdtnSeCd": "001",
 "schUnqNo": 43
 }
 */

struct CmntRcmdtnRequest: Encodable {
    let cmntNo: Int
    let rcmdtnSeCd : String
    let schUnqNo : Int
}
