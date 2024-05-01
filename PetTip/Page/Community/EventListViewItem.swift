//
//  EventListViewItem.swift
//  PetTip
//
//  Created by carebiz on 12/30/23.
//

import UIKit
import AlamofireImage

class EventListViewItem : UITableViewCell {
    
    @IBOutlet weak var iv_event: UIImageView!
    @IBOutlet weak var lb_eventImageViewDisable: UILabel!
    @IBOutlet weak var lb_title: UILabel!
    @IBOutlet weak var lb_dt: UILabel!
    
    public var isEnable: Bool = true
    
    func initialize(event: BBSEvntList) {
        iv_event.af.setImage(
            withURL: URL(string: event.rprsImgURL)!,
            placeholderImage: nil,
            filter: AspectScaledToFillSizeFilter(size: iv_event.frame.size)
        )
        
        lb_title.text = event.pstTTL
        
        if let pstgBgngDt = event.pstgBgngDt, let pstgEndDt = event.pstgEndDt {
            lb_dt.text = String("\(pstgBgngDt) ~ \(pstgEndDt)")
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let bgnDt = formatter.date(from: pstgBgngDt)
            let endDt = formatter.date(from: pstgEndDt)
            
            var isBefore = false
            let bgnCompare = Date().dateCompare(fromDate: bgnDt!)
            if bgnCompare == "Future" {
                // 아직 시작전...
                isBefore = true
            }

            var isAfter = false
            let endCompare = Date().dateCompare(fromDate: endDt!)
            if endCompare == "Past" {
                // 종료
                isAfter = true
            }

            if isBefore || isAfter {
                isEnable = false
            } else {
                isEnable = true
            }
            
            if isEnable {
                lb_eventImageViewDisable.isHidden = true
                lb_title.textColor = UIColor.darkText
                lb_dt.textColor = UIColor.init(hex: "#FF737980")
                
            } else {
                lb_eventImageViewDisable.isHidden = false
                lb_eventImageViewDisable.backgroundColor = UIColor.init(hex: "#99000000")
                if isBefore {
                    lb_eventImageViewDisable.text = "시작전 이벤트"
                } else if isAfter {
                    lb_eventImageViewDisable.text = "종료된 이벤트"
                }
                lb_title.textColor = UIColor.init(hex: "#FFB5B9BE")
                lb_dt.textColor = UIColor.init(hex: "#FFB5B9BE")
            }
            
        } else {
            lb_dt.text = ""
            
            lb_eventImageViewDisable.isHidden = true
            lb_title.textColor = UIColor.darkText
            lb_dt.textColor = UIColor.init(hex: "#FF737980")
        }
    }
}
