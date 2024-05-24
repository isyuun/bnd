//
//  MyPetDetailResponse.swift
//  PetTip
//
//  Created by carebiz on 1/27/24.
//

import Foundation

struct MyPetDetailResponse: Codable {
    let data: MyPetDetailData
    let statusCode: Int
    let detailMessage: String?
    let resultMessage: String
    let resHeaders: JSONNull?
}

// MARK: - MyPetDetailData
struct MyPetDetailData: Codable {
    let petRprsYn: String
    let petInfoUnqNo: Int
    let petKindNm: String
    let petRelUnqNo: Int
    let stdgUmdCD, stdgSggNm: String?
    let petBrthYmd, sexTypNm: String
    let ntrTypNm: String
    let petRelNm: String?
    let sexTypCD, petMngrYn, ownrPetUnqNo, ntrTypCD: String
    let petRelCD: String
    let memberList: [MemberList]
    let stdgSggCD: String?
    let petRprsImgAddr: String?
    let petTypCd, petRegNo: String
    let stdgCtpvCD, stdgCtpvNm: String?
    let stdgUmdNm: String?
    let petNm: String
    let wghtVl: Double
    let mngrType, endDt: String?

    enum CodingKeys: String, CodingKey {
        case petRprsYn, petInfoUnqNo, petKindNm, petRelUnqNo
        case stdgUmdCD = "stdgUmdCd"
        case stdgSggNm, petBrthYmd, sexTypNm, ntrTypNm, petRelNm
        case sexTypCD = "sexTypCd"
        case petMngrYn, ownrPetUnqNo
        case ntrTypCD = "ntrTypCd"
        case petRelCD = "petRelCd"
        case memberList
        case stdgSggCD = "stdgSggCd"
        case petRprsImgAddr
        case petTypCd = "petTypCd"
        case petRegNo
        case stdgCtpvCD = "stdgCtpvCd"
        case stdgCtpvNm, stdgUmdNm, petNm, wghtVl, mngrType, endDt
    }
}

// MARK: - MemberList
struct MemberList: Codable {
    let petRelUnqNo: Int
    let ownrPetUnqNo, endDt, userID, mngrType: String
    let nckNm: String

    enum CodingKeys: String, CodingKey {
        case petRelUnqNo, ownrPetUnqNo, endDt
        case userID = "userId"
        case mngrType, nckNm
    }
}
