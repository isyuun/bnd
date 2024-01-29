//
//  EventListResponse.swift
//  PetTip
//
//  Created by carebiz on 12/30/23.
//

import Foundation

struct EventListResponse: Codable {
    let data: EventListData
    let statusCode: Int
    let resultMessage: String
    let detailMessage: JSONNull?
}

// MARK: - DataClass
struct EventListData: Codable {
    let bbsEvntList: [BBSEvntList]
    let paginate: Paginate?
}

// MARK: - BBSEvntList
struct BBSEvntList: Codable {
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

extension EventListResponse {
    var toDomain: EventList {
        return EventList(eventListData: data)
    }
}
