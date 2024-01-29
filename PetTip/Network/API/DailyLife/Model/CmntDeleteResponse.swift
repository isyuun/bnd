//
//  CmntDeleteResponse.swift
//  PetTip
//
//  Created by carebiz on 12/27/23.
//

import Foundation

struct CmntDeleteResponse: Codable {
    let data: [CmntList]?
    let statusCode: Int
    let resultMessage: String
    let detailMessage: JSONNull?
}

extension CmntDeleteResponse {
    var toDomain: CmntDelete {
        return CmntDelete(data: data)
    }
}
