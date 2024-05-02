//
//  EventListViewController2.swift
//  PetTip
//
//  Created by isyuun on 2024/5/1.
//

import UIKit

class EventListViewController2: EventListViewController{
    override func event_list(_ isMore: Bool) {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][isMore:\(isMore)]")
        super.event_list(isMore)
    }
}
