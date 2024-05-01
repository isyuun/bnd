//
//  WinnerListResponse.swift
//  PetTip
//
//  Created by carebiz on 12/30/23.
//

import Foundation

struct WinnerListResponse: Codable {
    let data: WinnerListData
    let statusCode: Int
    let resultMessage: String
    let detailMessage: JSONNull?
}

// MARK: - WinnerListData
struct WinnerListData: Codable {
    let bbsWinnerList: [BBSWinnerList]
    let paginate: Paginate?
}

// MARK: - BBSWinnerList
struct BBSWinnerList: Codable {
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
