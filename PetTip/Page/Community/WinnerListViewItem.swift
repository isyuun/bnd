//
//  ListItemView.swift
//  PetTip
//
//  Created by carebiz on 12/30/23.
//

import Foundation
import AlamofireImage

class WinnerListViewItem: UITableViewCell {
    
    @IBOutlet weak var iv: UIImageView!
    @IBOutlet weak var lb_imageViewDisable: UILabel!
    @IBOutlet weak var lb_title: UILabel!
    @IBOutlet weak var lb_dt: UILabel!
    
    public var isEnable: Bool = true
    
    func initialize(item: BBSWinnerList) {
        iv.af.setImage(
            withURL: URL(string: item.rprsImgURL)!,
            placeholderImage: nil,
            filter: AspectScaledToFillSizeFilter(size: iv.frame.size)
        )
        
        lb_title.text = item.pstTTL
        
        if let pstgBgngDt = item.pstgBgngDt, let pstgEndDt = item.pstgEndDt {
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
                lb_imageViewDisable.isHidden = true
                lb_title.textColor = UIColor.darkText
                lb_dt.textColor = UIColor.init(hex: "#FF737980")
                
            } else {
                lb_imageViewDisable.isHidden = false
                lb_imageViewDisable.backgroundColor = UIColor.init(hex: "#99000000")
                if isBefore {
                    lb_imageViewDisable.text = "시작전"
                } else if isAfter {
                    lb_imageViewDisable.text = "종료"
                }
                lb_title.textColor = UIColor.init(hex: "#FFB5B9BE")
                lb_dt.textColor = UIColor.init(hex: "#FFB5B9BE")
            }
            
        } else {
            lb_dt.text = ""
            
            lb_imageViewDisable.isHidden = true
            lb_title.textColor = UIColor.darkText
            lb_dt.textColor = UIColor.init(hex: "#FF737980")
        }
    }
}
