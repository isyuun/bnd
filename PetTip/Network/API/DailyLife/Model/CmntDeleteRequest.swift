//
//  CmntDeleteRequest.swift
//  PetTip
//
//  Created by carebiz on 12/27/23.
//

import Foundation

/*
{
  "cmntNo": 4
}
*/

struct CmntDeleteRequest: Encodable {
    let cmntNo : Int
}
