//
//  NoticeDetailViewController.swift
//  PetTip
//
//  Created by carebiz on 1/10/24.
//

import UIKit
import AlamofireImage
import WebKit

class NoticeDetailViewController: CommonViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        
        showBackTitleBarView()
        
        showCommonUI()
        
        notice_dtl()
    }
    
    
    
    
    
    var pstSn: Int?
    
    @IBOutlet weak var lb_pstTtl : UILabel!
    @IBOutlet weak var lb_pstgBgngDt : UILabel!
    @IBOutlet weak var wv_pstCn : WKWebView!
    @IBOutlet weak var cr_wvPstCnHeight : NSLayoutConstraint!
    
    private func showCommonUI() {
        lb_pstTtl.textColor = UIColor.init(hex: "#FF222222")
        lb_pstgBgngDt.textColor = UIColor.init(hex: "#FF737980")
        
    }
    
    
    
    
    
    // MARK: - CONN NOTICE DETAIL
    
    private func notice_dtl() {
        startLoading()
        
        let request = NoticeDtlListRequest(pstSn: pstSn!)
        BBSAPI.noticeDtlList(request: request) { data, error in
            self.stopLoading()
         
            if let noticeDtlListData = data {
                self.lb_pstTtl.text = noticeDtlListData.data.pstTTL
                self.lb_pstgBgngDt.text = noticeDtlListData.data.pstgBgngDt

                self.wv_pstCn.backgroundColor = UIColor.clear
                self.wv_pstCn.isOpaque = false
                self.wv_pstCn.navigationDelegate = self
                self.wv_pstCn.loadHTMLString(noticeDtlListData.data.pstCN, baseURL: nil)
            }
            
            self.processNetworkError(error)
        }
    }
    
    
    
    
    
    // MARK: - Back TitleBar
    
    @IBOutlet weak var titleBarView : UIView!
    
    func showBackTitleBarView() {
        if let view = UINib(nibName: "BackTitleBarView", bundle: nil).instantiate(withOwner: self).first as? BackTitleBarView {
            view.frame = titleBarView.bounds
            view.lb_title.text = "공지사항"
            view.delegate = self
            titleBarView.addSubview(view)
        }
    }
}





extension NoticeDetailViewController: BackTitleBarViewProtocol {
    func onBack() {
        navigationController?.popViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
}





// MARK: - WebView Delegate

extension NoticeDetailViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        let jscript = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);"
        webView.evaluateJavaScript(jscript)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.frame.size.height = 1
        webView.frame.size = webView.sizeThatFits(.zero)
        webView.scrollView.isScrollEnabled = false;
        webView.evaluateJavaScript("document.documentElement.scrollHeight", completionHandler: { (height, error) in
            self.cr_wvPstCnHeight.constant = height! as! CGFloat
        })
    }
}


