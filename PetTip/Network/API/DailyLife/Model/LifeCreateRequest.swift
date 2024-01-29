//
//  LifeCreateRequest.swift
//  PetTip
//
//  Created by carebiz on 1/18/24.
//

import Foundation

struct LifeCreateRequest: Encodable {
    
    // REQUIRED : Y/N
    let cmntUseYn: String
    let rcmdtnYn: String
    let rlsYn: String
    let schTtl: String
    let schCn: String
    let hashTag: [String]
    let pet: [DailyLifePet]
    let schCdList: [String]
    let totClr: Int
    let totDstnc: Int
    let walkDptreDt: String
    let walkEndDt: String
    
    // OPTIONAL
    let files: [DailyLifeFile]?
}

struct DailyLifeFile: Codable {
    let orgnlAtchFileNm, atchFileNm, fileExtnNm, filePathNm: String
    let flmPstnLat, flmPstnLot: String?
    let atchFileSz: Int
}

struct DailyLifePet: Codable {
    let ownrPetUnqNo, petNm, bwlMvmNmtm, urineNmtm, relmIndctNmtm: String
}

/*
{
  "cmntUseYn": "Y",
  "files": [
    {
      "orgnlAtchFileNm": "KakaoTalk_Photo_2023-08-08-15-11-27.jpeg",
      "atchFileNm": "d3923ffef36d4cdeb06ffbf7c60bd21d.JPEG",
      "atchFileSz": "85917",
      "fileExtnNm": "JPEG",
      "filePathNm": "/dailyLife/20230822/",
      "flmPstnLat": "0.0",
      "flmPstnLot": "0.0"
    }
  ],
  "hashTag": [
    "댕댕이",
    "산책"
  ],
  "pet": [
    {
      "ownrPetUnqNo": "P20230822000046",
      "petNm": "이슬",
      "bwlMvmNmtm": "0",
      "urineNmtm": "0",
      "relmIndctNmtm": "0"
    }
  ],
  "rcmdtnYn": "Y",
  "rlsYn": "Y",
  "schCdList": [
    "001",
    "002"
  ],
  "schCn": "String",
  "schTtl": "String",
  "totClr": 340,
  "totDstnc": 1500,
  "walkDptreDt": "YYYYMMDDHH24MISS",
  "walkEndDt": "YYYYMMDDHH24MISS"
}
*/
