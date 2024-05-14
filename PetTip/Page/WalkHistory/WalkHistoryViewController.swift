//
//  WalkHistoryWeek.swift
//  PetTip
//
//  Created by carebiz on 12/3/23.
//

import UIKit
import RxSwift
import RxCocoa
import AlamofireImage

// 산책기록 (주간) 화면

class WalkHistoryViewController: CommonViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        customBottomTabBar()

        showLogoTitleBarView()

        showCommonUI()

        initRx()

        initControlWeek()
    }

    @IBOutlet weak var vw_monthlyHistory: UIView!
    @IBOutlet weak var constraintTop_monthlyHistory: NSLayoutConstraint!

    @IBOutlet weak var vw_historyItem_Mon: UIView!
    @IBOutlet weak var vw_historyItem_Tue: UIView!
    @IBOutlet weak var vw_historyItem_Wed: UIView!
    @IBOutlet weak var vw_historyItem_Thi: UIView!
    @IBOutlet weak var vw_historyItem_Fri: UIView!
    @IBOutlet weak var vw_historyItem_Sat: UIView!
    @IBOutlet weak var vw_historyItem_Sun: UIView!

    @IBOutlet weak var btn_weekPrev: UIButton!
    @IBOutlet weak var btn_weekNext: UIButton!
    @IBOutlet weak var lb_week: UILabel!

    @IBOutlet weak var lb_walkTime: UILabel!
    @IBOutlet weak var lb_walkDist: UILabel!

    @IBOutlet weak var lb_showMonthlyHistory: UILabel!

    @IBOutlet weak var tb_history: UITableView!

    private func showCommonUI() {
        lb_showMonthlyHistory.attributedText = NSAttributedString(string: lb_showMonthlyHistory.text!,
                                                                  attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])

        tb_history.register(UINib(nibName: "WalkHistoryWeekListItemView", bundle: nil), forCellReuseIdentifier: "WalkHistoryWeekListItemView")
        tb_history.delegate = self
        tb_history.dataSource = self
        tb_history.separatorStyle = .none
        tb_history.backgroundColor = UIColor.init(hex: "#FFF6F8FC")
        tb_history.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 00)

        constraintTop_monthlyHistory.constant = -(vw_monthlyHistory.frame.size.height + 200)
    }

    // MARK: - CONTROL WEEK
    var selectedDate = Date()

    private func initControlWeek() {
        selectedDate = Date()
        btn_weekNext.isHidden = true
    }

    private func showControlWeek() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        if formatter.string(from: selectedDate) == formatter.string(from: Date()) {
            lb_week.text = "이번주 산책기록"
            btn_weekNext.isHidden = true
        } else {
            let month = Calendar.current.component(.month, from: selectedDate)
            let weekOfMonth = Calendar.current.component(.weekOfMonth, from: selectedDate)

            lb_week.text = String("\(month)월\(weekOfMonth)주차 산책기록")
            btn_weekNext.isHidden = false
        }
    }

    @IBAction func onWeekPrev(_ sender: Any) {
        selectedDate = Calendar.current.date(byAdding: .day, value: -7, to: selectedDate)!

        if let petList = self.dailyLifePetList {
            self.requestCurrPetWeekData(petList.pets[self.selectedPetIndex].ownrPetUnqNo)
        }

        showControlWeek()
    }

    @IBAction func onWeekNext(_ sender: Any) {
        selectedDate = Calendar.current.date(byAdding: .day, value: 7, to: selectedDate)!

        if let petList = self.dailyLifePetList {
            self.requestCurrPetWeekData(petList.pets[self.selectedPetIndex].ownrPetUnqNo)
        }

        showControlWeek()
    }

    var walkHistoryMonthView: WalkHistoryMonthView? = nil

    @IBAction func onShowMonthlyHistory(_ sender: Any) {
        if let view = UINib(nibName: "WalkHistoryMonthView", bundle: nil).instantiate(withOwner: self).first as? WalkHistoryMonthView
        {
            walkHistoryMonthView = view
            vw_monthlyHistory.addSubview(view)
            if let petList = dailyLifePetList {
                view.delegate = self
                view.initialize()
                view.ownrPetUnqNo = petList.pets[selectedPetIndex].ownrPetUnqNo
                view.update()
            }

            view.translatesAutoresizingMaskIntoConstraints = false

            let topConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: vw_monthlyHistory, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0)

            let leadingConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: vw_monthlyHistory, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0)

            let trailingConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: vw_monthlyHistory, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0)

            let bottomConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: vw_monthlyHistory, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)

            vw_monthlyHistory.addConstraints([topConstraint, leadingConstraint, trailingConstraint, bottomConstraint])
        }

        logoTitleBarView.changeLogoToBackBtn()

        constraintTop_monthlyHistory.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueWalkHistoryWeekToDetail") {
            let dest = segue.destination
            guard let vc = dest as? WalkHistoryDetailViewController else { return }
            vc.schUnqNo = sender as? Int
        }
    }

    let disposeBag = DisposeBag()

    var selectedPetIndex = 0

    var selectIdxFromPrevPage: Bool = false
    var mainViewController: MainViewController? = nil

    var walkList: [DailyLifeWalkList]? = nil

    func initRx() {
        Global.dailyLifePetList.subscribe(onNext: { [weak self] petList in
            self?.refreshDailyLifePetList(data: petList)
        }).disposed(by: disposeBag)

        Global.selectedPetIndex.subscribe(onNext: { [weak self] index in
            self?.refreshSelectedPetIndex(data: index)
        }).disposed(by: disposeBag)
    }

    private func refreshDailyLifePetList(data: PetList?) {
        guard let petList = data else { return }
        self.dailyLifePetList = petList
    }

    private func refreshSelectedPetIndex(data: Int?) {
        guard let index = data else { return }
        self.selectedPetIndex = index

        if let petList = self.dailyLifePetList {
            if (petList.pets.count > 0) {
                let pet = petList.pets[self.selectedPetIndex]

                Global2.setPetImage(imageView: self.titleBarPfImageView, petTypCd: pet.petTypCd, petImgAddr: pet.petRprsImgAddr)

                self.titleBarPfNMLabel.text = pet.petNm

                self.requestCurrPetWeekData(pet.ownrPetUnqNo)

                if (self.walkHistoryMonthView != nil) {
                    self.walkHistoryMonthView?.ownrPetUnqNo = pet.ownrPetUnqNo
                    self.walkHistoryMonthView?.update()
                }

            } else {
                self.titleBarPfImageView.image = UIImage(named: "profile_default")
                self.titleBarPfNMLabel.text = "등록된 펫 없음"
            }
        }

        if (self.selectIdxFromPrevPage == false) {
            self.mainViewController?.selectIdxFromPrevPage = true
            self.mainViewController?.pagerView.scrollToItem(at: self.selectedPetIndex, animated: false)
        } else {
            self.selectIdxFromPrevPage = false
        }
    }

    // MARK: - TARGET PET WEEKLY RECORD
    func requestCurrPetWeekData(_ ownrPetUnqNo: String) {
        self.startLoading()

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let searchDay = formatter.string(from: selectedDate)

        let request = WeekRecordRequest(ownrPetUnqNo: ownrPetUnqNo, searchDay: searchDay)
//        let request = WeekRecordRequest(ownrPetUnqNo: "P20230908000005", searchDay: searchDay)
        DailyLifeAPI.weekRecord(request: request) { weekRecord, error in
            self.stopLoading()

            if let weekRecord = weekRecord {
                self.lb_walkTime.text = weekRecord.weekRecord.runTime ?? "00:00:00"
                self.lb_walkDist.text = String(format: "%.1fkm", Float(weekRecord.weekRecord.runDstnc) / Float(1000.0))

                let arrWeekViewItem = [self.vw_historyItem_Sun,
                                       self.vw_historyItem_Mon,
                                       self.vw_historyItem_Tue,
                                       self.vw_historyItem_Wed,
                                       self.vw_historyItem_Thi,
                                       self.vw_historyItem_Fri,
                                       self.vw_historyItem_Sat]

                for i in 0...arrWeekViewItem.count - 1 {
                    if let viewItem = arrWeekViewItem[i] {
                        if viewItem.subviews.count > 0
                        {
                            viewItem.subviews.forEach({ $0.removeFromSuperview() })
                        }
                        if let view = UINib(nibName: "WalkHistoryItemView", bundle: nil).instantiate(withOwner: self).first as? WalkHistoryItemView
                        {
                            view.frame = viewItem.bounds
                            view.text = weekRecord.weekRecord.dayList[i].dayNm
                            view.isActive = weekRecord.weekRecord.dayList[i].runCnt > 0 ? true : false

                            let fomatter = DateFormatter()
                            fomatter.dateFormat = "yyyy-MM-dd"
                            let today = fomatter.string(from: Date())
                            if (weekRecord.weekRecord.dayList[i].date == today) {
                                view.isToday = true
                            } else {
                                view.isToday = false
                            }

                            viewItem.addSubview(view)
                            view.update()
                        }
                    }
                }

                self.walkList = weekRecord.weekRecord.dailyLifeWalkList
                self.tb_history.reloadData()
            }

            self.processNetworkError(error)
        }
    }

    // MARK: - SELECT MY PET
    var dailyLifePetList: PetList? = nil

    var bottomSheetVC: BottomSheetViewController! = nil
    var selectPetView: SelectPetView! = nil

    func showSelectMyPet() {
        if (dailyLifePetList == nil || dailyLifePetList?.pets.count == 0) {
            return
        }

        bottomSheetVC = BottomSheetViewController()
        bottomSheetVC.modalPresentationStyle = .overFullScreen
        bottomSheetVC.dismissIndicatorView.isHidden = true
//        bottomSheetVC.isDynamicHeight = true
        if let v = UINib(nibName: "SelectPetView", bundle: nil).instantiate(withOwner: self).first as? SelectPetView {
            bottomSheetVC.addContentSubView(v: v)
            v.initialize()
            v.setData(dailyLifePetList?.pets as Any)
            v.setSelected(self.selectedPetIndex)
            v.setDelegate(self)
        }
        self.present(bottomSheetVC, animated: false, completion: nil)
    }

    // MARK: - Bottom TabBar
    private func customBottomTabBar() {
        if let tbc = self.tabBarController {
            tbc.delegate = self
        }
    }

    // MARK: - Top LogoTitleBar
    @IBOutlet weak var titleBarView: UIView!

    var logoTitleBarView: LogoTitleBarView!
    var titleBarPfImageView: UIImageView!
    var titleBarPfNMLabel: UILabel!

    func showLogoTitleBarView() {
        if let view = UINib(nibName: "LogoTitleBarView", bundle: nil).instantiate(withOwner: self).first as? LogoTitleBarView {
            logoTitleBarView = view
            view.frame = titleBarView.bounds
            titleBarPfImageView = view.profileImageView
            titleBarPfNMLabel = view.profileNameLabel
            view.delegate = self
            titleBarView.addSubview(view)
            view.initialize()
        }
    }
}

// MARK: - TABBAR CONTROLLER DELEGATE
extension WalkHistoryViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let navController = viewController as? UINavigationController {
            if let vc = navController.children.first as? MainViewController {
                mainViewController = vc

                vc.selectIdxFromPrevPage = true
                vc.pagerView.scrollToItem(at: selectedPetIndex, animated: false)
            }
        }
    }
}

// MARK: - LOGO TITLE BAR VIEW DELEGATE
extension WalkHistoryViewController: LogoTitleBarViewProtocol {
    func onShowSelectMyPet() {
        showSelectMyPet()
    }

    func onBack() {
        logoTitleBarView.changeBackBtnToLogo()

        self.constraintTop_monthlyHistory.constant = -(self.vw_monthlyHistory.frame.size.height + 200)
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - SELECT PET VIEW DELEGATE
extension WalkHistoryViewController: SelectPetViewProtocol {
    func onSelectPet(_ selectedIdx: Int) {
        bottomSheetVC.hideBottomSheetAndGoBack()
        bottomSheetVC = nil

        selectPetView = nil

        Global.selectedPetIndexBehaviorRelay.accept(selectedIdx)
    }
}

// MARK: - WEEK HISTORY TABLEVIEW DELEGATE
extension WalkHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let cnt = walkList?.count {
            return cnt
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalkHistoryWeekListItemView", for: indexPath) as! WalkHistoryWeekListItemView

        cell.initialize()
        cell.lb_member.text = walkList?[indexPath.row].petNm
        cell.lb_date.text = walkList?[indexPath.row].walkDptreDt
        cell.lb_walker.text = walkList?[indexPath.row].runNcknm
        cell.lb_time.text = walkList?[indexPath.row].runTime
        cell.lb_dist.text = String(format: "%.1fkm", Float(walkList![indexPath.row].runDstnc) / Float(1000.0))
        cell.actionBlock = {
            self.performSegue(withIdentifier: "segueWalkHistoryWeekToDetail", sender: self.walkList![indexPath.row].schUnqNo)
        }

        return cell
    }
}

extension WalkHistoryViewController: WalkHistoryMonthViewProtocol {
    func onStartLoading() {
        self.startLoading()
    }

    func onStopLoading() {
        stopLoading()
    }

    func onMonthViewNetworkError(_ error: MyError?) {
        processNetworkError(error)
    }
}
