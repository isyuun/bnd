//
//  NoticeListRequest.swift
//  PetTip
//
//  Created by carebiz on 1/10/24.
//

import Foundation

/*
{
  "bbsSn": 7,
  "page": 1,
  "pageSize": 10,
  "recordSize": 20
}
*/

struct NoticeListRequest: Encodable {
    let bbsSn: Int
    let page: Int
    let pageSize: Int
    let recordSize: Int
}
