//
//  UTCTimeViewModelRx.swift
//  PetTip
//
//  Created by carebiz on 11/23/23.
//

import Foundation
import RxRelay

class UTCTimeViewModelRx {
    
//    var onUpdated: () -> Void = { }
    
    let dateTimeString = BehaviorRelay(value: "Loading...")
//    var dateTimeString : String = "Loading..."
//    {
//        didSet {
//            onUpdated()
//        }
//    }
    
    let service = UTCTimeService()
    
    private func dateToString(date: Date) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일 HH시 mm분"
        return formatter.string(from: date)
    }
    
    func reload() {
        
        service.fetchNow { [weak self] model in
            guard let self = self else { return }
            let dateString = self.dateToString(date: model.currentDateTime)
            
//            self.dateTimeString = dateString
            self.dateTimeString.accept(dateString)
        }
    }
    
    func moveDay(day: Int) {
        
        service.moveDay(day: day)
        
//        dateTimeString = dateToString(date: service.currentModel.currentDateTime)
        self.dateTimeString.accept(dateToString(date: service.currentModel.currentDateTime))
    }
}
