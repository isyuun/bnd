//
//  WalkHistoryDetailViewController.swift
//  PetTip
//
//  Created by carebiz on 12/14/23.
//

import UIKit
import AlamofireImage

class WalkHistoryDetailViewController : CommonDetailViewController {
    
    @IBOutlet weak var lb_dt : UILabel!
    
    @IBOutlet weak var cr_imgHeight : NSLayoutConstraint!
    @IBOutlet weak var vw_img : UIView!
    @IBOutlet weak var sv_img : UIScrollView!
    @IBOutlet weak var pc_img : UIPageControl!
    
    @IBOutlet weak var lb_walker : UILabel!
    @IBOutlet weak var lb_time : UILabel!
    @IBOutlet weak var lb_dist : UILabel!
    
    @IBOutlet weak var cr_petListAreaHeight : NSLayoutConstraint!
    @IBOutlet weak var vw_petListContent : UIView!
    
    @IBOutlet weak var cr_msgAreaHeight : NSLayoutConstraint!
    @IBOutlet weak var vw_msgContent : UIView!
    @IBOutlet weak var lb_msg : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestLifeViewData()
    }
    
    
    
    
    
    // MARK: - TARGET LIFE VIEW DATA
    
    var schUnqNo : Int? = 0
    
    var slides : [CommonDetailImageItemView]!
    
    func requestLifeViewData() {
        if let schUnqNo = schUnqNo {
            startLoading()
            
            let request = LifeViewRequest(cmntYn: "N", schUnqNo: schUnqNo)
            DailyLifeAPI.view(request: request) { lifeView, error in
                self.stopLoading()
                
                if let lifeView = lifeView {
                    self.lb_title?.text = lifeView.lifeViewData.schTTL
                    self.lb_dt.text = lifeView.lifeViewData.walkDptreDt
                    
                    
                    if let fileList = lifeView.lifeViewData.dailyLifeFileList {
                        if (fileList.count > 0) {
                            self.slides = [CommonDetailImageItemView](repeating: CommonDetailImageItemView(), count: fileList.count)
                            
                            self.sv_img.contentSize = CGSize(width: self.sv_img.frame.width * CGFloat(self.slides.count), height: self.sv_img.frame.height)
                            self.sv_img.showsHorizontalScrollIndicator = false
                            self.sv_img.isPagingEnabled = true
                            self.sv_img.delegate = self
                            
                            self.pc_img.numberOfPages = self.slides.count
                            self.pc_img.currentPage = 0
                            
                            for i in 0 ..< fileList.count {
                                let slide = Bundle.main.loadNibNamed("CommonDetailImageItemView", owner: self, options: nil)?.first as! CommonDetailImageItemView
                                
                                slide.frame = CGRect(x: self.sv_img.frame.width * CGFloat(i), y: 0, width: self.sv_img.frame.width, height: self.sv_img.frame.height)
                                
                                slide.iv_img.af.setImage(
                                    withURL: URL(string: String("\(lifeView.lifeViewData.atchPath)\(fileList[i].filePathNm)\(fileList[i].atchFileNm)"))!
                                )
                                
                                self.slides[i] = slide
                                self.sv_img.addSubview(self.slides[i])
                            }
                            
                        } else {
                            self.pc_img.isHidden = true
                            self.cr_imgHeight.constant = 0
                        }
                    } else {
                        self.pc_img.isHidden = true
                        self.cr_imgHeight.constant = 0
                    }
                    
                    self.lb_walker.text = lifeView.lifeViewData.runNcknm
                    self.lb_time.text = lifeView.lifeViewData.runTime
                    self.lb_dist.text = String(format: "%.1fkm", Float(lifeView.lifeViewData.runDstnc) / Float(1000.0))
                    
                    
                    if let petList = lifeView.lifeViewData.dailyLifePetList {
                        if petList.count > 0 {
                            var petViews = [WalkHistoryPetItemView](repeating: WalkHistoryPetItemView(), count: petList.count)
                            for i in 0 ..< petList.count {
                                if let view = UINib(nibName: "WalkHistoryPetItemView", bundle: nil).instantiate(withOwner: self).first as? WalkHistoryPetItemView
                                {
                                    petViews[i] = view
                                    self.vw_petListContent.addSubview(view)
                                    
                                    if let petImg = petList[0].petImg {
                                        view.iv_prof.af.setImage(
                                            withURL: URL(string: petImg)!,
                                            placeholderImage: UIImage(named: "profile_default")!,
                                            filter: AspectScaledToFillSizeFilter(size: view.iv_prof.frame.size)
                                        )
                                    } else {
                                        view.iv_prof.image = UIImage(named: "profile_default")
                                    }
                                    
                                    view.lb_nm.text = petList[i].petNm
                                    view.lb_cnt_poop.text = String("\(petList[i].bwlMvmNmtm)회")
                                    view.lb_cnt_pee.text = String("\(petList[i].urineNmtm)회")
                                    view.lb_cnt_marking.text = String("\(petList[i].relmIndctNmtm)회")
                                    view.initialize()
                                    
                                    view.translatesAutoresizingMaskIntoConstraints = false;
                                    
                                    var topConstraint : NSLayoutConstraint!
                                    if (i == 0) {
                                        topConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.vw_petListContent, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0)
                                    } else {
                                        topConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: petViews[i - 1], attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 8)
                                    }
                                    
                                    let leadingConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.vw_petListContent, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0)
                                    
                                    let trailingConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.vw_petListContent, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0)
                                    
                                    let heightConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 104)
                                    
                                    if (i < petList.count - 1) {
                                        self.vw_petListContent.addConstraints([topConstraint, leadingConstraint, trailingConstraint, heightConstraint])
                                        
                                    } else  {
                                        let bottomConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.vw_petListContent, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
                                        
                                        self.vw_petListContent.addConstraints([topConstraint, leadingConstraint, trailingConstraint, heightConstraint, bottomConstraint])
                                    }
                                }
                            }
                        } else {
                            self.cr_petListAreaHeight.constant = 0
                        }
                    } else {
                        self.cr_petListAreaHeight.constant = 0
                    }
                   
                    if let schCN = lifeView.lifeViewData.schCN, schCN.count > 0, schCN != " " {
                        self.vw_msgContent.layer.cornerRadius = 10
                        self.vw_msgContent.backgroundColor = UIColor(hex: "#FFF6F8FC")
                        
                        self.lb_msg.preferredMaxLayoutWidth = self.lb_msg.frame.size.width
                        self.lb_msg.text = lifeView.lifeViewData.schCN
                        self.cr_msgAreaHeight.priority = .defaultLow
                        
                    } else {
                        self.cr_msgAreaHeight.constant = 0
                        self.cr_msgAreaHeight.priority = UILayoutPriority.init(1000)
                    }
                }
                
                self.processNetworkError(error)
            }
        }
    }
}





// MARK: - IMAGE VIEW SCROLLVIEW DELEGATE

extension WalkHistoryDetailViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        if (Int(pageIndex) > slides.count - 1) {
            return
        }
        
        pc_img.currentPage = Int(pageIndex)
        
        let maximumHorizontalOffset: CGFloat = scrollView.contentSize.width - scrollView.frame.width
        let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x
        
        let maximumVerticalOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.height
        let currentVerticalOffset: CGFloat = scrollView.contentOffset.y
        
        let percentageHorizontalOffset: CGFloat = currentHorizontalOffset / maximumHorizontalOffset
        let percentageVerticalOffset: CGFloat = currentVerticalOffset / maximumVerticalOffset
        
        let percentOffset: CGPoint = CGPoint(x: percentageHorizontalOffset, y: percentageVerticalOffset)
        
        let itemOffset = 1 / Float(slides.count - 1)
        if itemOffset > 0 && percentOffset.x > 0 && percentOffset.x <= 1 {
            let transOffset = CGFloat(itemOffset) * CGFloat(Int(pageIndex) + 1)
            
            if (Int(pageIndex) < slides.count - 1) {
                slides[Int(pageIndex)].iv_img.transform = CGAffineTransform(scaleX: (transOffset-percentOffset.x)/CGFloat(itemOffset), y: (transOffset-percentOffset.x)/CGFloat(itemOffset))
                slides[Int(pageIndex) + 1].iv_img.transform = CGAffineTransform(scaleX: percentOffset.x/transOffset, y: percentOffset.x/transOffset)
                
            } else {
                slides[Int(pageIndex)].iv_img.transform = CGAffineTransform(scaleX: percentOffset.x, y: percentOffset.x)
            }
        }
    }
}
