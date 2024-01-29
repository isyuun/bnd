//
//  MyPetUpdateResponse.swift
//  PetTip
//
//  Created by carebiz on 1/28/24.
//

import Foundation

struct MyPetUpdateResponse: Codable {
    let data: MyPetUpdateData
    let statusCode: Int
    let detailMessage: String?
    let resultMessage: String
    let resHeaders: JSONNull?
}

// MARK: - MyPetUpdateData
struct MyPetUpdateData: Codable {
    let petRprsYn: String
    let petInfoUnqNo: Int
    let petKindNm: String
    let petRelUnqNo: Int
    let stdgUmdCD, stdgSggNm, petBrthYmd, sexTypNm: String
    let ntrTypNm: String
    let petRelNm: String?
    let sexTypCD, petMngrYn, ownrPetUnqNo, ntrTypCD: String
    let petRelCD, stdgSggCD, petRprsImgAddr, petTypCD: String
    let petRegNo, stdgCtpvCD, stdgCtpvNm, stdgUmdNm: String
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
        case stdgSggCD = "stdgSggCd"
        case petRprsImgAddr
        case petTypCD = "petTypCd"
        case petRegNo
        case stdgCtpvCD = "stdgCtpvCd"
        case stdgCtpvNm, stdgUmdNm, petNm, wghtVl, mngrType, endDt
    }
}
