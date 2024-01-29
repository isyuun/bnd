//
//  QnAListResponse.swift
//  PetTip
//
//  Created by carebiz on 1/11/24.
//

import Foundation

struct QnAListResponse: Codable {
    let data: QnAListData
    let statusCode: Int
    let detailMessage: String?
    let resultMessage: String
    let resHeaders: String?
}

// MARK: - QnAListData
struct QnAListData: Codable {
    let paginate: Paginate
    let bbsQnaList: [BBSQnaList]
}

// MARK: - BBSQnaList
struct BBSQnaList: Codable {
    let pstSn: Int
    let pstTTL: String
    let pstAnw: Int

    enum CodingKeys: String, CodingKey {
        case pstSn
        case pstTTL = "pstTtl"
        case pstAnw
    }
}
