//
//  RlsUpdateResponse.swift
//  PetTip
//
//  Created by carebiz on 12/29/23.
//

import Foundation

struct RlsUpdateResponse: Codable {
    let data: LifeViewData
    let statusCode: Int
    let resultMessage: String
    let detailMessage: JSONNull?
}

extension RlsUpdateResponse {
    var toDomain: RlsUpdate {
        return RlsUpdate(lifeViewData: data)
    }
}
