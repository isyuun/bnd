//
//  LifeViewResponse.swift
//  PetTip
//
//  Created by carebiz on 12/15/23.
//

import Foundation

struct LifeViewResponse: Codable {
    let data: LifeViewData
    let statusCode: Int
    let resultMessage: String
    let detailMessage: JSONNull?
}

// MARK: - DataClass
struct LifeViewData: Codable {
    let schUnqNo: Int
    let userID, schTTL: String
    let schCN: String?
    let rlsYn: String
    let rlsDt: String?
    let cmntUseYn: String
    let cmntCnt: Int
    let rcmdtnYn: String
    let rcmdtnCnt, nrcmdtnCnt: Int
    let myRcmdtn: String?
    let rgtrIPAddr: JSONNull?
    let delYn: String
    let walkDptreDt: String?
    let walkEndDt: String?
    let totDstnc, totCLR: Int
    let totMvmnPathFile: String?
    let totMvmnPathFileSn: String?
    let dailyLifePetList: [DailyLifePetList]?
    let dailyLifeSchSEList: [DailyLifeSchSEList]
    let dailyLifeFileList: [DailyLifeFileList]?
    let dailyLifeSchHashTagList: [DailyLifeSchHashTagList]?
    let cmntList: [CmntList]?
    let atchPath: String
    let runTime: String?
    let runDstnc, runCLR: Int
    let runNcknm: String

    enum CodingKeys: String, CodingKey {
        case schUnqNo
        case userID = "userId"
        case schTTL = "schTtl"
        case schCN = "schCn"
        case rlsYn, rlsDt, cmntUseYn, cmntCnt, rcmdtnYn, rcmdtnCnt, nrcmdtnCnt, myRcmdtn
        case rgtrIPAddr = "rgtrIpAddr"
        case delYn, walkDptreDt, walkEndDt, totDstnc
        case totCLR = "totClr"
        case totMvmnPathFile, totMvmnPathFileSn, dailyLifePetList
        case dailyLifeSchSEList = "dailyLifeSchSeList"
        case dailyLifeFileList, dailyLifeSchHashTagList, cmntList, atchPath, runTime, runDstnc
        case runCLR = "runClr"
        case runNcknm
    }
}

// MARK: - DailyLifeSchHashTagList
struct DailyLifeSchHashTagList: Codable {
    let rowState: String?
    let hashTagNo, schUnqNo: Int
    let hashTagNm: String
}

// MARK: - DailyLifeFileList
struct DailyLifeFileList: Codable {
    let orgnlAtchFileNm, atchFileNm: String
    let atchFileSz: Int
    let fileExtnNm, filePathNm: String
    let flmPstnLat, flmPstnLot: String?
    let schUnqNo: Int?
    let rowState: String?
    let atchFileSn: String?
}

// MARK: - DailyLifePetList
struct DailyLifePetList: Codable {
    let ownrPetUnqNo, petNm: String
    let bwlMvmNmtm, urineNmtm, relmIndctNmtm: Int?
    let stdgUmdNm, age: String?
    let schUnqNo: Int?
    let petImg: String?
    let rowState: String?
}

// MARK: - DailyLifeSchSEList
struct DailyLifeSchSEList: Codable {
    let cdID, cdNm: String
    let schUnqNo: Int
    let rowState: String?

    enum CodingKeys: String, CodingKey {
        case cdID = "cdId"
        case cdNm, schUnqNo, rowState
    }
}

// MARK: - CmntList
struct CmntList: Codable {
    let upCmntNo, cmntNo, schUnqNo, petRelUnqNo: Int
    let lastStrgDt: String
    let stepLevel: Int
    let userID, cmntCN: String
    let rcmdtnCnt, nrcmdtnCnt: Int
    let bldYn, delYn: String
    let petImg: String?
    let petNm: String?
    let stdgUmdNm: String?
    let myCmntRcmdtn: String?

    enum CodingKeys: String, CodingKey {
        case upCmntNo, cmntNo, schUnqNo, petRelUnqNo, lastStrgDt, stepLevel
        case userID = "userId"
        case cmntCN = "cmntCn"
        case rcmdtnCnt, nrcmdtnCnt, bldYn, delYn, petImg, petNm, stdgUmdNm, myCmntRcmdtn
    }
}

extension LifeViewResponse {
    var toDomain: LifeView {
        return LifeView(lifeViewData: data)
    }
}
