//
//  Global.swift
//  PetTip
//
//  Created by carebiz on 12/27/23.
//

import Foundation
import RxSwift
import RxRelay

class Global {
    // #if DEBUG
    //     static var DOMAIN = "http://dev.pettip.net:8020"
    // #else
    //     static var DOMAIN = "https://pettip.net"
    // #endif
    static var DOMAIN = "https://pettip.net" //test

    static var BASE_URI = "\(DOMAIN)/api/v1"

    static var URL_TERMS_1 = "\(DOMAIN)/terms"
    static var URL_TERMS_2 = "\(DOMAIN)/privacy_policy"
    static var URL_TERMS_3 = "\(DOMAIN)/marketing"

    static var appKey: String = ""

    static var toSchUnqNo: Int = 0

    static var petRelUnqNo: Int = 0 //182

    static var rsnCodeList: [CDDetailList]?
    static var pstCodeList: [CDDetailList]?
    static var schCodeList: [CDDetailList]? // 일상구분

    static var cmmPetListDog: [CmmPetListData]?
    static var cmmPetListCat: [CmmPetListData]?

    // USER_NICKNAME
    static var userNckNmBehaviorRelay = BehaviorRelay<String?>(value: nil)
    static var userNckNm: Observable<String?> {
        return userNckNmBehaviorRelay.asObservable()
    }

    // MY_PET_LIST
    static var myPetListBehaviorRelay = BehaviorRelay<MyPetList?>(value: nil)
    static var myPetList: Observable<MyPetList?> {
        return myPetListBehaviorRelay.asObservable()
    }

    // DAILYLIFE_PETS
    static var dailyLifePetListBehaviorRelay = BehaviorRelay<PetList?>(value: nil)
    static var dailyLifePetList: Observable<PetList?> {
        return dailyLifePetListBehaviorRelay.asObservable()
    }

    // SELECTED PET INDEX
    static var selectedPetIndexBehaviorRelay = BehaviorRelay<Int?>(value: 0)
    static var selectedPetIndex: Observable<Int?> {
        return selectedPetIndexBehaviorRelay.asObservable()
    }

    static var cmmSidoList = [
        Sido(cdld: 36, upCdId: "SCD", cdNm: "세종특별자치시"),
        Sido(cdld: 50, upCdId: "SCD", cdNm: "제주특별자치도"),
        Sido(cdld: 48, upCdId: "SCD", cdNm: "경상남도"),
        Sido(cdld: 47, upCdId: "SCD", cdNm: "경상북도"),
        Sido(cdld: 46, upCdId: "SCD", cdNm: "전라남도"),
        Sido(cdld: 45, upCdId: "SCD", cdNm: "전북특별자치도"),
        Sido(cdld: 44, upCdId: "SCD", cdNm: "충청남도"),
        Sido(cdld: 43, upCdId: "SCD", cdNm: "충청북도"),
        Sido(cdld: 41, upCdId: "SCD", cdNm: "경기도"),
        Sido(cdld: 31, upCdId: "SCD", cdNm: "울산광역시"),
        Sido(cdld: 30, upCdId: "SCD", cdNm: "대전광역시"),
        Sido(cdld: 29, upCdId: "SCD", cdNm: "광주광역시"),
        Sido(cdld: 28, upCdId: "SCD", cdNm: "인천광역시"),
        Sido(cdld: 27, upCdId: "SCD", cdNm: "대구광역시"),
        Sido(cdld: 26, upCdId: "SCD", cdNm: "부산광역시"),
        Sido(cdld: 11, upCdId: "SCD", cdNm: "서울특별시"),
        Sido(cdld: 51, upCdId: "SCD", cdNm: "강원특별자치도")
    ]

    static var invttKeyVl: String?
}
