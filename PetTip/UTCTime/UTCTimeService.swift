//
//  UTCTimeService.swift
//  PetTip
//
//  Created by carebiz on 11/22/23.
//

import Foundation

class UTCTimeService {
    
    let repository = UTCRepository()
    
    var currentModel = UTCTimeModel(currentDateTime: Date())
                             
    func fetchNow(onCompleted: @escaping (UTCTimeModel) -> Void) {
        
        repository.fetchNow { [weak self] entity in
            let formetter = DateFormatter()
            formetter.dateFormat = "yyyy-MM-dd'T'HH:mm'Z'"
            
            guard let now = formetter.date(from: entity.currentDateTime) else { return }
            
            let model = UTCTimeModel(currentDateTime: now)
            self?.currentModel = model
            
            onCompleted(model)
        }
    }
    
    func moveDay(day: Int) {
        
        guard let movedDay = Calendar.current.date(byAdding: .day, value: day, to: currentModel.currentDateTime) else { return }
        currentModel.currentDateTime = movedDay
    }
}
