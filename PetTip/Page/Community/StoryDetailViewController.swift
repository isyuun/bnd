//
//  StoryDetailViewController.swift
//  PetTip
//
//  Created by carebiz on 12/19/23.
//

import UIKit
import AlamofireImage

class StoryDetailViewController: CommonDetailViewController {

    @IBOutlet weak var sv_content: UIScrollView!

    @IBOutlet weak var lb_ttl: UILabel!
    @IBOutlet weak var vw_profIvBorder: UIView!
    @IBOutlet weak var iv_repPetProf: UIImageView!
    @IBOutlet weak var lb_repPetNm: UILabel!
    @IBOutlet weak var lb_writeDt: UILabel!

    @IBOutlet weak var lb_likeCnt: UILabel!
    @IBOutlet weak var lb_CmtCnt: UILabel!

    @IBOutlet weak var vw_storyModifyDeleteBtnArea: UIView!
    @IBOutlet weak var vw_storyReportBtnArea: UIView!
    @IBOutlet weak var cr_width_reportBtnArea: NSLayoutConstraint!

    @IBOutlet weak var cr_height_imageArea: NSLayoutConstraint!
    @IBOutlet weak var sv_img: UIScrollView!
    @IBOutlet weak var pc_img: UIPageControl!

    @IBOutlet weak var cr_height_walkInfoArea: NSLayoutConstraint!
    @IBOutlet weak var vw_walkInfoArea: UIView!
    @IBOutlet weak var lb_walkDt: UILabel!
    @IBOutlet weak var lb_walkTime: UILabel!
    @IBOutlet weak var lb_walkDist: UILabel!

    @IBOutlet weak var cr_msgAreaHeight: NSLayoutConstraint!
    @IBOutlet weak var vw_msgArea: UIView!
    @IBOutlet weak var lb_msg: UILabel!

    @IBOutlet weak var cr_tagAreaHeight: NSLayoutConstraint!
    @IBOutlet weak var vw_tagArea: UIView!
    @IBOutlet weak var lb_tag: UILabel!

    @IBOutlet weak var lb_CmtCnt2: UILabel!

    @IBOutlet weak var cr_commentAreaHeight: NSLayoutConstraint!
    @IBOutlet weak var vw_commentArea: UIStackView!

    @IBOutlet weak var tv_comment: UITextView!

    @IBOutlet weak var cr_replyTargetAreaHeight: NSLayoutConstraint!
    @IBOutlet weak var lb_replyTarget: UILabel!

    @IBOutlet weak var btn_like: UIButton!
    @IBOutlet weak var btn_dislike: UIButton!

    @IBOutlet weak var vw_rlsUpdateArea: UIView!
    @IBOutlet weak var iv_rlsUpdate: UIImageView!
    @IBOutlet weak var lb_rlsUpdate: UILabel!

    var storyListViewController: StoryListViewController?

    let textViewPlaceHolder = "댓글을 남겨보세요"

    var isRequireRefresh = false

    override func viewDidLoad() {
        super.viewDidLoad()

        showCommonUI()

        requestLifeViewData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueStoryDetailToModify") {
            let dest = segue.destination
            guard let vc = dest as? StoryModViewController else { return }
            vc.storyDetailViewController = self
            vc.lifeViewData = lifeViewData
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true

        if isRequireRefresh {
            requestLifeViewData()
        }
    }

    private func showCommonUI() {
        lb_title?.text = "스토리"
        self.title = lb_title?.text

        iv_repPetProf.layer.cornerRadius = iv_repPetProf.bounds.size.width / 2
        iv_repPetProf.layer.masksToBounds = true

        vw_profIvBorder.backgroundColor = UIColor.white
        vw_profIvBorder.layer.borderWidth = 1
        vw_profIvBorder.layer.cornerRadius = vw_profIvBorder.bounds.size.width / 2
        vw_profIvBorder.layer.borderColor = UIColor.init(hex: "#4E608526")?.cgColor
        vw_profIvBorder.showShadowMid()

        tv_comment.text = textViewPlaceHolder
        tv_comment.delegate = self

        let tapRec = UITapGestureRecognizer(target: self, action: #selector(tap(_:)))
        self.view.addGestureRecognizer(tapRec)

        cr_replyTargetAreaHeight.constant = 0

        btn_like.layer.borderWidth = 1
        btn_like.layer.cornerRadius = 10
        btn_like.layer.borderColor = UIColor.init(hex: "#4E608526")?.cgColor

        btn_dislike.layer.borderWidth = 1
        btn_dislike.layer.cornerRadius = 10
        btn_dislike.layer.borderColor = UIColor.init(hex: "#4E608526")?.cgColor
    }

    func reqRefreshStoryList() {
        storyListViewController?.isRequireRefresh = true
    }

    @objc private func tap(_ sender: Any) {
        self.view.endEditing(true)
    }

    @IBAction func onLike(_ sender: Any) {
        if btn_like.isSelected || btn_dislike.isSelected {
            return
        }

        if btn_like.isSelected == false {
            rcmdtn(rcmdtnSeCd: "001", schUnqNo: schUnqNo!, targetBtn: btn_like)
        }
    }

    @IBAction func onDislike(_ sender: Any) {
        if btn_like.isSelected || btn_dislike.isSelected {
            return
        }

        if btn_dislike.isSelected == false {
            rcmdtn(rcmdtnSeCd: "002", schUnqNo: schUnqNo!, targetBtn: btn_dislike)
        }
    }

    // MARK: - PUBLIC or PRIVATE STATE
    var rlsYn: String!

    func initRls() {
        rlsYn = lifeViewData.rlsYn

        if UserDefaults.standard.value(forKey: "userId") as! String == lifeViewData.userID {
            vw_rlsUpdateArea.isHidden = false

            if rlsYn == "Y" {
                iv_rlsUpdate.image = UIImage(systemName: "eye")
                lb_rlsUpdate.text = "공개"

            } else {
                iv_rlsUpdate.image = UIImage(systemName: "lock")
                lb_rlsUpdate.text = "비공개"
            }

        } else {
            vw_rlsUpdateArea.isHidden = true
        }
    }

    @IBAction func onRlsUpdate(_ sender: Any) {
        rls_update()
    }

    private func rls_update() {
        self.startLoading()

        let request = RlsUpdateRequest(rlsYn: rlsYn == "Y" ? "N" : "Y", schUnqNo: lifeViewData.schUnqNo)
        DailyLifeAPI.rlsUpdate(request: request) { rlsUpdate, error in
            self.stopLoading()

            if rlsUpdate != nil && error == nil {
                if self.rlsYn == "Y" {
                    self.rlsYn = "N"

                    UIView.transition(with: self.vw_rlsUpdateArea, duration: 0.25, options: [.transitionFlipFromBottom], animations: {
                        self.iv_rlsUpdate.image = UIImage(systemName: "lock")
                        self.lb_rlsUpdate.text = "비공개"
                    }, completion: { _ in
                        self.showToast(msg: "비공개 처리 되었습니다")
                    })

                } else {
                    self.rlsYn = "Y"

                    UIView.transition(with: self.vw_rlsUpdateArea, duration: 0.25, options: [.transitionFlipFromBottom], animations: {
                        self.iv_rlsUpdate.image = UIImage(systemName: "eye")
                        self.lb_rlsUpdate.text = "공개"
                    }, completion: { _ in
                        self.showToast(msg: "공개 처리 되었습니다")
                    })
                }
            }

            self.processNetworkError(error)
        }
    }

    // MARK: - DELETE STORY
    @IBAction func onDeleteStory(_ sender: Any) {
        let commonConfirmView = UINib(nibName: "CommonConfirmView", bundle: nil).instantiate(withOwner: self).first as! CommonConfirmView
        commonConfirmView.initialize(title: "게시글 삭제하기", msg: "정말 삭제하시겠어요?", cancelBtnTxt: "취소", okBtnTitleTxt: "삭제하기")
        commonConfirmView.didTapOK = {
            self.didTapPopupOK()
            self.story_delete()
        }
        commonConfirmView.didTapCancel = {
            self.didTapPopupCancel()
        }

        popupShow(contentView: commonConfirmView, wSideMargin: 40)
    }

    func story_delete() {
        self.startLoading()

        let request = LifeUpdateRequest(cmntUseYn: "Y",
                                        delYn: "Y",
                                        rcmdtnYn: "Y",
                                        rlsYn: "Y",
                                        schTtl: lb_ttl.text!,
                                        schUnqNo: schUnqNo!,
                                        schCn: nil,
                                        dailyLifePetList: nil,
                                        dailyLifeFileList: nil,
                                        dailyLifeSchSeList: nil,
                                        dailyLifeSchHashTagList: nil)
        DailyLifeAPI.update(request: request) { lifeView, error in
            self.stopLoading()
            self.processNetworkError(error)

            if lifeView != nil && error == nil {
                self.reqRefreshStoryList()
                self.onBack()
            } else {
                self.showToast(msg: "다시 시도해주세요")
            }
        }
    }

    // MARK: - CONN LIKE/DISLIKE
    private func rcmdtn(rcmdtnSeCd: String, schUnqNo: Int, targetBtn: UIButton) {
        self.startLoading()

        let request = RcmdtnRequest(rcmdtnSeCd: rcmdtnSeCd, schUnqNo: schUnqNo)
        DailyLifeAPI.rcmdtn(request: request) { lifeView, error in
            self.stopLoading()
            self.processNetworkError(error)

            if lifeView != nil && error == nil {
                targetBtn.isSelected = true
            } else {
                self.showToast(msg: "다시 시도해주세요")
            }
        }
    }

    // MARK: - CONN COMMENT LIKE/DISLIKE
    private func cmnt_rcmdtn(cmntNo: Int, rcmdtnSeCd: String, schUnqNo: Int, view: CommunityCommentView) {
        self.startLoading()

        let request = CmntRcmdtnRequest(cmntNo: cmntNo, rcmdtnSeCd: rcmdtnSeCd, schUnqNo: schUnqNo)
        DailyLifeAPI.cmntRcmdtn(request: request) { cmntRcmdtn, error in
            self.stopLoading()
            self.processNetworkError(error)

            if cmntRcmdtn != nil && error == nil {
                if rcmdtnSeCd == "001" {
                    view.iv_likeBtn.image = UIImage(named: "icon_like")
                    view.lb_likeBtn.text = String(Int(view.lb_likeBtn.text!)! + 1)
                    view.btn_likeBtn.isSelected = true

                } else if rcmdtnSeCd == "002" {
                    view.iv_dislikeBtn.image = UIImage(named: "icon_dislike")
                    view.lb_dislikeBtn.text = String(Int(view.lb_dislikeBtn.text!)! + 1)
                    view.btn_dislikeBtn.isSelected = true
                }
            } else {
                self.showToast(msg: "다시 시도해주세요")
            }
        }
    }

    // MARK: - CONN COMMENT DELETE
    private func cmnt_delete(cmntNo: Int, view: CommunityCommentView) {
        self.startLoading()

        let request = CmntDeleteRequest(cmntNo: cmntNo)
        DailyLifeAPI.cmntDelete(request: request) { cmntDelete, error in
            self.stopLoading()
            self.processNetworkError(error)

            if error == nil {
                if let data = cmntDelete?.data {
                    self.lb_CmtCnt.text = String(data.count)
                    self.lb_CmtCnt2.text = String("댓글 \(data.count)")
                } else {
                    self.lb_CmtCnt.text = "0"
                    self.lb_CmtCnt2.text = String("댓글 0")
                }

                if view.isReplyMode {
                    UIView.animate(withDuration: 0.25) {
                        view.isHidden.toggle()
                        view.layoutIfNeeded()
                    } completion: { flag in
                        if let parentCommentView = view.parentCommentView {
                            var reply = parentCommentView.data.reply
                            for i in 0..<reply.count {
                                if reply[i].comment.cmntNo == cmntNo {
                                    reply.remove(at: i)
                                    parentCommentView.data.reply = reply
                                    break
                                }
                            }
                            if view.lb_replyBtnTtl.text!.contains("개") {
                                view.lb_replyBtnTtl.text = String("└ 답글 \(reply.count)개")
                            }

                            if view.parentCommentView?.data.reply.count == 0 {
                                view.parentCommentView?.setReplyExpandAreaHide()
                            }

                            view.removeFromSuperview()
                        }
                    }

                } else {
                    UIView.animate(withDuration: 0.25) {
                        view.isHidden.toggle()
                        view.layoutIfNeeded()
                    } completion: { _ in
                        for i in 0..<self.arrComment.count {
                            if view.data.comment.cmntNo == self.arrComment[i].comment.cmntNo {
                                self.arrComment.remove(at: i)
                                break
                            }
                        }
                        view.removeFromSuperview()
                    }
                }

            } else {
                self.showToast(msg: "다시 시도해주세요")
            }
        }
    }

    // MARK: - CONN COMMENT UPDATE
    internal func cmnt_update(cmntNo: Int, cmntCn: String, view: CommunityCommentView) {
        self.startLoading()

        let request = CmntUpdateRequest(cmntCn: cmntCn, cmntNo: cmntNo)
        DailyLifeAPI.cmntUpdate(request: request) { cmntUpdate, error in
            self.stopLoading()
            self.processNetworkError(error)

            if cmntUpdate != nil && error == nil {
                if let data = cmntUpdate?.data {
                    for i in 0..<data.count {
                        if data[i].cmntNo == cmntNo {
                            view.data.comment = data[i]
                            break
                        }
                    }

                    UIView.animate(withDuration: 0.25) {
                        view.lb_msg.text = cmntCn
                        view.layoutIfNeeded()
                    }
                }
            } else {
                self.showToast(msg: "다시 시도해주세요")
            }
        }
    }

    // MARK: - WRITE COMMENT
    @IBOutlet weak var btn_writeComment: UIButton!

    var upCmntNo: Int = 0

    @IBAction func onWriteComment(_ sender: Any) {
        if tv_comment.text.count > 0 && tv_comment.text != textViewPlaceHolder {
            cmnt_create()
        }
    }

    @IBAction func onCancelReplyComment(_ sender: Any) {
        self.upCmntNo = 0
        self.lb_replyTarget.text = ""
        UIView.animate(withDuration: 0.25) {
            self.cr_replyTargetAreaHeight.constant = 0
            self.view.layoutIfNeeded()
        }
    }

    private func finishWriteReply() {
        self.tv_comment.text = ""
        self.tv_comment.resignFirstResponder()

        onCancelReplyComment(self)
    }

    private func cmnt_create() {

        // 1. 통신 후 가져온 댓글 목록을 순차적으로 돌다가, lastCmntNo 이후의 것을 받아서 별도 배열에 저장
        // 2. 별도 배열에 저장된 것은 현재 출력된 댓글 이후로 추가된 댓글임
        // 3. 추가된 댓글 배열 내용을 arrComment에 그 순서에 맞게 append
        // 4. 추가된 댓글 배열대로 for문을 돌면서 알맞는 구역에 새로운 댓글 뷰 컴포넌트 추가

        self.startLoading()

        let request = CmntCreateRequest(cmntCn: tv_comment.text, petRelUnqNo: Global.petRelUnqNo, schUnqNo: schUnqNo!, upCmntNo: upCmntNo)
        DailyLifeAPI.cmntCreate(request: request) { cmntCreate, error in
            self.stopLoading()

            if let cmntCreate = cmntCreate {
                if let cmntList = cmntCreate.cmntList, cmntList.count > 0 {

                    self.lb_CmtCnt.text = String(cmntList.count)
                    self.lb_CmtCnt2.text = String("댓글 \(cmntList.count)")

                    var arrNewCmntList = [CmntList]()
                    for item in cmntList {
                        if item.cmntNo > self.lastCmntNo {
                            arrNewCmntList.append(item)
                        }
                    }

                    if arrNewCmntList.count > 0 {
                        for cmnt in arrNewCmntList {
                            let comment = CommentData(comment: cmnt, reply: [CommentData]())

                            if cmnt.cmntNo == cmnt.upCmntNo {
                                self.arrComment.append(comment)

                                if self.vw_commentArea.subviews.count == 0 {
                                    // self.cr_msgAreaHeight.isActive = false
                                    self.cr_commentAreaHeight.priority = .defaultLow
                                }

                                if let view = UINib(nibName: "CommunityCommentView", bundle: nil).instantiate(withOwner: self).first as? CommunityCommentView
                                {
                                    view.initialize(_isReplyMode: false,
                                                    _data: comment,
                                                    _atchPath: self.atchPath,
                                                    _rootView: self.view,
                                                    _delegate: self)

                                    UIView.animate(withDuration: 0.25) {
                                        self.vw_commentArea.addArrangedSubview(view)
                                        view.layoutIfNeeded()
                                    } completion: { Bool in
                                        self.finishWriteReply()
                                    }
                                }

                            } else {
                                for i in 0..<self.arrComment.count {
                                    if cmnt.upCmntNo == self.arrComment[i].comment.cmntNo {
                                        self.arrComment[i].reply.append(comment)

                                        let communityCommentView = self.vw_commentArea.subviews[i] as! CommunityCommentView

                                        if communityCommentView.data.reply.count > 0
                                            && (communityCommentView.vw_commentArea.subviews.count == 0
                                                || communityCommentView.vw_commentArea.subviews[0].isHidden == true) {

                                            communityCommentView.onChangeReplyShowing(self)
                                        }

                                        communityCommentView.addReplyComment(isUpdateReplyCnt: true, data: comment)
                                        communityCommentView.data = self.arrComment[i]

                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                                            self.finishWriteReply()
                                        })

                                        break
                                    }
                                }
                            }

                            if (cmnt.cmntNo > self.lastCmntNo) {
                                self.lastCmntNo = cmnt.cmntNo
                            }
                        }
                    }
                }
            }

            self.processNetworkError(error)
        }
    }

    // MARK: - TARGET LIFE VIEW DATA
    var schUnqNo: Int? = 0

    var slides: [CommonDetailImageItemView]!

    var lifeViewData: LifeViewData!
    var arrComment = [CommentData]()
    var lastCmntNo = 0

    var atchPath: String = ""

    func requestLifeViewData() {
        if let schUnqNo = schUnqNo {
            self.startLoading()

            let request = LifeViewRequest(cmntYn: "Y", schUnqNo: schUnqNo)
            DailyLifeAPI.view(request: request) { lifeView, error in
                self.stopLoading()

                if let lifeView = lifeView {
                    self.dailylife_update(lifeView: lifeView)
                }

                self.processNetworkError(error)
            }
        }
    }

    func dailylife_update(lifeView: LifeView) {
        self.lifeViewData = lifeView.lifeViewData

        self.atchPath = lifeView.lifeViewData.atchPath

        self.lb_ttl.text = lifeView.lifeViewData.schTTL
        self.lb_writeDt.text = lifeView.lifeViewData.rlsDt

        self.initRls()

        self.lb_likeCnt.text = String(lifeView.lifeViewData.rcmdtnCnt)
        self.lb_CmtCnt.text = String(lifeView.lifeViewData.cmntCnt)
        self.lb_CmtCnt2.text = String("댓글 \(lifeView.lifeViewData.cmntCnt)")
        self.btn_like.isSelected = lifeView.lifeViewData.myRcmdtn != nil && lifeView.lifeViewData.myRcmdtn == "001"
        self.btn_dislike.isSelected = lifeView.lifeViewData.myRcmdtn != nil && lifeView.lifeViewData.myRcmdtn == "002"

        if UserDefaults.standard.value(forKey: "userId") as! String == lifeView.lifeViewData.userID {
            self.vw_storyModifyDeleteBtnArea.isHidden = false
            self.vw_storyReportBtnArea.isHidden = true
            self.cr_width_reportBtnArea.constant = 0
        } else {
            self.vw_storyModifyDeleteBtnArea.isHidden = true
            self.vw_storyReportBtnArea.isHidden = false
        }

        if let petList = lifeView.lifeViewData.dailyLifePetList {
            if petList.count > 0 {
                let pet = petList[0]
                Global2.setPetImage(imageView: self.iv_repPetProf, petTypCd: pet.petTypCd, petImgAddr: pet.petImg)

                self.lb_repPetNm.text = petList[0].petNm
            }
        }

        if let fileList = lifeView.lifeViewData.dailyLifeFileList {
            if (fileList.count > 0) {
                self.pc_img.isHidden = false
                self.cr_height_imageArea.constant = 286

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
                    slide.didTapImage = {
                        let vc = UIStoryboard.init(name: "Common", bundle: nil).instantiateViewController(withIdentifier: "ImageViewController") as! ImageViewController
                        vc.initialize(image: nil, strUrl: String("\(lifeView.lifeViewData.atchPath)\(fileList[i].filePathNm)\(fileList[i].atchFileNm)"))
                        self.navigationController?.pushViewController(vc, animated: true)
                    }

                    self.slides[i] = slide
                    self.sv_img.addSubview(self.slides[i])
                }

            } else {
                self.pc_img.isHidden = true
                self.cr_height_imageArea.constant = 0
            }
        } else {
            self.pc_img.isHidden = true
            self.cr_height_imageArea.constant = 0
        }

        var isWalk = false
        for dailyLifeSchSEList in lifeView.lifeViewData.dailyLifeSchSEList {
            if dailyLifeSchSEList.cdID == "001" {
                isWalk = true
                break
            }
        }
        if isWalk {
            if let walkDtStr = lifeView.lifeViewData.walkDptreDt {
                if walkDtStr.count > 0 {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let searchDay = formatter.date(from: walkDtStr)
                    if searchDay != nil {
                        let formatter2 = DateFormatter()
                        formatter2.dateFormat = "yyyy.MM.dd"
                        self.lb_walkDt.text = formatter2.string(from: searchDay!)
                    } else {
                        self.lb_walkDt.text = "0000.00.00"
                    }
                }

                self.lb_walkTime.text = lifeView.lifeViewData.runTime
                self.lb_walkDist.text = String(format: "%.1fkm", Float(lifeView.lifeViewData.runDstnc) / Float(1000.0))
            }
        } else {
            self.vw_walkInfoArea.isHidden = true
            self.vw_walkInfoArea.translatesAutoresizingMaskIntoConstraints = false
            self.cr_height_walkInfoArea.constant = 0
        }

        // if let schCN = lifeView.lifeViewData.schCN, schCN.count > 0, schCN != " " {
        //     self.lb_msg.preferredMaxLayoutWidth = self.lb_msg.frame.size.width
        //     self.lb_msg.text = lifeView.lifeViewData.schCN
        //     self.vw_msgArea.translatesAutoresizingMaskIntoConstraints = false
        //     self.vw_msgArea.isHidden = false
        //     self.vw_msgArea.heightAnchor.constraint(equalToConstant: 37).isActive = true
        //
        // } else {
        //     self.vw_msgArea.translatesAutoresizingMaskIntoConstraints = false
        //     self.vw_msgArea.isHidden = true
        //     self.vw_msgArea.heightAnchor.constraint(greaterThanOrEqualToConstant: 0).isActive = true
        // }

        if let dailyLifeSchHashTagList = lifeView.lifeViewData.dailyLifeSchHashTagList {
            var str = ""
            for i in 0..<dailyLifeSchHashTagList.count {
                if str != "" {
                    str += " "
                }
                str += String("#\(dailyLifeSchHashTagList[i].hashTagNm)")
            }
            self.lb_tag.preferredMaxLayoutWidth = self.lb_tag.frame.size.width
            self.lb_tag.text = str
            self.vw_tagArea.translatesAutoresizingMaskIntoConstraints = false
            self.vw_tagArea.isHidden = false
            self.vw_tagArea.heightAnchor.constraint(equalToConstant: 37).isActive = true

        } else {
            self.vw_tagArea.translatesAutoresizingMaskIntoConstraints = false
            self.vw_tagArea.isHidden = true
            self.vw_tagArea.heightAnchor.constraint(greaterThanOrEqualToConstant: 0).isActive = true
        }

        self.vw_commentArea.subviews.forEach({ $0.removeFromSuperview() })

        if lifeView.lifeViewData.cmntCnt > 0 {
            self.cr_commentAreaHeight.priority = .defaultLow

            if let _cmntList = lifeView.lifeViewData.cmntList {
                self.arrComment = [CommentData]()
                for cmnt in _cmntList {
                    // guard cmnt.delYn == "N" else {
                    //     continue
                    // }

                    if cmnt.cmntNo == cmnt.upCmntNo {
                        let commentData = CommentData(comment: cmnt, reply: [CommentData]())
                        self.arrComment.append(commentData)

                    } else {
                        for i in 0..<self.arrComment.count {
                            if self.arrComment[i].comment.cmntNo == cmnt.upCmntNo {
                                self.arrComment[i].reply.append(CommentData(comment: cmnt, reply: [CommentData]()))
                                break
                            }
                        }
                    }

                    if (cmnt.cmntNo > self.lastCmntNo) {
                        self.lastCmntNo = cmnt.cmntNo
                    }

                    // myRcmdtn 처리?
                    // myCmntRcmdtn ??
                }

                for i in 0..<self.arrComment.count {
                    let commentData = self.arrComment[i]

                    if let view = UINib(nibName: "CommunityCommentView", bundle: nil).instantiate(withOwner: self).first as? CommunityCommentView
                    {
                        view.initialize(_isReplyMode: false,
                                        _data: commentData,
                                        _atchPath: self.atchPath,
                                        _rootView: self.view,
                                        _delegate: self)

                        self.vw_commentArea.addArrangedSubview(view)
                    }
                }
            }

        } else {
            self.cr_commentAreaHeight.constant = 0
            self.cr_commentAreaHeight.priority = UILayoutPriority.init(1000)
        }
    }

    // MARK: - WRITE REPORT (dlcr_create)
    @IBAction func onReport(_ sender: Any) {
        writeReport(cmntNo: nil)
    }

    func writeReport(cmntNo: Int?) {
        Global3.code_list(cmmCdData: ["RSN"]) {
            self.removeKeyboardObserver()

            let reportView = UINib(nibName: "ReportView", bundle: nil).instantiate(withOwner: self).first as! ReportView
            reportView.initialize()
            reportView.didTapOK = { reasonId, cmnt in
                if reasonId == "" {
                    self.showSimpleAlert(msg: "신고 사유를 선택해주세요")
                } else if cmnt == "" {
                    self.showSimpleAlert(msg: "신고 내용을 입력해주세요")
                } else {
                    self.didTapPopupOK()
                    self.addKeyboardObserver()
                    self.dlcr_create(cmntNo: cmntNo, dclrCn: cmnt, dclrRsnCd: reasonId)
                }
            }
            reportView.didTapCancel = {
                self.didTapPopupCancel()
                self.addKeyboardObserver()
            }

            self.popupShow(contentView: reportView, wSideMargin: 20, isTapCancel: false)
        }
    }

    func dlcr_create(cmntNo: Int?, dclrCn: String, dclrRsnCd: String) {
        var _cmntNo = 0
        var _dclrSeCd = "001"
        if let cmntNo = cmntNo {
            _cmntNo = cmntNo
            _dclrSeCd = "002"
        }

        self.startLoading()

        let request = DclrCreateRequest(cmntNo: _cmntNo, dclrCn: dclrCn, dclrRsnCd: dclrRsnCd, dclrSeCd: _dclrSeCd, schUnqNo: self.schUnqNo!)

        if _cmntNo == 0 && _dclrSeCd == "001" {
            DailyLifeAPI.dclrCreateStory(request: request) { dclrCreateStory, error in
                self.stopLoading()
                self.processNetworkError(error)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    // if dclrCreateStory != nil {
                    //     if error?.resCode == 200 { self.showSimpleAlert(msg: "신고처리 되었습니다\n처리후 컴토까지 최대 24시간 소요됩니다.") }
                    // } else {
                    //     self.showSimpleAlert(msg: "다시 시도해주세요")
                    // }
                    if error?.resCode == 200 { self.showSimpleAlert(msg: "신고처리 되었습니다\n처리후 컴토까지 최대 24시간 소요됩니다.") }
                })
                NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][dclrCreateStory:\(String(describing: dclrCreateStory))]")
            }
        } else if _dclrSeCd == "002" {
            DailyLifeAPI.dclrCreateCmnt(request: request) { dclrCreateCmnt, error in
                self.stopLoading()
                self.processNetworkError(error)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    // if dclrCreateCmnt != nil {
                    //     if error?.resCode == 200 { self.showSimpleAlert(msg: "신고처리 되었습니다\n처리후 컴토까지 최대 24시간 소요됩니다.") }
                    // } else {
                    //     self.showSimpleAlert(msg: "다시 시도해주세요")
                    // }
                    if error?.resCode == 200 { self.showSimpleAlert(msg: "신고처리 되었습니다\n처리후 컴토까지 최대 24시간 소요됩니다.") }
                })
                NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][dclrCreateCmnt:\(String(describing: dclrCreateCmnt))]")
            }
        }
    }
}

// MARK: - COMMENT VIEW DELEGATE
extension StoryDetailViewController: CommunityCommentViewDelegate {
    func onReplyComment(cmntNo: Int, petNm: String?, view: CommunityCommentView) {
        upCmntNo = cmntNo
        lb_replyTarget.text = String("\(petNm!)에게 답글 쓰는중...")
        UIView.animate(withDuration: 0.25) {
            self.cr_replyTargetAreaHeight.constant = 36
            self.view.layoutIfNeeded()
        } completion: { Bool in
            let bottomOffset = CGPoint(x: 0, y: self.sv_content.contentSize.height - self.sv_content.bounds.height + self.sv_content.contentInset.bottom)
            if (bottomOffset.y > 0) {
                self.sv_content.setContentOffset(bottomOffset, animated: true)
            }

            self.tv_comment.becomeFirstResponder()
        }
    }

    func onReplyLike(cmntNo: Int, schUnqNo: Int, view: CommunityCommentView) {
        cmnt_rcmdtn(cmntNo: cmntNo, rcmdtnSeCd: "001", schUnqNo: schUnqNo, view: view)
    }

    func onReplyDislike(cmntNo: Int, schUnqNo: Int, view: CommunityCommentView) {
        cmnt_rcmdtn(cmntNo: cmntNo, rcmdtnSeCd: "002", schUnqNo: schUnqNo, view: view)
    }

    func onDeleteComment(cmntNo: Int, view: CommunityCommentView) {
        let commonConfirmView = UINib(nibName: "CommonConfirmView", bundle: nil).instantiate(withOwner: self).first as! CommonConfirmView
        commonConfirmView.initialize(title: "댓글 삭제하기", msg: "정말 삭제하시겠어요?", cancelBtnTxt: "취소", okBtnTitleTxt: "삭제하기")
        commonConfirmView.didTapOK = {
            self.didTapPopupOK()
            self.cmnt_delete(cmntNo: cmntNo, view: view)
        }
        commonConfirmView.didTapCancel = {
            self.didTapPopupCancel()
        }

        popupShow(contentView: commonConfirmView, wSideMargin: 40)
    }

    func onModifyComment(cmntNo: Int, view: CommunityCommentView) {
        removeKeyboardObserver()

        let commentModifyView = UINib(nibName: "CommentModifyView", bundle: nil).instantiate(withOwner: self).first as! CommentModifyView
        commentModifyView.initialize(data: view.data, atchPath: view.atchPath)
        commentModifyView.didTapOK = { cmntCn in
            self.didTapPopupOK()
            self.addKeyboardObserver()
            self.cmnt_update(cmntNo: cmntNo, cmntCn: cmntCn, view: view)
        }
        commentModifyView.didTapCancel = {
            self.didTapPopupCancel()
            self.addKeyboardObserver()
        }

        popupShow(contentView: commentModifyView, wSideMargin: 20)
    }

    func onReportComment(cmntNo: Int) {
        writeReport(cmntNo: cmntNo)
    }
}

// MARK: - SAVED COMMENT DATA CLASS
struct CommentData {
    var comment: CmntList
    var reply: [CommentData]
}

// MARK: - Comment Input TextViewDelegate
extension StoryDetailViewController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: textView.frame.size.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)

        guard textView.contentSize.height < 200.0 else {
            textView.isScrollEnabled = true
            return
        }

        let bottomOffset = CGPoint(x: 0, y: sv_content.contentSize.height - sv_content.bounds.height + sv_content.contentInset.bottom)
        if (bottomOffset.y > 0) {
            sv_content.setContentOffset(bottomOffset, animated: true)
        }

        textView.isScrollEnabled = false
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height > 40 ? estimatedSize.height : 40
            }
        }
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = UIColor.init(hex: "#FFB5B9BE")
        }
    }
}

// MARK: - IMAGE VIEW SCROLLVIEW DELEGATE
extension StoryDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
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
                slides[Int(pageIndex)].iv_img.transform = CGAffineTransform(scaleX: (transOffset - percentOffset.x) / CGFloat(itemOffset), y: (transOffset - percentOffset.x) / CGFloat(itemOffset))
                slides[Int(pageIndex) + 1].iv_img.transform = CGAffineTransform(scaleX: percentOffset.x / transOffset, y: percentOffset.x / transOffset)

            } else {
                slides[Int(pageIndex)].iv_img.transform = CGAffineTransform(scaleX: percentOffset.x, y: percentOffset.x)
            }
        }
    }
}
