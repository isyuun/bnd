//
//  ChkNcknmRequest.swift
//  PetTip
//
//  Created by carebiz on 1/2/24.
//

import Foundation

/*
{
  "ncknm": "바둑이"
}
*/

struct ChkNcknmRequest: Encodable {
    let ncknm: String
}
