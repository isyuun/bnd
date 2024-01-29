//
//  AncmntWinnerListRequest.swift
//  PetTip
//
//  Created by carebiz on 12/30/23.
//

import Foundation

/*
{
  "bbsSn": 11,
  "page": 1,
  "pageSize": 10,
  "recordSize": 20
}
*/

struct AncmntWinnerListRequest: Encodable {
    let bbsSn: Int = 11
    let page: Int
    let pageSize: Int
    let recordSize: Int
}
