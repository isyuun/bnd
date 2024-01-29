//
//  CreateUserRequest.swift
//  PetTip
//
//  Created by carebiz on 1/18/24.
//

import Foundation

/*
{
  "appKey": "string",
  "appOs": "001",
  "appTypNm": "SM-T975N",
  "ncknm": "바둑이",
  "snsLogin": "NAVER,KAKAO,GOOGLE", or EMAIL
  "userID": "care@care-pet.kr",
  "userName": "이수홍",
  "userPW": "string"
}
*/

struct CreateUserRequest: Encodable {
    let appKey: String  // PUSH KEY
    let appOs: String   // 앱OS(001:AOS,002:IOS)
    let appTypNm: String
    let ncknm: String
    let snsLogin: String
    let userID: String
    let userName: String
    let userPW: String
}
