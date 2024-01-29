//
//  RealTimeListResponse.swift
//  PetTip
//
//  Created by carebiz on 12/12/23.
//

import Foundation

struct RealTimeListResponse: Codable {
    let data: [RealTimeListData]
    let statusCode: Int
    let resultMessage: String
    let detailMessage: JSONNull?
}

struct RealTimeListData: Codable {
    let schUnqNo: Int
    let schTTL, petNm, rcmdtnCnt, cmntCnt: String
    let storyFile: String?

    enum CodingKeys: String, CodingKey {
        case schUnqNo
        case schTTL = "schTtl"
        case petNm, rcmdtnCnt, cmntCnt, storyFile
    }
}

extension RealTimeListResponse {
    var toDomain: RealTimeList {
        return RealTimeList(items: data)
    }
}
