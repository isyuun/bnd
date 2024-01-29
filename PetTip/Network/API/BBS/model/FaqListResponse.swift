//
//  FaqListResponse.swift
//  PetTip
//
//  Created by carebiz on 1/10/24.
//

import Foundation

struct FaqListResponse: Codable {
    let data: FaqListData
    let statusCode: Int
    let resultMessage: String
    let detailMessage, resHeaders: String?
}

// MARK: - FaqListData
struct FaqListData: Codable {
    let bbsFAQList: [BBSFAQList]
    let paginate: Paginate

    enum CodingKeys: String, CodingKey {
        case bbsFAQList = "bbsFaqList"
        case paginate
    }
}

// MARK: - BBSFAQList
struct BBSFAQList: Codable {
    let pstSn: Int
    let pstTTL, pstCN: String

    enum CodingKeys: String, CodingKey {
        case pstSn
        case pstTTL = "pstTtl"
        case pstCN = "pstCn"
    }
}

