//
//  NoticeListResponse.swift
//  PetTip
//
//  Created by carebiz on 1/10/24.
//

import Foundation

struct NoticeListResponse: Codable {
    let data: NoticeListData
    let statusCode: Int
    let resultMessage: String
    let detailMessage, resHeaders: JSONNull?
}

// MARK: - NoticeListData
struct NoticeListData: Codable {
    let bbsNtcList: [BBSNtcList]
    let paginate: Paginate
}

// MARK: - BBSNtcList
struct BBSNtcList: Codable {
    let pstSn: Int
    let pstTTL, pstgBgngDt: String

    enum CodingKeys: String, CodingKey {
        case pstSn
        case pstTTL = "pstTtl"
        case pstgBgngDt
    }
}
