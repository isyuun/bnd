//
//  DailyLifeResponse.swift
//  PetTip
//
//  Created by carebiz on 12/10/23.
//

import Foundation

struct PetListResponse: Codable {
    let data: [Pet]
    let statusCode: Int
    let resultMessage: String
    let detailMessage: JSONNull?
}

// MARK: - Datum
struct Pet: Codable {
    let ownrPetUnqNo, petNm: String
    let petRelUnqNo: Int
    let petRprsImgAddr: String?
    let age, petKindNm, sexTypNm: String
    let wghtVl: Double
}

extension PetListResponse {
    var toDomain: PetList {
        return PetList(pets: data)
    }
}
