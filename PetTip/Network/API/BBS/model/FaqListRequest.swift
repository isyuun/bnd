//
//  FaqListRequest.swift
//  PetTip
//
//  Created by carebiz on 1/10/24.
//

import Foundation

struct FaqListRequest: Encodable {
    let bbsSn: Int
    let page: Int
    let pageSize: Int
    let recordSize: Int
}
