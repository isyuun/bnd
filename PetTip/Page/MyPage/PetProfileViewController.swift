//
//  PetProfileViewController.swift
//  PetTip
//
//  Created by carebiz on 1/26/24.
//

import UIKit
import AlamofireImage
import DGCharts

class PetProfileViewController: CommonViewController {

    public var isRequireRefresh = false

    public var myPet: MyPet?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.tabBar.isHidden = true

        showBackTitleBarView()

        showCommonUI()

        detail()

        weight_list()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true

        if isRequireRefresh {
            detail()
        }
    }

    @IBOutlet weak var vw_profileBg: UIView!
    @IBOutlet weak var iv_profile: UIImageView!

    @IBOutlet weak var lb_petKind: UILabel!
    @IBOutlet weak var lb_petNm: UILabel!

    @IBOutlet weak var vw_ageBg: UIView!
    @IBOutlet weak var vw_genderBg: UIView!
    @IBOutlet weak var vw_weightBg: UIView!

    @IBOutlet weak var lb_age: UILabel!
    @IBOutlet weak var lb_gender: UILabel!
    @IBOutlet weak var lb_weight: UILabel!

    @IBOutlet weak var vw_lineChart: LineChartView!

    @IBOutlet weak var btn_petModify: UIButton!
    @IBOutlet weak var btn_petCreate: UIButton!

    @IBOutlet weak var sv_member: UIStackView!

    func showCommonUI() {
        initProfile()
    }

    private func initProfile() {
        vw_profileBg.backgroundColor = UIColor.white
        vw_profileBg.layer.cornerRadius = self.vw_profileBg.bounds.size.width / 2
        vw_profileBg.layer.borderColor = UIColor.init(hex: "#4E608526")?.cgColor
        vw_profileBg.layer.borderWidth = 1
        vw_profileBg.layer.shadowRadius = 2
        vw_profileBg.layer.shadowOpacity = 0.2
        vw_profileBg.layer.shadowColor = UIColor.init(hex: "#70000000")?.cgColor
        vw_profileBg.layer.shadowOffset = CGSize(width: 2, height: 3)

        iv_profile.backgroundColor = UIColor.white
        iv_profile.layer.cornerRadius = self.iv_profile.bounds.size.width / 2
        iv_profile.layer.masksToBounds = true
        iv_profile.image = UIImage(named: "profile_default")
        iv_profile.contentMode = .scaleAspectFill

        vw_ageBg.layer.cornerRadius = 8
        vw_genderBg.layer.cornerRadius = 8
        vw_weightBg.layer.cornerRadius = 8

        guard let petInfo = self.myPet else { return }

        if petInfo.mngrType != "M" {
            btn_petModify.setAttrTitle("관리자만 수정가능", 14)
            btn_petModify.isEnabled = false
        }

        if petInfo.mngrType == "C" {
            btn_petCreate.setAttrTitle("참여자만 등록가능", 14, UIColor.darkText)
            btn_petCreate.isEnabled = false
        }
    }

    @IBAction func onModifyPetInfo(_ sender: Any) {
        let petModViewController = UIStoryboard(name: "Pet", bundle: nil).instantiateViewController(identifier: "PetModViewController") as PetModViewController
        petModViewController.petProfileViewController = self
        petModViewController.petDetailInfo = self.petDetailInfo
        self.navigationController?.pushViewController(petModViewController, animated: true)
    }

    // MARK: - CONN PET DETAIL
    var petDetailInfo: MyPetDetailData?

    internal func detail() {
        guard let petInfo = myPet else { return }

        self.startLoading()

        let request = MyPetDetailRequest(ownrPetUnqNo: petInfo.ownrPetUnqNo, petRprsYn: petInfo.petRprsYn, userId: UserDefaults.standard.value(forKey: "userId")! as! String)
        MyPetAPI.detail(request: request) { response, error in
            self.stopLoading()

            if let response = response {
                if response.statusCode == 200 {
                    self.petDetailInfo = response.data

                    self.myPet_list()

                    self.showProfileInfo()

                    self.initMemberList()
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

    func showProfileInfo() {
        // guard let petDetailInfo = petDetailInfo else { return }
        // 
        // Global2.setPetImage(imageView: self.iv_profile, petTypCd: petDetailInfo.petTypCd, petImgAddr: petDetailInfo.petRprsImgAddr)
        // 
        // self.lb_petKind.text = petDetailInfo.petKindNm
        // self.lb_petNm.text = petDetailInfo.petNm
        // 
        // self.lb_age.text = Util.transDiffDateStr(petDetailInfo.petBrthYmd)
        // self.lb_gender.text = petDetailInfo.sexTypNm
        // self.lb_weight.text = String(format: "%.1fkg", Float(petDetailInfo.wghtVl))
    }

    // MARK: - PET MEMBER LIST
    private var arrMemberView = [UIView]()

    private func initMemberList() {
        guard let petDetailInfo = petDetailInfo else { return }

        for i in 0..<arrMemberView.count {
            arrMemberView[i].removeFromSuperview()
        }

        for i in 0..<petDetailInfo.memberList.count {
            let petProfileMemberItemView = UINib(nibName: "PetProfileMemberItemView", bundle: nil).instantiate(withOwner: self).first as! PetProfileMemberItemView
            petProfileMemberItemView.initialize(memberList: petDetailInfo.memberList[i])
            petProfileMemberItemView.didDismissJoin = {
                self.rel_close(memberList: petDetailInfo.memberList[i])
            }
            arrMemberView.append(petProfileMemberItemView)
            sv_member.addArrangedSubview(petProfileMemberItemView)
        }
    }

    private func rel_close(memberList: MemberList) {
        self.startLoading()

        let request = MyPetRelCloseRequest(ownrPetUnqNo: memberList.ownrPetUnqNo, petRelUnqNo: memberList.petRelUnqNo)
        MyPetAPI.relClose(request: request) { response, error in
            self.stopLoading()

            if let response = response {
                if response.statusCode == 200 {
                    self.detail()
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

    // MARK: - PET WEIGHT
    internal var arrWeight: [MyPetWeightData]?

    internal var dayData: [String] = []
    internal var weightData: [Double]! = []
    // private var dayData: [String] = ["11월02일", "11월03일", "11월04일", "11월05일", "11월06일", "11월07일", "11월08일", "11월09일", "11월10일"]
    // private var weightData: [Double]! = [100, 345, 20, 120, 90, 300, 450, 220, 120]
    // private var dayData = ["11월02일", "11월03일"]
    // private var weightData: [Double]! = [100, 60]

    internal func initPetWeightGraph() {
        vw_lineChart.backgroundColor = .white
        vw_lineChart.noDataTextColor = UIColor.init(hex: "#FF737980")!
        
        vw_lineChart.highlightPerTapEnabled = true
        vw_lineChart.highlightPerDragEnabled = true
        vw_lineChart.doubleTapToZoomEnabled = false
        vw_lineChart.xAxis.labelPosition = .bottom
        vw_lineChart.xAxis.drawGridLinesEnabled = false
        vw_lineChart.xAxis.avoidFirstLastClippingEnabled = true
        
        vw_lineChart.leftAxis.axisMaximum = (weightData.max() ?? 80.0) + 5.0
        vw_lineChart.leftAxis.axisMinimum = (weightData.min() ?? 30.0) - 5.0
        
        vw_lineChart.rightAxis.enabled = false
        vw_lineChart.legend.enabled = false
        vw_lineChart.animate(xAxisDuration: 0.5, yAxisDuration: 0.5)

        vw_lineChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: dayData)
        vw_lineChart.xAxis.granularity = 1
        
        setLineData(lineChartView: vw_lineChart, lineChartDataEntries: entryData(values: self.weightData))
        
        vw_lineChart.setVisibleXRangeMaximum(10)
        vw_lineChart.setVisibleXRangeMinimum(5)
        
        vw_lineChart.xAxis.setLabelCount(dayData.count, force: true)
        
        vw_lineChart.leftAxis.axisMaximum = (weightData.max() ?? 80.0) + 5.0
        vw_lineChart.leftAxis.axisMinimum = (weightData.min() ?? 30.0) - 5.0
        
        // if weightData.count == 1 {
        //     vw_lineChart.xAxis.axisMinLabels = 1
        //     vw_lineChart.xAxis.labelCount = 1
        //     vw_lineChart.setVisibleXRangeMinimum(500)
        //     vw_lineChart.xAxis.avoidFirstLastClippingEnabled = false
        // }
        
        let longPressgesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressDetected(gesture:)))
        longPressgesture.allowableMovement = 50
        self.vw_lineChart.addGestureRecognizer(longPressgesture)
        
        let marker = BalloonMarker(color: UIColor(white: 200 / 255, alpha: 0.75),
                                   font: .systemFont(ofSize: 11),
                                   textColor: .darkText,
                                   insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8))
        marker.chartView = vw_lineChart
        marker.minimumSize = CGSize(width: 50, height: 10)
        vw_lineChart.marker = marker
    }

    @objc func longPressDetected(gesture: UILongPressGestureRecognizer) {
        if let petInfo = myPet, petInfo.mngrType == "C" { return }

        if gesture.state == .ended {
            let point = gesture.location(in: self.vw_lineChart)
            let h = self.vw_lineChart.getHighlightByTouchPoint(point)

            onModifyPetWeight(seq: Int(h!.x))
        }
    }

    internal func setLineData(lineChartView: LineChartView, lineChartDataEntries: [ChartDataEntry]) {
        let lineChartdataSet = LineChartDataSet(entries: lineChartDataEntries, label: "kg")
        lineChartdataSet.colors = [UIColor.init(hex: "#FFF54F68")!]
        lineChartdataSet.circleColors = [UIColor.init(hex: "#FFF54F68")!]
        lineChartdataSet.drawValuesEnabled = false

        let lineChartData = LineChartData(dataSet: lineChartdataSet)

        lineChartView.data = lineChartData
    }

    internal func entryData(values: [Double]) -> [ChartDataEntry] {
        var lineDataEntries: [ChartDataEntry] = []

        for i in 0 ..< values.count {
            let lineDataEntry = ChartDataEntry(x: Double(i), y: values[i])
            lineDataEntries.append(lineDataEntry)
        }

        return lineDataEntries
    }

    func weight_list() {
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
                        let date = arrWeight[i].crtrYmd
                        let wght = arrWeight[i].wghtVl
                        print("\(date) = \(wght)")
                        self.dayData.append(date)
                        self.weightData.append(Double(wght))
                    }

                    self.arrWeight = arrWeight

                    self.initPetWeightGraph()
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

    internal func onModifyPetWeight(seq: Int) {
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
        }
        petWeightView.didTapCancel = {
            self.didTapPopupCancel()
        
            self.weight_delete(petDtlUnqNo: arrWeight[seq].petDtlUnqNo)
        }
        
        self.popupShow(contentView: petWeightView, wSideMargin: 40, isTapCancel: true)
    }

    @IBAction func onAddPetWeight(_ sender: Any) {
        guard let petInfo = myPet else { return }

        let petWeightView = UINib(nibName: "PetWeightView", bundle: nil).instantiate(withOwner: self).first as! PetWeightView2
        petWeightView.initialize(viewMode: .ADD)
        petWeightView.didTapOK = { date, weight in
            self.didTapPopupOK()

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMdd"
            let strDate = dateFormatter.string(from: date)

            self.weight_create(crtrYmd: strDate, ownrPetUnqNo: petInfo.ownrPetUnqNo, wghtVl: weight)
        }
        petWeightView.didTapCancel = {
            self.didTapPopupCancel()
        }

        self.popupShow(contentView: petWeightView, wSideMargin: 40, isTapCancel: true)
    }

    internal func weight_create(crtrYmd: String, ownrPetUnqNo: String, wghtVl: String) {
        self.startLoading()

        let request = MyPetWeightCreateRequest(crtrYmd: crtrYmd, ownrPetUnqNo: ownrPetUnqNo, wghtVl: wghtVl)
        MyPetAPI.weightCreate(request: request) { response, error in
            self.stopLoading()

            if let response = response {
                if response.statusCode == 200 {
                    self.showToast(msg: "등록되었어요")
                    self.weight_list()
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

    internal func weight_update(crtrYmd: String, petDtlUnqNo: Int, wghtVl: String) {
        self.startLoading()

        let request = MyPetWeightUpdateRequest(crtrYmd: crtrYmd, petDtlUnqNo: petDtlUnqNo, wghtVl: wghtVl)
        MyPetAPI.weightUpdate(request: request) { response, error in
            self.stopLoading()

            if let response = response {
                if response.statusCode == 200 {
                    self.showToast(msg: "변경되었어요")
                    self.weight_list()
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

    internal func weight_delete(petDtlUnqNo: Int) {
        self.startLoading()

        let request = MyPetWeightDeleteRequest(petDtlUnqNo: petDtlUnqNo)
        MyPetAPI.weightDelete(request: request) { response, error in
            self.stopLoading()

            if let response = response {
                if response.statusCode == 200 {
                    self.showToast(msg: "삭제되었어요")
                    self.weight_list()
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

    // MARK: - CONN MYPET-LIST, DAILYLIFE-PETLIST
    func myPet_list() {
        self.startLoading()

        let request = MyPetListRequest(userId: UserDefaults.standard.value(forKey: "userId")! as! String)
        MyPetAPI.list(request: request) { myPetList, error in
            self.stopLoading()

            if let myPetList = myPetList {
                Global.myPetListBehaviorRelay.accept(myPetList)

                self.dailyLife_PetList()
            }

            self.processNetworkError(error)
        }
    }

    func dailyLife_PetList() {
        self.startLoading()

        let request = PetListRequest(userId: UserDefaults.standard.value(forKey: "userId")! as! String)
        DailyLifeAPI.petList(request: request) { petList, error in
            self.stopLoading()

            if let petList = petList {
                Global.dailyLifePetListBehaviorRelay.accept(petList)
                Global.selectedPetIndexBehaviorRelay.accept(0)
            }

            if let error = error {
                self.showSimpleAlert(title: "PetList fail", msg: error.localizedDescription)
            }
        }
    }

    // MARK: - Back TitleBar
    @IBOutlet weak var titleBarView: UIView!

    func showBackTitleBarView() {
        if let view = UINib(nibName: "BackTitleBarView", bundle: nil).instantiate(withOwner: self).first as? BackTitleBarView {
            view.frame = titleBarView.bounds
            var title = "프로필"
            if let petInfo = myPet { title = String("\(petInfo.petNm) 프로필") }
            view.lb_title.text = title
            view.delegate = self
            titleBarView.addSubview(view)
            self.title = view.lb_title.text
        }
    }
}

extension PetProfileViewController: BackTitleBarViewProtocol {
    func onBack() {
        navigationController?.popViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
}
