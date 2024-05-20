//
//  String2.swift
//  PetTip
//
//  Created by isyuun on 2024/5/20.
//

import Foundation

extension String {
    func ellipsis(to length: Int, trailing: String = "…") -> String {
        return (self.count > length) ? self.prefix(length) + trailing : self
    }
}
