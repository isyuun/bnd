//
//  PetProfileViewController2.swift
//  PetTip
//
//  Created by isyuun on 2024/4/29.
//

import UIKit
import AlamofireImage
import DGCharts

class PetProfileViewController2: PetProfileViewController {

    override func onAddPetWeight(_ sender: Any) {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][petInfo:\(String(describing: myPet))][petDetailInfo:\(String(describing: petDetailInfo))]")
        super.onAddPetWeight(sender)
    }

    override func onModifyPetInfo(_ sender: Any) {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][petInfo:\(String(describing: myPet))][petDetailInfo:\(String(describing: petDetailInfo))]")
        super.onModifyPetInfo(sender)
    }

    override func weight_list() {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][petInfo:\(String(describing: myPet))][petDetailInfo:\(String(describing: petDetailInfo))]")
        super.weight_list()
    }

    override func showProfileInfo() {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][petInfo:\(String(describing: myPet))][petDetailInfo:\(String(describing: petDetailInfo))]")
        super.showProfileInfo()

        guard let pet = self.myPet else { return }
        Global2.setPetImage(imageView: self.iv_profile, petTypCd: pet.petTypCd, petImgAddr: pet.petRprsImgAddr)
    }

    override func initPetWeightGraph() {
        DispatchQueue.main.async { [self] in
            initPetWeightChart()
        }
    }

    private func initPetWeightChart() {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][count:\(weightData.count)][weightData:\(String(describing: weightData))]")
        let max = weightData.max()
        let min = weightData.min()

        vw_lineChart.backgroundColor = .white
        vw_lineChart.noDataTextColor = UIColor.init(hex: "#FF737980")!

        vw_lineChart.highlightPerTapEnabled = true
        vw_lineChart.highlightPerDragEnabled = true
        vw_lineChart.doubleTapToZoomEnabled = false
        vw_lineChart.xAxis.labelPosition = .bottom
        vw_lineChart.xAxis.drawGridLinesEnabled = false
        vw_lineChart.xAxis.avoidFirstLastClippingEnabled = true

        vw_lineChart.leftAxis.axisMaximum = (max ?? 80.0) + 5.0
        vw_lineChart.leftAxis.axisMinimum = (min ?? 30.0) - 5.0

        vw_lineChart.rightAxis.enabled = false
        vw_lineChart.legend.enabled = false
        vw_lineChart.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)

        vw_lineChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: dayData)
        vw_lineChart.xAxis.granularity = 1

        if weightData.count > 0 {
            self.showToast(msg: "길게 누르면 몸무게 수정이 가능합니다.")
            setLineData(lineChartView: vw_lineChart, lineChartDataEntries: entryData(values: self.weightData))
        } else {
            vw_lineChart.noDataText = "뭄무게를 등록해 주셋요." // this should be remove "No chart data available."
            vw_lineChart.layer.borderWidth = 0.2 // 테두리 두께 설정
            vw_lineChart.layer.borderColor = UIColor.black.cgColor // 테두리 색상 설정
            // vw_lineChart.layer.cornerRadius = 5.0 // 테두리 둥글기 설정 (선택사항)
        }

        vw_lineChart.setVisibleXRangeMaximum(10)
        vw_lineChart.setVisibleXRangeMinimum(5)

        vw_lineChart.xAxis.setLabelCount(dayData.count, force: true)

        vw_lineChart.leftAxis.axisMaximum = (max ?? 80.0) + 5.0
        vw_lineChart.leftAxis.axisMinimum = (min ?? 30.0) - 5.0

        if weightData.count == 1 {
            vw_lineChart.xAxis.axisMinLabels = 1
            vw_lineChart.xAxis.labelCount = 1
            vw_lineChart.setVisibleXRangeMinimum(500)
            vw_lineChart.xAxis.avoidFirstLastClippingEnabled = false
        }

        let marker = BalloonMarker(color: UIColor(white: 200 / 255, alpha: 0.75),
                                   font: .systemFont(ofSize: 11),
                                   textColor: .darkText,
                                   insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8))
        marker.chartView = vw_lineChart
        marker.minimumSize = CGSize(width: 50, height: 10)
        vw_lineChart.marker = marker

        addGestureRecognizer()
    }

    func addGestureRecognizer() {
        // DispatchQueue.main.async { [self] in
        //     // let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        //     // vw_lineChart.addGestureRecognizer(tapGesture)
        //     let longPressgesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressDetected(gesture:)))
        //     longPressgesture.allowableMovement = 50
        //     self.vw_lineChart.addGestureRecognizer(longPressgesture)
        // }
    }

    func removeGestureRecognizer() {
        // DispatchQueue.main.async { [self] in
        //     // vw_lineChart.removeGestureRecognizer(tapGesture)
        //     vw_lineChart.removeGestureRecognizer(longPressgesture)
        // }
    }


    let tapGesture = UITapGestureRecognizer(target: PetProfileViewController2.self, action: #selector(handleTap(_:)))
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][gesture:\(gesture)]")

        if weightData.count > 0 {
            if let petInfo = myPet, petInfo.mngrType == "C" { return }

            if gesture.state == .ended {
                let point = gesture.location(in: self.vw_lineChart)
                let h = self.vw_lineChart.getHighlightByTouchPoint(point)

                onModifyPetWeight(seq: Int(h!.x))
            }
        }
    }

    let longPressgesture = UILongPressGestureRecognizer(target: PetProfileViewController2.self, action: #selector(longPressDetected(gesture:)))
    override func longPressDetected(gesture: UILongPressGestureRecognizer) {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][gesture:\(gesture)]")

        if weightData.count > 0 {
            if let petInfo = myPet, petInfo.mngrType == "C" { return }

            if gesture.state == .ended {
                let point = gesture.location(in: self.vw_lineChart)
                let h = self.vw_lineChart.getHighlightByTouchPoint(point)

                onModifyPetWeight(seq: Int(h!.x))
            }
        }
    }

    override func onModifyPetWeight(seq: Int) {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][count:\(weightData.count)][weightData:\(String(describing: weightData))]")

        guard let arrWeight = arrWeight else { return }

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

            self.vw_lineChart.addGestureRecognizer(self.tapGesture)
        }
        petWeightView.didTapCancel = {
            self.didTapPopupCancel()
            if arrWeight.count > 1 {
                self.weight_delete(petDtlUnqNo: arrWeight[seq].petDtlUnqNo)
                self.vw_lineChart.addGestureRecognizer(self.tapGesture)
            } else {
                self.showToast(msg: "삭제 할 수 없습니다.")
            }
        }

        self.popupShow(contentView: petWeightView, wSideMargin: 40, isTapCancel: true)

        // removeGestureRecognizer()
    }
}
