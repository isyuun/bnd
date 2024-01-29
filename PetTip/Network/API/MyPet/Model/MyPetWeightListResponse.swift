//
//  MyPetWeightListResponse.swift
//  PetTip
//
//  Created by carebiz on 1/27/24.
//

import Foundation

struct MyPetWeightListResponse: Codable {
    let data: [MyPetWeightData]
    let statusCode: Int
    let detailMessage: String?
    let resultMessage: String
    let resHeaders: String?
}

// MARK: - MyPetWeightData
struct MyPetWeightData: Codable {
    let crtrYmd, ownrPetUnqNo: String
    let petDtlUnqNo: Int
    let userID: String
    let wghtVl: Double

    enum CodingKeys: String, CodingKey {
        case crtrYmd, ownrPetUnqNo, petDtlUnqNo
        case userID = "userId"
        case wghtVl
    }
}
