//
//  PetListResponse.swift
//  PetTip
//
//  Created by carebiz on 1/6/24.
//

import Foundation

struct CmmPetListResponse: Codable {
    let data: [CmmPetListData]
    let statusCode: Int
    let detailMessage, resultMessage, resHeaders: String?
}

// MARK: - CmmPetListData
struct CmmPetListData: Codable {
    let petNm, petEnNm, petDogSzCD: String
    let petInfoUnqNo: Int
    let petTypCD: String

    enum CodingKeys: String, CodingKey {
        case petNm, petEnNm
        case petDogSzCD = "petDogSzCd"
        case petInfoUnqNo
        case petTypCD = "petTypCd"
    }
}
