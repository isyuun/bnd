//
//  QnAUpdateResponse.swift
//  PetTip
//
//  Created by carebiz on 1/13/24.
//

import Foundation

struct QnAUpdateResponse: Codable {
    let data: [QnAUpdateData]
    let statusCode: Int
    let detailMessage: String?
    let resultMessage: String
    let resHeaders: String?
}

// MARK: - QnAUpdateData
struct QnAUpdateData: Codable {
    let pstTTL, pstSECD, frstInptDt: String
    let atchPath: String
    let pstCN: String
    let pstSn: Int
    let pstType: String
    let files: [File]

    enum CodingKeys: String, CodingKey {
        case pstTTL = "pstTtl"
        case pstSECD = "pstSeCd"
        case frstInptDt, atchPath
        case pstCN = "pstCn"
        case pstSn, pstType, files
    }
}
