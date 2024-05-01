//
//  WinnerDtlListResponse.swift
//  PetTip
//
//  Created by carebiz on 12/31/23.
//

import Foundation

struct WinnerDtlListResponse: Codable {
    let data: WinnerDtlListData
    let statusCode: Int
    let resultMessage: String
    let detailMessage: JSONNull?
}

// MARK: - DataClass
struct WinnerDtlListData: Codable {
    let pstSn: Int
    let userID: JSONNull?
    let bbsSn, upPstNo: Int
    let pstSECD: JSONNull?
    let relPstSn: Int
    let pblrNm: JSONNull?
    let pstTTL, pstCN: String
    let pstgBgngDt: String?
    let pstgEndDt: String?
    let pstgYn, bldYn: JSONNull?
    let inqCnt, cmntCnt, rcmdtnCnt, nrcmdtnCnt: Int
    let frstKbrdrID, frstInptDt, lastMdfrID, lastStrgDt: JSONNull?
    let pstType, rcmdtnSECD: JSONNull?
    let rprsImgURL: String
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

