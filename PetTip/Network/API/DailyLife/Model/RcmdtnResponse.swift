//
//  RcmdtnResponse.swift
//  PetTip
//
//  Created by carebiz on 12/26/23.
//

import Foundation

struct RcmdtnResponse: Codable {
    let data: LifeViewData
    let statusCode: Int
    let resultMessage: String
    let detailMessage: JSONNull?
}

extension RcmdtnResponse {
    var toDomain: LifeView {
        return LifeView(lifeViewData: data)
    }
}
