//
//  ReportView.swift
//  PetTip
//
//  Created by carebiz on 12/29/23.
//

import UIKit
import DropDown

class ReportView: CommonPopupView {
 
    @IBOutlet weak var vw_reasonComboArea : UIControl!
    @IBOutlet weak var vw_reasonComboShowingArea : UIControl!
    @IBOutlet weak var lb_reason : UILabel!
    @IBOutlet weak var tv_comment : UITextView!
    
    public var didTapOK: ((_ reasonId: String, _ cmnt: String)-> Void)?
    public var didTapCancel: (()-> Void)?
    
    private var arrRsnId = [String]()
    private var arrRsnNm = [String]()
    
    var selectedRsnIdx = -1
    
    let textViewPlaceHolder = "신고 내용을 입력해주세요"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder : NSCoder) {
        super.init(coder: aDecoder);
    }
    
    func initialize() {
        vw_reasonComboArea.layer.cornerRadius = 10
        vw_reasonComboArea.layer.borderWidth = 1
        vw_reasonComboArea.layer.borderColor = UIColor.init(hex: "#4E608533")?.cgColor
        
        tv_comment.layer.cornerRadius = 10
        tv_comment.layer.borderWidth = 1
        tv_comment.layer.borderColor = UIColor.init(hex: "#4E608533")?.cgColor
        tv_comment.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        tv_comment.delegate = self
        
        if let rsnCodeList = Global.rsnCodeList {
            for item in rsnCodeList {
                arrRsnId.append(item.cdID)
                arrRsnNm.append(item.cdNm)
            }
        }
    }
    
    @IBAction func onReasonCombo(_ sender: Any) {
        let dropDown = DropDown()

        // The view to which the drop down will appear on
        dropDown.anchorView = vw_reasonComboShowingArea // UIView or UIBarButtonItem

        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = arrRsnNm
        
        DropDown.startListeningToKeyboard()
        
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
//          print("Selected item: \(item) at index: \(index)")
            selectedRsnIdx = index
            lb_reason.text = arrRsnNm[index]
        }
    }
    
    @IBAction func onCancel(_ sender: Any) {
        didTapCancel?()
    }
    
    @IBAction func onOK(_ sender: Any) {
        didTapOK?(selectedRsnIdx > -1 ? arrRsnId[selectedRsnIdx] : "", tv_comment.text)
    }
}





// MARK: - TextViewDelegate

extension ReportView : UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.textColor = UIColor.init(hex: "#FFB5B9BE")
        } else {
            textView.textColor = .black
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .black
        }
        
        tv_comment.layer.borderColor = UIColor.darkText.cgColor
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = UIColor.init(hex: "#FFB5B9BE")
        }
        
        tv_comment.layer.borderColor = UIColor.init(hex: "#4E608533")?.cgColor
    }
}
