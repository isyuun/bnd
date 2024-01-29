//
//  QnAListRequest.swift
//  PetTip
//
//  Created by carebiz on 1/11/24.
//

import Foundation

struct QnAListRequest: Encodable {
    let bbsSn: Int
    let page: Int
    let pageSize: Int
    let recordSize: Int
}
