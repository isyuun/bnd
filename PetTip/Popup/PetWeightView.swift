//
//  PetWeightView.swift
//  PetTip
//
//  Created by carebiz on 1/27/24.
//

import UIKit

enum PetWeightViewMode {
    case ADD
    case MODIFY
}

class PetWeightView: CommonPopupView2 {

    public var didTapOK: ((_ date: Date, _ weight: String) -> Void)?
    public var didTapCancel: (() -> Void)?

    public var targetDate: Date?

    @IBOutlet weak var tf_date: UITextField!
    @IBOutlet weak var btn_date: UIButton!
    @IBOutlet weak var tf_weight: UITextField!
    @IBOutlet weak var btn_ok: UIButton!
    @IBOutlet weak var btn_nok: UIButton!

    func initialize(viewMode: PetWeightViewMode) {
        if viewMode == .ADD {
            btn_date.addTarget(self, action: #selector(onDate(_:)), for: .touchUpInside)
            btn_ok.setAttrTitle("등록", 14)
            btn_nok.setAttrTitle("취소", 14, UIColor.darkText)

        } else if viewMode == .MODIFY {
            btn_ok.setAttrTitle("변경", 14)
            btn_nok.setAttrTitle("삭제", 14, UIColor.darkText)
        }

        tfNormalUI(view: tf_date)

        tf_weight.delegate = self
        tfNormalUI(view: tf_weight)
    }

    private func tfSelectedUI(view: UITextField) {
        view.layer.cornerRadius = 4

        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor(hex: "#FF000000")?.cgColor // SELECTED COLOR
    }

    private func tfNormalUI(view: UITextField) {
        view.layer.cornerRadius = 4

        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(hex: "#ffe3e9f2")?.cgColor // NORMAL COLOR
    }

    @objc private func onDate(_ sender: Any) {
        guard let parentViewController = parentViewController else { return }
        tfSelectedUI(view: tf_date)

        if let v = UINib(nibName: "DatePickerView", bundle: nil).instantiate(withOwner: self).first as? DatePickerView {
            v.initializeOnlyDate()
            v.preventSelectFuture()
            v.didTapOK = { datetime in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyyMMddHHmm"
                let date = dateFormatter.date(from: datetime)

                self.targetDate = date

                let dateFormatter2 = DateFormatter()
                dateFormatter2.dateFormat = "yyyy.MM.dd"
                self.tf_date.text = dateFormatter2.string(from: date!)

                parentViewController.didTapPopupOK()
                self.tfNormalUI(view: self.tf_date)
            }
            v.didTapCancel = {
                parentViewController.didTapPopupCancel()
                self.tfNormalUI(view: self.tf_date)
            }

            parentViewController.popupShow(contentView: v, wSideMargin: 0)
        }
    }

    @IBAction func onCancel(_ sender: Any) {
        didTapCancel?()
    }

    @IBAction func onOK(_ sender: Any) {
        guard let date = targetDate else {
            parentViewController?.showToast(msg: "날짜가 선택되지 않았어요")
            return
        }

        var weight: Double = 0.0
        if let convertedNum = Double(tf_weight.text!) {
            weight = convertedNum
        } else {
            parentViewController?.showToast(msg: "몸무게는 숫자만 입력해주세요")
            return
        }

        didTapOK?(date, String(format: "%.1f", weight))
    }
}

extension PetWeightView: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        tfSelectedUI(view: textField)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        tfNormalUI(view: textField)
    }
}
