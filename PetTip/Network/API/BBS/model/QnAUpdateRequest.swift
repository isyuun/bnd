//
//  QnAUpdateRequest.swift
//  PetTip
//
//  Created by carebiz on 1/13/24.
//

import Foundation

struct QnAUpdateRequest: Encodable {
    let pstSn: Int
    let files: [PhotoDataUp]
    let pstCn: String
    let pstSeCd: String
    let pstTtl: String
}
