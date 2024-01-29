//
//  MonthRecordResponse.swift
//  PetTip
//
//  Created by carebiz on 12/16/23.
//

import Foundation

struct MonthRecordResponse: Codable {
    let data: MonthRecordData
    let statusCode: Int
    let resultMessage: String
    let detailMessage: JSONNull?
}

// MARK: - DataClass
struct MonthRecordData: Codable {
    let runCnt: Int
    let runTime: String?
    let runDstnc, runCLR: Int
    let dayList: [MonthRecordDayList]?

    enum CodingKeys: String, CodingKey {
        case runCnt, runTime, runDstnc
        case runCLR = "runClr"
        case dayList
    }
}

// MARK: - DayList
struct MonthRecordDayList: Codable {
    let date, dayNm: String
    let runCnt: Int
    let todayYn, thisMonthYn: Yn?
}

enum Yn: String, Codable {
    case y = "Y"
    case n = "N"
}

extension MonthRecordResponse {
    var toDomain: MonthRecord {
        return MonthRecord(monthRecord: data)
    }
}
