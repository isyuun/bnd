//
//  DclrCreateResponse.swift
//  PetTip
//
//  Created by carebiz on 12/29/23.
//

import Foundation

struct DclrCreateStoryResponse: Codable {
    let data: LifeViewData
    let statusCode: Int
    let resultMessage: String
    let detailMessage: JSONNull?
}

extension DclrCreateStoryResponse {
    var toDomain: DclrCreateStory {
        return DclrCreateStory(data: data)
    }
}
