//
//  LifeUpdateRequest.swift
//  PetTip
//
//  Created by carebiz on 12/29/23.
//

import Foundation

struct LifeUpdateRequest: Encodable {
    
    // REQUIRED : Y/N
    let cmntUseYn: String
    let delYn: String
    let rcmdtnYn: String
    let rlsYn: String
    let schTtl: String
    let schUnqNo: Int
    
    // OPTIONAL
    let schCn: String?
    let dailyLifePetList: [DailyLifePetList]?
    let dailyLifeFileList: [DailyLifeFileList]?
    let dailyLifeSchSeList: [DailyLifeSchSEList]?
    let dailyLifeSchHashTagList: [DailyLifeSchHashTagList]?
}
