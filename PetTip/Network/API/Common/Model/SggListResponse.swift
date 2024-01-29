//
//  SggListResponse.swift
//  PetTip
//
//  Created by carebiz on 1/7/24.
//

import Foundation

struct SggListResponse: Codable {
    let data: [SggListData]
    let statusCode: Int
    let detailMessage, resultMessage, resHeaders: String?
}

// MARK: - SggListData
struct SggListData: Codable {
    let sggCD, sggNm: String

    enum CodingKeys: String, CodingKey {
        case sggCD = "sggCd"
        case sggNm
    }
}
