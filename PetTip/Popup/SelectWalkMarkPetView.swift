//
//  SelectWalkMarkPetView.swift
//  PetTip
//
//  Created by carebiz on 2/3/24.
//

import UIKit

class SelectWalkMarkPetView: CommonPopupView {
    
    public var didSelect: ((_ selectIndex: Int)-> Void)?
    public var didCancel: (()-> Void)?
    
    @IBOutlet weak var cr_baseViewHeight: NSLayoutConstraint!           // 루트 뷰 높이
    
    @IBOutlet weak var cr_scrollViewTopMargin: NSLayoutConstraint!      // 루트 뷰에서의 스크롤 뷰 TOP 마진
    @IBOutlet weak var cr_scrollViewBottomMargin: NSLayoutConstraint!   // 루트 뷰에서의 스크롤 뷰 BOTTOM 마진
    @IBOutlet weak var cr_contentViewHeight: NSLayoutConstraint!        // 스크롤 뷰 내 컨텐츠 영약 뷰 높이
    
    @IBOutlet weak var vw_area: UIView!
    
    private var pets: [Pet]?
    
    func initialize(pets: [Pet]?, mark: NMapViewController.EventMark) {
        self.pets = pets
        
        guard let pets = pets else { return }
        
        cr_baseViewHeight.constant = UIScreen.main.bounds.height
        
        let titleLabelHeight: CGFloat = 16
        let cnt = pets.count
        
        let v = UINib(nibName: "SelectWalkMarkPetItemView", bundle: nil).instantiate(withOwner: self).first as! SelectWalkMarkPetItemView
        let itemViewHeight = v.frame.height
        
        var contentViewHeight = itemViewHeight * CGFloat(cnt) + titleLabelHeight
        if UIScreen.main.bounds.height - cr_scrollViewTopMargin.constant - cr_scrollViewBottomMargin.constant > contentViewHeight {
            contentViewHeight = UIScreen.main.bounds.height - cr_scrollViewTopMargin.constant - cr_scrollViewBottomMargin.constant
        }
        cr_contentViewHeight.constant = CGFloat(contentViewHeight)
        
        
        for i in stride(from: cnt - 1, to: -1, by: -1) {
        
            if let v = UINib(nibName: "SelectWalkMarkPetItemView", bundle: nil).instantiate(withOwner: self).first as? SelectWalkMarkPetItemView {
                v.initialize()
                v.lb_nm.text = pets[i].petNm
                v.didSelect = {
                    self.didSelect?(i)
                }
                v.translatesAutoresizingMaskIntoConstraints = false
                vw_area.addSubview(v)
                
                var constL :NSLayoutConstraint = NSLayoutConstraint(item: v, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: vw_area, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0);
                constL.priority = .defaultHigh
                vw_area.addConstraint(constL)
                
                var constT :NSLayoutConstraint = NSLayoutConstraint(item: v, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: vw_area, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0);
                constT.priority = .defaultHigh
                vw_area.addConstraint(constT)
                
                if i == cnt - 1 {
                    var const :NSLayoutConstraint = NSLayoutConstraint(item: v, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: vw_area, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0);
                    const.priority = .defaultHigh
                    vw_area.addConstraint(const)
                    
                } else {
                    let prevView = vw_area.subviews[vw_area.subviews.count - 2]
                    
                    var const :NSLayoutConstraint = NSLayoutConstraint(item: v, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: prevView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0);
                    const.priority = .defaultHigh
                    vw_area.addConstraint(const)
                }
            }
        }
        
        
        var markNm = "마킹"
        if mark == .PEE {
            markNm = "쉬야"
        } else if mark == .POO {
            markNm = "응가"
        } else if mark == .MRK {
            markNm = "마킹"
        }
        
        let title = UILabel()
        title.text = String("'\(markNm)'를(을) 남길 아이")
        title.textColor = UIColor.white
        title.font = UIFont.boldSystemFont(ofSize: 14)
        title.textAlignment = .right
        
        title.translatesAutoresizingMaskIntoConstraints = false
        vw_area.addSubview(title)
        
        let prevView = vw_area.subviews[vw_area.subviews.count - 2]
        
        vw_area.addConstraint(NSLayoutConstraint(item: title, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: prevView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0))
        
        vw_area.addConstraint(NSLayoutConstraint(item: title, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: vw_area, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0))
        
        vw_area.addConstraint(NSLayoutConstraint(item: title, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: vw_area, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: -17))
        
        vw_area.addConstraint(NSLayoutConstraint(item: title, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant: titleLabelHeight))
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        tap.cancelsTouchesInView = false
        self.addGestureRecognizer(tap)
    }
    
    @objc func dismiss() {
        didCancel?()
    }
}
