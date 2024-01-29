//
//  LifeCreateResponse.swift
//  PetTip
//
//  Created by carebiz on 1/18/24.
//

import Foundation

struct LifeCreateResponse: Codable {
    let data: LifeCreateData
    let statusCode: Int
    let detailMessage: String?
    let resultMessage: String
    let resHeaders: String?
}

// MARK: - LifeCreateData
struct LifeCreateData: Codable {
    let schUnqNo: String
}
