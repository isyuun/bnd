//
//  CmntCreateRequest.swift
//  PetTip
//
//  Created by carebiz on 12/24/23.
//

import Foundation

struct CmntCreateRequest: Encodable {
    let cmntCn: String
    let petRelUnqNo : Int
    let schUnqNo : Int
    let upCmntNo : Int
}
