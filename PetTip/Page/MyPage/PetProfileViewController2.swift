//
//  PetProfileViewController2.swift
//  PetTip
//
//  Created by isyuun on 2024/5/20.
//

import UIKit
import AlamofireImage
import DGCharts

class PetProfileViewController2: PetProfileViewController {
    override func showProfileInfo() {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][count:\(self.weightData.count)]")
        guard let pet = petDetailInfo else { return }

        Global2.setPetImage(imageView: self.iv_profile, petTypCd: pet.petTypCd, petImgAddr: pet.petRprsImgAddr)

        self.lb_petKind.text = pet.petKindNm
        self.lb_petNm.text = pet.petNm

        self.lb_age.text = Util.transDiffDateStr(pet.petBrthYmd)
        self.lb_gender.text = pet.sexTypNm
        self.lb_weight.text = String(format: "%.1fkg", Float(pet.wghtVl))
    }

    override func longPressDetected(gesture: UILongPressGestureRecognizer) {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][count:\(self.weightData.count)]")
        if let petInfo = myPet, petInfo.mngrType == "C" { return }

        if self.weightData.count > 0, gesture.state == .ended {
            let point = gesture.location(in: self.vw_lineChart)
            let h = self.vw_lineChart.getHighlightByTouchPoint(point)

            onModifyPetWeight(seq: Int(h!.x))
        }
    }

    override func initPetWeightGraph() {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][count:\(self.weightData.count)]")
        super.initPetWeightGraph()

        vw_lineChart.leftAxis.drawAxisLineEnabled = false
        if weightData.count == 1 {
            vw_lineChart.xAxis.axisMinLabels = 1
            vw_lineChart.xAxis.labelCount = 1
            vw_lineChart.setVisibleXRangeMaximum(500)
            vw_lineChart.setVisibleXRangeMinimum(500)
        } else {
            vw_lineChart.xAxis.axisMinLabels = weightData.count
            vw_lineChart.xAxis.labelCount = weightData.count
            vw_lineChart.setVisibleXRangeMaximum(7)
            vw_lineChart.setVisibleXRangeMinimum(7)
        }
        vw_lineChart.xAxis.avoidFirstLastClippingEnabled = false
        // vw_lineChart.xAxis.spaceMax = 10.0
        // vw_lineChart.minOffset = 10.0
        // vw_lineChart.xAxis.granularity = 1.0
    }

    override func setLineData(lineChartView: LineChartView, lineChartDataEntries: [ChartDataEntry]) {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][count:\(self.weightData.count)]")
        var w = 0.0
        if self.weightData.count > 0 {
            super.setLineData(lineChartView: lineChartView, lineChartDataEntries: lineChartDataEntries)
            w = 0.0
        }
        else {
            vw_lineChart.data = nil
            w = 0.5
        }
        vw_lineChart.noDataText = "뭄무게를 등록해 주세요." // this should be remove "No chart data available."
        vw_lineChart.layer.borderWidth = w // 테두리 두께 설정
        vw_lineChart.layer.borderColor = UIColor.black.cgColor // 테두리 색상 설정
        // vw_lineChart.layer.cornerRadius = 5.0 // 테두리 둥글기 설정 (선택사항)
    }

    override func showToast(msg: String) {
        super.showToast(msg: msg)
    }

    override func startLoading() {
        // super.startLoading()
    }

    override func stopLoading() {
        super.stopLoading()
    }

    override func viewDidLoad() {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)]")
        super.viewDidLoad()
        self.showToast(msg: "길게 누르면 몸무게 수정이 가능합니다.")
    }

    override func detail() {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][isRequireRefresh:\(isRequireRefresh)]")
        super.detail()
        isRequireRefresh = false
    }

    override func onModifyPetInfo(_ sender: Any) {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][isRequireRefresh:\(isRequireRefresh)]")
        super.onModifyPetInfo(sender)
        isRequireRefresh = true
    }

    override func onAddPetWeight(_ sender: Any) {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][isRequireRefresh:\(isRequireRefresh)]")
        super.onAddPetWeight(sender)
        isRequireRefresh = true
    }

    override func onModifyPetWeight(seq: Int) {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][isRequireRefresh:\(isRequireRefresh)][arrWeight\(String(describing: arrWeight))]")
        guard let arrWeight = arrWeight else { return }
        if arrWeight.count == 0 { return }

        let petWeightView = UINib(nibName: "PetWeightView", bundle: nil).instantiate(withOwner: self).first as! PetWeightView2
        petWeightView.initialize(viewMode: .MODIFY)
        petWeightView.tf_date.text = String(dayData[seq])
        petWeightView.tf_weight.text = String(weightData[seq])

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let date = dateFormatter.date(from: petWeightView.tf_date.text!)
        petWeightView.targetDate = date

        petWeightView.didTapOK = { date, weight in
            self.didTapPopupOK()

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMdd"
            let strDate = dateFormatter.string(from: date)

            self.weight_update(crtrYmd: strDate, petDtlUnqNo: arrWeight[seq].petDtlUnqNo, wghtVl: weight)
        }
        petWeightView.didTapCancel = {
            #if DEBUG
                self.didTapPopupCancel() //test
                self.weight_delete(petDtlUnqNo: arrWeight[seq].petDtlUnqNo) //test
            #else
                if arrWeight.count > 1 {
                    self.didTapPopupCancel()
                    self.weight_delete(petDtlUnqNo: arrWeight[seq].petDtlUnqNo)
                } else {
                    self.showToast(msg: "삭제 할 수 없습니다.")
                }
            #endif
        }

        self.popupShow(contentView: petWeightView, wSideMargin: 40, isTapCancel: true)
        isRequireRefresh = true
    }

    override func weight_list() {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][isRequireRefresh:\(isRequireRefresh)]")
        guard let petInfo = myPet else { return }

        self.startLoading()

        let request = MyPetWeightListRequest(ownrPetUnqNo: petInfo.ownrPetUnqNo)
        MyPetAPI.weightList(request: request) { response, error in
            self.stopLoading()

            if let response = response {
                if response.statusCode == 200 {
                    let arrWeight = response.data

                    self.dayData.removeAll()
                    self.weightData.removeAll()
                    for i in 0..<arrWeight.count {
                        var date = arrWeight[i].crtrYmd
                        let wght = arrWeight[i].wghtVl
                        let index = arrWeight[i].crtrYmd.index(arrWeight[i].crtrYmd.startIndex, offsetBy: 5)
                        date.insert("\n", at: index)
                        print("\(date) = \(wght)")
                        self.dayData.append(date)
                        self.weightData.append(Double(wght))
                    }

                    self.arrWeight = arrWeight

                    self.initPetWeightGraph()

                    if self.isRequireRefresh {
                        self.detail()
                        self.isRequireRefresh = false
                    }
                }
                else if response.statusCode == 406 {
                    self.showAlertPopup(title: response.resultMessage, msg: response.detailMessage!)

                } else {
                    self.showAlertPopup(title: "에러", msg: "통신 에러가 발생했어요")
                    //self.showAlertPopup(title: response.resultMessage, msg: response.detailMessage!)
                }
            }

            self.processNetworkError(error)
        }
    }
}
