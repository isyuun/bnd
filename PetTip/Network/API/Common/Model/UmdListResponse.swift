//
//  UmdListResponse.swift
//  PetTip
//
//  Created by carebiz on 1/7/24.
//

import Foundation

struct UmdListResponse: Codable {
    let data: [UmdListData]
    let statusCode: Int
    let detailMessage, resultMessage, resHeaders: String?
}

// MARK: - UmdListData
struct UmdListData: Codable {
    let umdCD, umdNm: String

    enum CodingKeys: String, CodingKey {
        case umdCD = "umdCd"
        case umdNm
    }
}
