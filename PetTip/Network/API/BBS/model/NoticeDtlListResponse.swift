//
//  NoticeDtlListResponse.swift
//  PetTip
//
//  Created by carebiz on 1/10/24.
//

import Foundation

struct NoticeDtlListResponse: Codable {
    let data: NoticeDtlListData
    let statusCode: Int
    let resultMessage: String
    let detailMessage, resHeaders: JSONNull?
}

// MARK: - NoticeDtlListData
struct NoticeDtlListData: Codable {
    let pstSn: Int
    let userID: String?
    let bbsSn, upPstNo: Int
    let pstSECD: String?
    let relPstSn: Int
    let pblrNm: String?
    let pstTTL, pstCN, pstgBgngDt: String
    let pstgEndDt, pstgYn, bldYn: String?
    let inqCnt, cmntCnt, rcmdtnCnt, nrcmdtnCnt: Int
    let frstKbrdrID, frstInptDt, lastMdfrID, lastStrgDt: String?
    let pstType, rcmdtnSECD, rprsImgURL: String?
    let bbsCmnts: [JSONAny]
    let bbsAtch: [BBSAtch]

    enum CodingKeys: String, CodingKey {
        case pstSn
        case userID = "userId"
        case bbsSn, upPstNo
        case pstSECD = "pstSeCd"
        case relPstSn, pblrNm
        case pstTTL = "pstTtl"
        case pstCN = "pstCn"
        case pstgBgngDt, pstgEndDt, pstgYn, bldYn, inqCnt, cmntCnt, rcmdtnCnt, nrcmdtnCnt
        case frstKbrdrID = "frstKbrdrId"
        case frstInptDt
        case lastMdfrID = "lastMdfrId"
        case lastStrgDt, pstType
        case rcmdtnSECD = "rcmdtnSeCd"
        case rprsImgURL = "rprsImgUrl"
        case bbsCmnts, bbsAtch
    }
}

