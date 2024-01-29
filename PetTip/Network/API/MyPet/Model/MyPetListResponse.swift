//
//  MyPeyListResponse.swift
//  PetTip
//
//  Created by carebiz on 12/10/23.
//

import Foundation

struct MyPetListResponse: Codable {
    let data: [MyPet]
    let statusCode: Int
    let resultMessage: String
    let detailMessage: JSONNull?
}

struct MyPet: Codable {
    let ownrPetUnqNo, petNm, petKindNm, petBrthYmd: String
    let petRelUnqNo, petInfoUnqNo: Int
    let stdgCtpvCD, stdgCtpvNm, stdgSggCD, stdgSggNm: String
    let stdgUmdCD: String
    let stdgUmdNm: String?
    let petRelCD: String
    let petRelNm: String?
    let petRprsYn, petMngrYn, sexTypCD, sexTypNm: String
    let ntrTypCD, ntrTypNm, petRegNo: String
    let wghtVl: Double
    let mngrType, endDt: String
    let petRprsImgAddr: String?

    enum CodingKeys: String, CodingKey {
        case ownrPetUnqNo, petNm, petKindNm, petBrthYmd, petRelUnqNo, petInfoUnqNo
        case stdgCtpvCD = "stdgCtpvCd"
        case stdgCtpvNm
        case stdgSggCD = "stdgSggCd"
        case stdgSggNm
        case stdgUmdCD = "stdgUmdCd"
        case stdgUmdNm
        case petRelCD = "petRelCd"
        case petRelNm, petRprsYn, petMngrYn
        case sexTypCD = "sexTypCd"
        case sexTypNm
        case ntrTypCD = "ntrTypCd"
        case ntrTypNm, petRegNo, wghtVl, mngrType, endDt, petRprsImgAddr
    }
}

extension MyPetListResponse {
    var toDomain: MyPetList {
        return MyPetList(myPets: data)
    }
}
