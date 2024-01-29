//
//  AncmntWinnerListResponse.swift
//  PetTip
//
//  Created by carebiz on 12/30/23.
//

import Foundation

struct AncmntWinnerListResponse: Codable {
    let data: AncmntWinnerListData
    let statusCode: Int
    let resultMessage: String
    let detailMessage: JSONNull?
}

// MARK: - AncmntWinnerListData
struct AncmntWinnerListData: Codable {
    let bbsAncmntWinnerList: [BBSAncmntWinnerList]
    let paginate: Paginate?
}

// MARK: - BBSAncmntWinnerList
struct BBSAncmntWinnerList: Codable {
    let pstSn: Int
    let rprsImgURL: String
    let pstTTL: String
    let pstgBgngDt, pstgEndDt: String?

    enum CodingKeys: String, CodingKey {
        case pstSn
        case rprsImgURL = "rprsImgUrl"
        case pstTTL = "pstTtl"
        case pstgBgngDt, pstgEndDt
    }
}
