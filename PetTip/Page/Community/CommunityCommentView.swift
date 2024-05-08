//
//  CommentView.swift
//  Test
//
//  Created by carebiz on 12/22/23.
//

import UIKit
import AlamofireImage

class CommunityCommentView: UIView {

    @IBOutlet weak var vw_bg: UIView!
    @IBOutlet weak var vw_commentArea: UIStackView!
    @IBOutlet weak var wv_sep: UIView!

    @IBOutlet weak var vw_profIvBorder: UIView!
    @IBOutlet weak var iv_prof: UIImageView!
    @IBOutlet weak var lb_nm: UILabel!
    @IBOutlet weak var lb_dt: UILabel!
    @IBOutlet weak var lb_msg: UILabel!
    @IBOutlet weak var lb_replyBtnTtl: UILabel!
    @IBOutlet weak var btn_replyBtn: UIControl!

    @IBOutlet weak var iv_likeBtn: UIImageView!
    @IBOutlet weak var lb_likeBtn: UILabel!
    @IBOutlet weak var btn_likeBtn: UIButton!

    @IBOutlet weak var iv_dislikeBtn: UIImageView!
    @IBOutlet weak var lb_dislikeBtn: UILabel!
    @IBOutlet weak var btn_dislikeBtn: UIButton!

    @IBOutlet weak var cr_replyBtnAreaWidth: NSLayoutConstraint!
    @IBOutlet weak var vw_replyBtnArea: UIView!

    @IBOutlet weak var cr_replyBtnHeight: NSLayoutConstraint!

    @IBOutlet weak var lb_modify: UILabel!
    @IBOutlet weak var lb_delete: UILabel!

    @IBOutlet weak var cr_topMargin: NSLayoutConstraint!
    @IBOutlet weak var cr_bottomMargin: NSLayoutConstraint!

    @IBOutlet weak var vw_menu_changedArea: UIView!

    @IBOutlet weak var cr_menu1_height: NSLayoutConstraint!
    @IBOutlet weak var vw_menu1: UIView!

    @IBOutlet weak var cr_menu2_height: NSLayoutConstraint!
    @IBOutlet weak var vw_menu2: UIView!

    @IBOutlet weak var cr_menu3_height: NSLayoutConstraint!
    @IBOutlet weak var vw_menu3: UIView!

    var isReplyMode: Bool!
    var data: CommentData!
    var atchPath: String = ""
    var rootView: UIView!
    var delegate: CommunityCommentViewDelegate!

    var parentCommentView: CommunityCommentView?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func initialize(_isReplyMode: Bool, _data: CommentData, _atchPath: String, _rootView: UIView, _delegate: CommunityCommentViewDelegate) {
        isReplyMode = _isReplyMode
        data = _data
        atchPath = _atchPath
        rootView = _rootView
        delegate = _delegate

        iv_prof.layer.cornerRadius = iv_prof.bounds.size.width / 2
        iv_prof.layer.masksToBounds = true

        vw_profIvBorder.backgroundColor = UIColor.white
        vw_profIvBorder.layer.borderWidth = 1
        vw_profIvBorder.layer.cornerRadius = vw_profIvBorder.bounds.size.width / 2
        vw_profIvBorder.layer.borderColor = UIColor.init(hex: "#4E608526")?.cgColor
        vw_profIvBorder.showShadowMid()

        self.setPetImage(imageView: iv_prof, pet: data.comment)

        lb_nm.text = data.comment.petNm != nil ? data.comment.petNm : " - "
        lb_dt.text = data.comment.lastStrgDt
        lb_msg.text = data.comment.cmntCN

        iv_likeBtn.image = UIImage(named: "icon_like_default")
        if data.comment.myCmntRcmdtn != nil && data.comment.myCmntRcmdtn == "001" {
            iv_likeBtn.image = UIImage(named: "icon_like")
            btn_likeBtn.isSelected = true
        }
        lb_likeBtn.text = String(data.comment.rcmdtnCnt)

        iv_dislikeBtn.image = UIImage(named: "icon_dislike_default")
        if data.comment.myCmntRcmdtn != nil && data.comment.myCmntRcmdtn == "002" {
            iv_dislikeBtn.image = UIImage(named: "icon_dislike")
            btn_dislikeBtn.isSelected = true
        }
        lb_dislikeBtn.text = String(data.comment.nrcmdtnCnt)

        if isReplyMode == true {
            setReplyExpandAreaHide()

            vw_replyBtnArea.isHidden = true
            cr_replyBtnAreaWidth.constant = 0

            cr_topMargin.constant = 5
            cr_bottomMargin.constant = 5

            wv_sep.isHidden = true

        } else {
            if data.reply.count > 0 {
                setReplyBtnTtl(false, data.reply.count)
            } else {
                setReplyExpandAreaHide()
            }
        }

        stateDelete()
        initMenu()
    }

    func stateDelete() {
        if data.comment.delYn == "Y" {
            lb_msg.text = data.comment.cmntCN

            let lineView = UIView(
                frame: CGRect(x: 5,
                              y: lb_modify.bounds.size.height / 2,
                              width: lb_modify.bounds.size.width - 10,
                              height: 1
                )
            )
            lineView.backgroundColor = UIColor.gray
            lb_modify.addSubview(lineView)

            let lineView1 = UIView(
                frame: CGRect(x: 5,
                              y: lb_delete.bounds.size.height / 2,
                              width: lb_delete.bounds.size.width - 10,
                              height: 1
                )
            )
            lineView1.backgroundColor = UIColor.gray
            lb_delete.addSubview(lineView1)
        }
    }

    var menuIdx = 0

    func initMenu() {
        menuIdx = 0

        cr_menu1_height.constant = 17
        cr_menu2_height.constant = 0
        cr_menu3_height.constant = 0

        vw_menu1.isHidden = false
        vw_menu2.isHidden = true
        vw_menu3.isHidden = true
    }

    @IBAction func onChangeMenu(_ sender: Any) {
        if menuIdx == 0 {
            if UserDefaults.standard.value(forKey: "userId") as! String == data.comment.userID {
                menuIdx = 1
            } else {
                menuIdx = 2
            }
        } else {
            menuIdx = 0
        }

        if menuIdx == 0 {
            UIView.transition(with: self.vw_menu_changedArea, duration: 0.25, options: [.transitionFlipFromBottom], animations: {
                self.cr_menu1_height.constant = 17
                self.cr_menu2_height.constant = 0
                self.cr_menu3_height.constant = 0

                self.vw_menu1.isHidden = false
                self.vw_menu2.isHidden = true
                self.vw_menu3.isHidden = true
            }, completion: nil)

        } else if menuIdx == 1 {
            UIView.transition(with: self.vw_menu_changedArea, duration: 0.25, options: [.transitionFlipFromBottom], animations: {
                self.cr_menu1_height.constant = 0
                self.cr_menu2_height.constant = 17
                self.cr_menu3_height.constant = 0

                self.vw_menu1.isHidden = true
                self.vw_menu2.isHidden = false
                self.vw_menu3.isHidden = true
            }, completion: nil)

        } else if menuIdx == 2 {
            UIView.transition(with: self.vw_menu_changedArea, duration: 0.25, options: [.transitionFlipFromBottom], animations: {
                self.cr_menu1_height.constant = 0
                self.cr_menu2_height.constant = 0
                self.cr_menu3_height.constant = 17

                self.vw_menu1.isHidden = true
                self.vw_menu2.isHidden = true
                self.vw_menu3.isHidden = false
            }, completion: nil)
        }
    }

    @IBAction func onLike(_ sender: Any) {
        if btn_likeBtn.isSelected {
            return
        }

        if let delegate = delegate {
            delegate.onReplyLike(cmntNo: data.comment.cmntNo, schUnqNo: data.comment.schUnqNo, view: self)
        }
    }

    @IBAction func onDislike(_ sender: Any) {
        if btn_dislikeBtn.isSelected {
            return
        }

        if let delegate = delegate {
            delegate.onReplyDislike(cmntNo: data.comment.cmntNo, schUnqNo: data.comment.schUnqNo, view: self)
        }
    }

    @IBAction func onReply(_ sender: Any) {
        if let delegate = delegate {
            delegate.onReplyComment(cmntNo: data.comment.cmntNo, petNm: data.comment.petNm, view: self)
        }
    }

    @IBAction func onModify(_ sender: Any) {
        if data.comment.delYn == "Y" {
            return
        }

        if let delegate = delegate {
            delegate.onModifyComment(cmntNo: data.comment.cmntNo, view: self)
        }
    }

    @IBAction func onDelete(_ sender: Any) {
        if data.comment.delYn == "Y" {
            return
        }

        if let delegate = delegate {
            delegate.onDeleteComment(cmntNo: data.comment.cmntNo, view: self)
        }
    }

    @IBAction func onReport(_ sender: Any) {



        if let delegate = delegate {
            delegate.onReportComment(cmntNo: data.comment.cmntNo)
        }
    }

    func setReplyExpandAreaHide() {
        btn_replyBtn.isHidden = true
        cr_replyBtnHeight.constant = 0
    }

    private func setReplyBtnTtl(_ isOpenState: Bool, _ replyCnt: Int) {
        lb_replyBtnTtl.text = isOpenState ? "└ 답글접기" : String("└ 답글 \(replyCnt)개")

        btn_replyBtn.isHidden = false
        cr_replyBtnHeight.constant = 18
    }

    func addReplyComment(isUpdateReplyCnt: Bool, data: CommentData) {
        if isUpdateReplyCnt {
            setReplyBtnTtl(true, data.reply.count)
        }

        if let subView = UINib(nibName: "CommunityCommentView", bundle: nil).instantiate(withOwner: self).first as? CommunityCommentView
        {
            subView.initialize(_isReplyMode: true,
                               _data: data,
                               _atchPath: self.atchPath,
                               _rootView: self.rootView,
                               _delegate: self)

            UIView.animate(withDuration: 0.25) {
                self.vw_commentArea.addArrangedSubview(subView)
                self.rootView.layoutIfNeeded()
            }

            subView.parentCommentView = self
        }
    }

    @IBAction func onChangeReplyShowing(_ sender: Any) {
        if vw_commentArea.subviews.count == 0 {
            for i in 0..<data.reply.count {
                addReplyComment(isUpdateReplyCnt: i == 0, data: data.reply[i])
            }
        } else {
            UIView.animate(withDuration: 0.25) {
                for i in 0..<self.vw_commentArea.subviews.count {
                    self.vw_commentArea.subviews[i].isHidden.toggle()
                }
            } completion: { flag in
                self.setReplyBtnTtl(self.vw_commentArea.subviews[0].isHidden != true, self.data.reply.count)
            }
        }
    }
}

protocol CommunityCommentViewDelegate {
    func onReplyLike(cmntNo: Int, schUnqNo: Int, view: CommunityCommentView)
    func onReplyDislike(cmntNo: Int, schUnqNo: Int, view: CommunityCommentView)
    func onDeleteComment(cmntNo: Int, view: CommunityCommentView)
    func onModifyComment(cmntNo: Int, view: CommunityCommentView)
    func onReplyComment(cmntNo: Int, petNm: String?, view: CommunityCommentView)
    func onReportComment(cmntNo: Int)
}

// MARK: - COMMENT VIEW DELEGATE
extension CommunityCommentView: CommunityCommentViewDelegate {
    func onReplyComment(cmntNo: Int, petNm: String?, view: CommunityCommentView) {

    }

    func onReplyLike(cmntNo: Int, schUnqNo: Int, view: CommunityCommentView) {
        if delegate != nil {
            delegate.onReplyLike(cmntNo: cmntNo, schUnqNo: schUnqNo, view: view)
        }
    }

    func onReplyDislike(cmntNo: Int, schUnqNo: Int, view: CommunityCommentView) {
        if delegate != nil {
            delegate.onReplyDislike(cmntNo: cmntNo, schUnqNo: schUnqNo, view: view)
        }
    }

    func onDeleteComment(cmntNo: Int, view: CommunityCommentView) {
        if delegate != nil {
            delegate.onDeleteComment(cmntNo: cmntNo, view: view)
        }
    }

    func onModifyComment(cmntNo: Int, view: CommunityCommentView) {
        if delegate != nil {
            delegate.onModifyComment(cmntNo: cmntNo, view: view)
        }
    }

    func onReportComment(cmntNo: Int) {
        if delegate != nil {
            delegate.onReportComment(cmntNo: cmntNo)
        }
    }
}
