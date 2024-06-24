//
//  EventDetailViewController.swift
//  PetTip
//
//  Created by carebiz on 12/30/23.
//

import UIKit
import AlamofireImage
import WebKit

class EventDetailViewController: CommonViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.tabBar.isHidden = true

        showBackTitleBarView()

        event_dtl()
    }





    // MARK: - CONN EVENT DETAIL

    var pstSn: Int?

    @IBOutlet weak var iv_rprs : UIImageView!
    @IBOutlet weak var lb_pstTtl : UILabel!
    @IBOutlet weak var wv_pstCn : WKWebView!
    @IBOutlet weak var cr_wvPstCnHeight : NSLayoutConstraint!

    func event_dtl() {
        self.startLoading()

        let request = EventDtlListRequest(pstSn: pstSn!)
        BBSAPI.eventDtlList(request: request) { eventListData, error in
            self.stopLoading()

            if let data = eventListData {
                self.iv_rprs.af.setImage(
                    withURL: URL(string: data.rprsImgURL)!,
                    placeholderImage: nil,
                    filter: AspectScaledToFillSizeFilter(size: self.iv_rprs.frame.size)
                )

                self.lb_pstTtl.text = data.pstTTL

                self.wv_pstCn.backgroundColor = UIColor.clear
                self.wv_pstCn.isOpaque = false
                self.wv_pstCn.navigationDelegate = self
                self.wv_pstCn.loadHTMLString(data.pstCN, baseURL: nil)
                //                self.wv_pstCn.loadHTMLString(String("\(event.pstCN)<br>\(event.pstCN)"), baseURL: nil)
            }

            self.processNetworkError(error)
        }
    }





    // MARK: - Back TitleBar

    @IBOutlet weak var titleBarView : UIView!

    func showBackTitleBarView() {
        if let view = UINib(nibName: "BackTitleBarView", bundle: nil).instantiate(withOwner: self).first as? BackTitleBarView {
            view.frame = titleBarView.bounds
            view.lb_title.text = "이벤트"
            view.delegate = self
            titleBarView.addSubview(view)
            self.title = view.lb_title.text
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideBackTitleBarView()
    }
}





extension EventDetailViewController: BackTitleBarViewProtocol {
    func onBack() {
        navigationController?.popViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
}




// MARK: - WebView Delegate

extension EventDetailViewController: WKNavigationDelegate {
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
