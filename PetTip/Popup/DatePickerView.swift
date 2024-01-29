//
//  DatePickerView.swift
//  PetTip
//
//  Created by carebiz on 1/4/24.
//

import UIKit

class DatePickerView: CommonPopupView {
    
    @IBOutlet weak var datePicker : UIDatePicker!
    
    public var didTapOK: ((_ datetime: String)-> Void)?
    public var didTapCancel: (()-> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder : NSCoder) {
        super.init(coder: aDecoder);
    }
    
    public func initialize() {
        datePicker.datePickerMode = .dateAndTime
    }
    
    public func initializeOnlyDate() {
        datePicker.datePickerMode = .date
    }
    
    public func preventSelectFuture() {
        datePicker.maximumDate = Date()
    }
    
    @IBAction func onCancel(_ sender: Any) {
        didTapCancel?()
    }
    
    @IBAction func onOK(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmm"
        let datetime = dateFormatter.string(from: datePicker.date)
        didTapOK?(datetime)
    }
}
