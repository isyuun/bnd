//
//  QnADtlListResponse.swift
//  PetTip
//
//  Created by carebiz on 1/11/24.
//

import Foundation

struct QnADtlListResponse: Codable {
    let data: [QnADtlData]
    let statusCode: Int
    let detailMessage: String?
    let resultMessage: String
    let resHeaders: JSONNull?
}

// MARK: - QnADtlData
struct QnADtlData: Codable {
    let pstTTL, pstSECD, frstInptDt: String
    let atchPath: String
    let pstCN: String
    let pstSn: Int
    let pstType: String
    let files: [File]?

    enum CodingKeys: String, CodingKey {
        case pstTTL = "pstTtl"
        case pstSECD = "pstSeCd"
        case frstInptDt, atchPath
        case pstCN = "pstCn"
        case pstSn, pstType, files
    }
}

// MARK: - File
struct File: Codable {
    let filePathNm, pstRprsYn, orgnlAtchFileNm, atchFileNm: String
    let atchFileSn, pstSn, atchFileSz: Int
    let fileExtnNm: String
}

