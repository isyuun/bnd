//
//  CommentModifyView.swift
//  PetTip
//
//  Created by carebiz on 12/28/23.
//

import UIKit
import AlamofireImage

class CommentModifyView: CommonPopupView {

    @IBOutlet weak var btn_cancel: UIButton!

    @IBOutlet weak var vw_originArea: UIView!
    @IBOutlet weak var vw_profIvBorder: UIView!
    @IBOutlet weak var iv_prof: UIImageView!
    @IBOutlet weak var lb_nm: UILabel!
    @IBOutlet weak var lb_dt: UILabel!
    @IBOutlet weak var lb_msg: UILabel!
    @IBOutlet weak var tv_msg: UITextView!
    @IBOutlet weak var vw_msg_underBorder: UIView!

    public var didTapOK: ((_ cmntCn: String) -> Void)?
    public var didTapCancel: (() -> Void)?

    let textViewPlaceHolder = "댓글을 남겨보세요"

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func initialize(data: CommentData, atchPath: String) {
        vw_originArea.layer.cornerRadius = 10
        vw_originArea.layer.borderWidth = 1
        vw_originArea.layer.borderColor = UIColor.init(hex: "#4E608533")?.cgColor
        vw_originArea.showShadowLight()

        iv_prof.layer.cornerRadius = iv_prof.bounds.size.width / 2
        iv_prof.layer.masksToBounds = true

        vw_profIvBorder.backgroundColor = UIColor.white
        vw_profIvBorder.layer.borderWidth = 1
        vw_profIvBorder.layer.cornerRadius = vw_profIvBorder.bounds.size.width / 2
        vw_profIvBorder.layer.borderColor = UIColor.init(hex: "#4E608533")?.cgColor
        vw_profIvBorder.showShadowMid()

        setPetImage(imageView: iv_prof, pet: data.comment)

        lb_nm.text = data.comment.petNm
        lb_dt.text = data.comment.lastStrgDt
        lb_msg.text = data.comment.cmntCN

        tv_msg.delegate = self
        tv_msg.text = data.comment.cmntCN
        textViewFitSize(tv_msg)
    }

    @IBAction func onClear(_ sender: Any) {
        tv_msg.text = ""
        textViewFitSize(tv_msg)
    }

    @IBAction func onModify(_ sender: Any) {
        if tv_msg.text.count > 0 {
            didTapOK?(tv_msg.text)
        }
    }

    @IBAction func onCancel(_ sender: Any) {
        didTapCancel?()
    }

    func textViewFitSize(_ textView: UITextView) {
        let size = CGSize(width: textView.frame.size.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)

        guard textView.contentSize.height < 200.0 else {
            textView.isScrollEnabled = true
            return
        }

        textView.isScrollEnabled = false
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height > 40 ? estimatedSize.height : 40
            }
        }

        if textView.text == textViewPlaceHolder {
            textView.textColor = UIColor.init(hex: "#FFB5B9BE")
        } else {
            textView.textColor = .black
        }
    }
}

// MARK: - TextViewDelegate
extension CommentModifyView: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        textViewFitSize(textView)
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .black
        }

        vw_msg_underBorder.isHidden = false
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = UIColor.init(hex: "#FFB5B9BE")
        }

        vw_msg_underBorder.isHidden = true
    }
}
