//
//  StoryListRequest.swift
//  PetTip
//
//  Created by carebiz on 12/18/23.
//

import Foundation

struct StoryListRequest: Encodable {
    let orderType: String
    let viewType: String
    let page: Int
    let pageSize: Int
    let recordSize: Int
}

//{
//  "orderType": "최신순 : 001, 인기순 : 002",
//  "page": 1,
//  "pageSize": 10,
//  "recordSize": 20,
//  "viewType": "전체 : 001, 내 스토리 : 002"
//}
