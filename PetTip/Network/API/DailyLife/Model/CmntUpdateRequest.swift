//
//  CmntUpdateRequest.swift
//  PetTip
//
//  Created by carebiz on 12/28/23.
//

import Foundation

/*
{
  "cmntCn": "댓글내용",
  "cmntNo": 4
}
*/

struct CmntUpdateRequest: Encodable {
    let cmntCn : String
    let cmntNo : Int
}
