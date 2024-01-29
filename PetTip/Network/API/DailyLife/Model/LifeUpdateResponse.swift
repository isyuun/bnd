//
//  LifeUpdateResponse.swift
//  PetTip
//
//  Created by carebiz on 12/29/23.
//

import Foundation

struct LifeUpdateResponse: Codable {
    let data: LifeViewData?
    let statusCode: Int
    let resultMessage: String
    let detailMessage: JSONNull?
}

extension LifeUpdateResponse {
    var toDomain: LifeUpdate {
        return LifeUpdate(lifeViewData: data)
    }
}
