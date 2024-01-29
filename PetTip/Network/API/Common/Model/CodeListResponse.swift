//
//  CodeListResponse.swift
//  PetTip
//
//  Created by carebiz on 12/29/23.
//

import Foundation

struct CodeListResponse: Codable {
    let data: [CodeListData]
    let statusCode: Int
    let resultMessage, detailMessage: JSONNull?
}

// MARK: - Datum
struct CodeListData: Codable {
    let cdID: String
    let cdNm: String
    let cdDetailList: [CDDetailList]

    enum CodingKeys: String, CodingKey {
        case cdID = "cdId"
        case cdNm, cdDetailList
    }
}

// MARK: - CDDetailList
struct CDDetailList: Codable {
    let cdID: String
    let upCDID: String
    let cdNm: String

    enum CodingKeys: String, CodingKey {
        case cdID = "cdId"
        case upCDID = "upCdId"
        case cdNm
    }
}

extension CodeListResponse {
    var toDomain: CodeList {
        return CodeList(data: data)
    }
}

