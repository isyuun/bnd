//
//  WalkHistoryMonthView.swift
//  PetTip
//
//  Created by carebiz on 12/16/23.
//

import UIKit

class WalkHistoryMonthView : UIView {
    
    var delegate : WalkHistoryMonthViewProtocol!
    func setDelegate(_ _delegate : WalkHistoryMonthViewProtocol) {
        delegate = _delegate
    }
    
    @IBOutlet weak var lb_yearMonth : UILabel!
    @IBOutlet weak var vw_weekIndex : UIView!
    
    @IBOutlet weak var vw_cal_00 : UIView!
    @IBOutlet weak var vw_cal_01 : UIView!
    @IBOutlet weak var vw_cal_02 : UIView!
    @IBOutlet weak var vw_cal_03 : UIView!
    @IBOutlet weak var vw_cal_04 : UIView!
    @IBOutlet weak var vw_cal_05 : UIView!
    @IBOutlet weak var vw_cal_06 : UIView!
    
    @IBOutlet weak var vw_cal_07 : UIView!
    @IBOutlet weak var vw_cal_08 : UIView!
    @IBOutlet weak var vw_cal_09 : UIView!
    @IBOutlet weak var vw_cal_10 : UIView!
    @IBOutlet weak var vw_cal_11 : UIView!
    @IBOutlet weak var vw_cal_12 : UIView!
    @IBOutlet weak var vw_cal_13 : UIView!
    
    @IBOutlet weak var vw_cal_14 : UIView!
    @IBOutlet weak var vw_cal_15 : UIView!
    @IBOutlet weak var vw_cal_16 : UIView!
    @IBOutlet weak var vw_cal_17 : UIView!
    @IBOutlet weak var vw_cal_18 : UIView!
    @IBOutlet weak var vw_cal_19 : UIView!
    @IBOutlet weak var vw_cal_20 : UIView!
    
    @IBOutlet weak var vw_cal_21 : UIView!
    @IBOutlet weak var vw_cal_22 : UIView!
    @IBOutlet weak var vw_cal_23 : UIView!
    @IBOutlet weak var vw_cal_24 : UIView!
    @IBOutlet weak var vw_cal_25 : UIView!
    @IBOutlet weak var vw_cal_26 : UIView!
    @IBOutlet weak var vw_cal_27 : UIView!
    
    @IBOutlet weak var vw_cal_28 : UIView!
    @IBOutlet weak var vw_cal_29 : UIView!
    @IBOutlet weak var vw_cal_30 : UIView!
    @IBOutlet weak var vw_cal_31 : UIView!
    @IBOutlet weak var vw_cal_32 : UIView!
    @IBOutlet weak var vw_cal_33 : UIView!
    @IBOutlet weak var vw_cal_34 : UIView!
    
    @IBOutlet weak var vw_cal_35 : UIView!
    @IBOutlet weak var vw_cal_36 : UIView!
    @IBOutlet weak var vw_cal_37 : UIView!
    @IBOutlet weak var vw_cal_38 : UIView!
    @IBOutlet weak var vw_cal_39 : UIView!
    @IBOutlet weak var vw_cal_40 : UIView!
    @IBOutlet weak var vw_cal_41 : UIView!
    
    @IBOutlet weak var lb_walkCnt : UILabel!
    @IBOutlet weak var lb_walkDist : UILabel!
    @IBOutlet weak var lb_walkTime : UILabel!
    
    var date = Date()
    var searchDay : String? = nil
    var ownrPetUnqNo : String? = nil
    
    var arrCalViewItem = Array<UIView>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder : NSCoder) {
        super.init(coder: aDecoder);
    }
    
    func initialize() {
        vw_weekIndex.layer.cornerRadius = 10
        
        arrCalViewItem = Array<UIView>()
        arrCalViewItem.append(vw_cal_00)
        arrCalViewItem.append(vw_cal_01)
        arrCalViewItem.append(vw_cal_02)
        arrCalViewItem.append(vw_cal_03)
        arrCalViewItem.append(vw_cal_04)
        arrCalViewItem.append(vw_cal_05)
        arrCalViewItem.append(vw_cal_06)
        
        arrCalViewItem.append(vw_cal_07)
        arrCalViewItem.append(vw_cal_08)
        arrCalViewItem.append(vw_cal_09)
        arrCalViewItem.append(vw_cal_10)
        arrCalViewItem.append(vw_cal_11)
        arrCalViewItem.append(vw_cal_12)
        arrCalViewItem.append(vw_cal_13)
        
        arrCalViewItem.append(vw_cal_14)
        arrCalViewItem.append(vw_cal_15)
        arrCalViewItem.append(vw_cal_16)
        arrCalViewItem.append(vw_cal_17)
        arrCalViewItem.append(vw_cal_18)
        arrCalViewItem.append(vw_cal_19)
        arrCalViewItem.append(vw_cal_20)
        
        arrCalViewItem.append(vw_cal_21)
        arrCalViewItem.append(vw_cal_22)
        arrCalViewItem.append(vw_cal_23)
        arrCalViewItem.append(vw_cal_24)
        arrCalViewItem.append(vw_cal_25)
        arrCalViewItem.append(vw_cal_26)
        arrCalViewItem.append(vw_cal_27)
        
        arrCalViewItem.append(vw_cal_28)
        arrCalViewItem.append(vw_cal_29)
        arrCalViewItem.append(vw_cal_30)
        arrCalViewItem.append(vw_cal_31)
        arrCalViewItem.append(vw_cal_32)
        arrCalViewItem.append(vw_cal_33)
        arrCalViewItem.append(vw_cal_34)
        
        arrCalViewItem.append(vw_cal_35)
        arrCalViewItem.append(vw_cal_36)
        arrCalViewItem.append(vw_cal_37)
        arrCalViewItem.append(vw_cal_38)
        arrCalViewItem.append(vw_cal_39)
        arrCalViewItem.append(vw_cal_40)
        arrCalViewItem.append(vw_cal_41)
    }
    
    func update() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM"
        searchDay = formatter.string(from: date)
        
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "yyyy년 MM월"
        lb_yearMonth.text = formatter2.string(from: date)
        
        request()
    }
    
    @IBAction func onBefore(_ sender: Any) {
        date = Calendar.current.date(byAdding: .month, value: -1, to: date)!
        update()
    }
    
    @IBAction func onNext(_ sender: Any) {
        date = Calendar.current.date(byAdding: .month, value: 1, to: date)!
        update()
    }
    
    private func request() {
        if let _searchDay = searchDay, let _ownrPetUnqNo = ownrPetUnqNo {
            delegate.onStartLoading()
            
            let request = MonthRecordRequest(ownrPetUnqNo: _ownrPetUnqNo, searchMonth: _searchDay)
            DailyLifeAPI.monthRecord(request: request) { monthRecord, error in
                self.delegate.onStopLoading()
                
                if let _monthRecord = monthRecord {
                    if let _dayList = _monthRecord.monthRecord.dayList {
                        for i in 0...self.arrCalViewItem.count - 1 {
                            let viewItem = self.arrCalViewItem[i]
                            viewItem.subviews.forEach({ $0.removeFromSuperview()})
                        }
                        
                        for i in 0..._dayList.count - 1 {
                            if _dayList[i].thisMonthYn != .y { continue }
                            
                            if let view = UINib(nibName: "WalkHistoryItemView", bundle: nil).instantiate(withOwner: self).first as? WalkHistoryItemView
                            {
                                let viewItem = self.arrCalViewItem[i]
                                
                                view.frame = viewItem.bounds
                                
                                let fomatter = DateFormatter()
                                fomatter.dateFormat = "yyyy-MM-dd"
                                let date = fomatter.date(from: _dayList[i].date) as Date?
                                
                                let fomatter2 = DateFormatter()
                                fomatter2.dateFormat = "d"
                                view.text = fomatter2.string(from: date!)
                                
                                view.isActive = _dayList[i].runCnt > 0 ? true : false
                                
                                let today = fomatter.string(from: Date())
                                if (_dayList[i].date == today) {
                                    view.isToday = true
                                } else {
                                    view.isToday = false
                                }
                                
                                viewItem.addSubview(view)
                                view.update()
                            }
                        }
                    }
                    
                    self.lb_walkCnt.text = String("\(_monthRecord.monthRecord.runCnt)회")
                    
                    if let _runTime = _monthRecord.monthRecord.runTime {
                        self.lb_walkTime.text = _runTime
                    } else {
                        self.lb_walkTime.text = "00:00:00"
                    }
                    
                    self.lb_walkDist.text = String(format: "%.1fkm", Float(_monthRecord.monthRecord.runDstnc) / Float(1000.0))
                }
                
                self.delegate.onMonthViewNetworkError(error)
            }
        }
    }
}

protocol WalkHistoryMonthViewProtocol: AnyObject {
    func onStartLoading()
    func onStopLoading()
    func onMonthViewNetworkError(_ error : MyError?)
}
