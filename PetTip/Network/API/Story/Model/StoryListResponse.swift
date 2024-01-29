//
//  StoryListResponse.swift
//  PetTip
//
//  Created by carebiz on 12/18/23.
//

import Foundation

struct StoryListResponse: Codable {
    let data: StoryListData
    let statusCode: Int
    let resultMessage: String
    let detailMessage: JSONNull?
}

// MARK: - DataClass
struct StoryListData: Codable {
    let storyList: [StoryListObj]?
    let paginate: Paginate?
}

// MARK: - Paginate
struct Paginate: Codable {
    let totalRecordCount, totalPageCount, startPage, endPage: Int
    let existPrevPage, existNextPage: Bool
}

// MARK: - StoryList
struct StoryListObj: Codable {
    let schUnqNo: Int
    let schTTL, inptDt, petNm, rcmdtnCnt: String
    let cmntCnt: String
    let storyFile: String?
    let bldYn: String?

    enum CodingKeys: String, CodingKey {
        case schUnqNo
        case schTTL = "schTtl"
        case inptDt, petNm, rcmdtnCnt, cmntCnt, storyFile, bldYn
    }
}

extension StoryListResponse {
    var toDomain: StoryList {
        return StoryList(storyListData: data)
    }
}
