//
//  QnADetailViewController.swift
//  PetTip
//
//  Created by carebiz on 1/11/24.
//

import UIKit
import WebKit

class QnADetailViewController: CommonViewController{
    
    public var didListChanged: (()-> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        
        showBackTitleBarView()
        
        showCommonUI()
        
        qna_dtl()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueQnADetailToModify") {
            let dest = segue.destination
            guard let vc = dest as? QnAModifyViewController else { return }
            vc.qnaQuestData = qnaQuestData
            vc.didDetailChanged = {
                self.qna_dtl()
            }
        }
    }
    
    
    
    
    
    @IBOutlet weak var lb_title : UILabel!
    @IBOutlet weak var lb_dt : UILabel!
    @IBOutlet weak var lb_detail : UILabel!
    
    @IBOutlet weak var vw_attachFileArea : UIView!
    @IBOutlet weak var cv_attachFile : UICollectionView!
    
    @IBOutlet weak var vw_notYetReplyMsgArea : UIView!
    @IBOutlet weak var vw_replyMsgArea : UIView!
    
    @IBOutlet weak var vw_replyIconBg : UIView!
    @IBOutlet weak var lb_replyTitle : UILabel!
    @IBOutlet weak var wv_replyPstCn : WKWebView!
    @IBOutlet weak var cr_wvPstCnHeight : NSLayoutConstraint!
    
    private func showCommonUI() {
        lb_title.textColor = UIColor.init(hex: "#FF222222")
        lb_dt.textColor = UIColor.init(hex: "#FF737980")
        lb_detail.textColor = UIColor.init(hex: "#FF222222")
        
        vw_replyIconBg.layer.cornerRadius = self.vw_replyIconBg.bounds.size.width / 2
    }
    
    
    
    
    
    // MARK: - CONN Q&A DETAIL
    
    var pstSn: Int?
    
    var qnaQuestData: QnADtlData?
    var atchPath = ""
    var arrFile = [File]()
    
    private func qna_dtl() {
        startLoading()
        
        let request = QnADtlListRequest(pstSn: pstSn!)
        BBSAPI.qnaDtlList(request: request) { data, error in
            self.stopLoading()
         
            if let dtlListData = data, let questData = dtlListData.data.first {
                self.qnaQuestData = questData
                
                self.lb_title.text = questData.pstTTL
                self.lb_dt.text = questData.frstInptDt
                self.lb_detail.text = questData.pstCN
                
                if let files = questData.files, files.count > 0 {
                    self.vw_attachFileArea.isHidden = false
                    
                    self.atchPath = questData.atchPath
                    self.arrFile = files
                    
                    let layout = self.cv_attachFile.collectionViewLayout as! UICollectionViewFlowLayout
                    layout.minimumLineSpacing = 5
                    layout.scrollDirection = .horizontal
                    self.cv_attachFile.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
                  
                    self.cv_attachFile.delegate = self
                    self.cv_attachFile.dataSource = self
                    
                    // 스크롤 시 빠르게 감속 되도록 설정
                    self.cv_attachFile.decelerationRate = UIScrollView.DecelerationRate.fast
                    
                    self.cv_attachFile.reloadData()
                    
                } else {
                    self.vw_attachFileArea.isHidden = true
                }
            }
            
            if let qnaDtlListData = data, qnaDtlListData.data.count > 1, let qnaAnswerData = qnaDtlListData.data.last {
                self.vw_notYetReplyMsgArea.isHidden = true
                self.vw_replyMsgArea.isHidden = false
                
                self.lb_replyTitle.text = qnaAnswerData.pstTTL
                
                self.wv_replyPstCn.backgroundColor = UIColor.clear
                self.wv_replyPstCn.isOpaque = false
                self.wv_replyPstCn.navigationDelegate = self
                self.wv_replyPstCn.loadHTMLString(qnaAnswerData.pstCN, baseURL: nil)
                
            } else {
                self.vw_notYetReplyMsgArea.isHidden = false
                self.vw_replyMsgArea.isHidden = true
            }
            
            self.processNetworkError(error)
        }
    }
    
    
    
    
    
    @IBAction func onDelete(_ sender: Any) {
        let commonConfirmView = UINib(nibName: "CommonConfirmView", bundle: nil).instantiate(withOwner: self).first as! CommonConfirmView
        commonConfirmView.initialize(title: "문의 삭제하기", msg: "정말 삭제하시겠어요?", cancelBtnTxt: "취소", okBtnTitleTxt: "삭제하기")
        commonConfirmView.didTapOK = {
            self.didTapPopupOK()
            self.qna_delete()
        }
        commonConfirmView.didTapCancel = {
            self.didTapPopupCancel()
        }
        
        popupShow(contentView: commonConfirmView, wSideMargin: 40)
    }
    
    func qna_delete() {
        guard let pstSn = pstSn else { return }
        
        startLoading()
        
        let request = QnADeleteRequest(pstSn: pstSn)
        BBSAPI.qnaDelete(request: request) { response, error in
            self.stopLoading()
            
            if response?.statusCode == 200 {
                self.didListChanged?()
                self.onBack()
            } else {
                self.showToast(msg: "다시 시도해주세요")
            }
            
            self.processNetworkError(error)
        }
    }
    
    
    
    
    
    // MARK: - Back TitleBar
    
    @IBOutlet weak var titleBarView : UIView!
    
    func showBackTitleBarView() {
        if let view = UINib(nibName: "BackTitleBarView", bundle: nil).instantiate(withOwner: self).first as? BackTitleBarView {
            view.frame = titleBarView.bounds
            view.lb_title.text = "1:1 문의"
            view.delegate = self
            titleBarView.addSubview(view)
        }
    }
}





extension QnADetailViewController: BackTitleBarViewProtocol {
    func onBack() {
        navigationController?.popViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
}





// MARK: - WebView Delegate

extension QnADetailViewController: WKNavigationDelegate {
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





// MARK: - Attach ImageFile CollectionView Delegate

extension QnADetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrFile.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "qnaDetailAttachFileItemView", for: indexPath) as! QnADetailAttachFileItemView
        cell.initialize(pathUri: atchPath, file: arrFile[indexPath.row])
        
        return cell
    }
}
