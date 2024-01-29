//
//  EventListRequest.swift
//  PetTip
//
//  Created by carebiz on 12/30/23.
//

import Foundation

/*
{
  "bbsSn": 9,
  "page": 1,
  "pageSize": 10,
  "recordSize": 20
}
*/

struct EventListRequest: Encodable {
    let bbsSn: Int = 9
    let page: Int
    let pageSize: Int
    let recordSize: Int
}
