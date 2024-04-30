//
//  MainViewController.swift
//  PetTip
//
//  Created by carebiz on 12/2/23.
//

import UIKit
import FSPagerView
import CoreLocation
import RxSwift
import RxCocoa
import AlamofireImage

extension MainViewController: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {

        if let navController = viewController as? UINavigationController {
            if let vc = navController.children.first as? WalkHistoryViewController {
                walkHistoryViewController = vc

                vc.selectIdxFromPrevPage = true
                vc.dailyLifePets = dailyLifePets
            } else {
                print("# didSelect : others...")
            }
        } else {
            print("# didSelect : others... 2")
        }
    }
}

class MainViewController: LocationViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        removeAllBeforeHistory()

        customBottomTabBar()

        showLogoTitleBarView()

        showCommonUI()

        initRx()

        requestPageData()

        fsPagerInit()

        showSelectedPetInfo()

        showRealtimeStory()

        requestCurrLocationForWeather()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueMainToMap") {
            let dest = segue.destination
            guard let vc = dest as? NMapViewController else { return }
            vc.dailyLifePets = dailyLifePets
        }
    }





    private let disposeBag = DisposeBag()

    var selectedPetIndex = 0

    var dailyLifePets: PetList? = nil

    var myPetList: MyPetList? = nil

    var weekRecord: WeekRecord? = nil

    var selectIdxFromPrevPage: Bool = false
    var walkHistoryViewController: WalkHistoryViewController? = nil

    func initRx() {
        Global.myPetList.subscribe(onNext: { [weak self] myPetList in
            self?.refreshMyPetList(data: myPetList)
        }).disposed(by: disposeBag)

        Global.dailyLifePets.subscribe(onNext: { [weak self] petList in
            self?.refreshDailyLifePetList(data: petList)
        }).disposed(by: disposeBag)

        Global.selectedPetIndex.subscribe(onNext: { [weak self] index in
            self?.refreshSelectedPetIndex(data: index)
        }).disposed(by: disposeBag)
    }

    private func refreshMyPetList(data: MyPetList?) {
        guard let myPetList = data else { return }
        self.myPetList = myPetList
    }

    func requestCurrPetWeekData(_ ownrPetUnqNo: String) {
        startLoading()

        let fomatter = DateFormatter()
        fomatter.dateFormat = "yyyy-MM-dd"
        let searchDay = fomatter.string(from: Date())

        let request = WeekRecordRequest(ownrPetUnqNo: ownrPetUnqNo, searchDay: searchDay)
//        let request = WeekRecordRequest(ownrPetUnqNo: "P20230908000005", searchDay: searchDay)
        DailyLifeAPI.weekRecord(request: request) { weekRecord, error in
            self.stopLoading()

            if let weekRecord = weekRecord {
                self.totalWalkTimeLabel.text = weekRecord.weekRecord.runTime ?? "00:00:00"
                self.totalWalkDistLabel.text = String(format: "%.1fkm", Float(weekRecord.weekRecord.runDstnc) / Float(1000.0))
            }

            self.processNetworkError(error)
        }
    }

    func requestPageData() {
        dailyLife_PetList()
        myPet_list()
    }

    private func refreshDailyLifePetList(data: PetList?) {
        guard let petList = data else { return }
        self.dailyLifePets = petList

        self.bgCompPetFirstImg.isHidden = true
        self.bgCompPetSecondImg.isHidden = true
        if petList.pets.count > 0 {
            self.bgCompPetFirstImg.isHidden = false

            if let petRprsImgAddr = petList.pets[0].petRprsImgAddr {
                self.compPetFirstImg.af.setImage(
                    withURL: URL(string: petRprsImgAddr)!,
                    placeholderImage: UIImage(named: "profile_default")!,
                    filter: AspectScaledToFillSizeFilter(size: self.compPetFirstImg.frame.size)
                )
            } else {
                self.compPetFirstImg.image = UIImage(named: "profile_default")
            }
        }
        if petList.pets.count > 1 {
            self.bgCompPetSecondImg.isHidden = false

            if let petRprsImgAddr = petList.pets[1].petRprsImgAddr {
                self.compPetSecondImg.af.setImage(
                    withURL: URL(string: petRprsImgAddr)!,
                    placeholderImage: UIImage(named: "profile_default")!,
                    filter: AspectScaledToFillSizeFilter(size: self.compPetSecondImg.frame.size)
                )
            } else {
                self.compPetSecondImg.image = UIImage(named: "profile_default")
            }
        }
    }

    func dailyLife_PetList() {
        startLoading()

        let request = PetListRequest(userId: UserDefaults.standard.value(forKey: "userId")! as! String)
        DailyLifeAPI.petList(request: request) { petList, error in
            self.stopLoading()

            if let petList = petList {
                Global.dailyLifePetsBehaviorRelay.accept(petList)
                Global.selectedPetIndexBehaviorRelay.accept(0)
            }

            if let error = error {
                self.dailyLifePets = nil
                self.showSimpleAlert(title: "PetList fail", msg: error.localizedDescription)
            }
        }
    }

    func myPet_list() {
        startLoading()

        let request = MyPetListRequest(userId: UserDefaults.standard.value(forKey: "userId")! as! String)
        MyPetAPI.list(request: request) { myPetList, error in
            self.stopLoading()

            if let myPetList = myPetList {
                Global.myPetListBehaviorRelay.accept(myPetList)
            }

            self.processNetworkError(error)
        }
    }

    private func refreshSelectedPetIndex(data: Int?) {
        guard let index = data else { return }
        self.selectedPetIndex = index

        self.pagerView.reloadData()

        if let petList = self.dailyLifePets {
            if (petList.pets.count > 0) {
                Global.petRelUnqNo = petList.pets[self.selectedPetIndex].petRelUnqNo
                if let petRprsImgAddr = petList.pets[self.selectedPetIndex].petRprsImgAddr {
                    self.titleBarPfImageView.af.setImage(
                        withURL: URL(string: petRprsImgAddr)!,
                        placeholderImage: UIImage(named: "profile_default")!,
                        filter: AspectScaledToFillSizeFilter(size: self.titleBarPfImageView.frame.size)
                    )
                } else {
                    self.titleBarPfImageView.image = UIImage(named: "profile_default")
                }
                self.titleBarPfNMLabel.text = petList.pets[self.selectedPetIndex].petNm

                self.lbCurrPetKind.text = petList.pets[self.selectedPetIndex].petKindNm
                self.lbCurrPetNm.text = petList.pets[self.selectedPetIndex].petNm

                self.ageLabel.text = petList.pets[self.selectedPetIndex].age
                self.genderLabel.text = petList.pets[self.selectedPetIndex].sexTypNm
                self.weightLabel.text = String(format: "%.1fkg", Float(petList.pets[self.selectedPetIndex].wghtVl))

                self.currPetNMLabel.text = petList.pets[self.selectedPetIndex].petNm

                self.requestCurrPetWeekData(petList.pets[self.selectedPetIndex].ownrPetUnqNo)

            } else {
                self.titleBarPfImageView.image = UIImage(named: "profile_default")
                self.titleBarPfNMLabel.text = "등록된 펫 없음"

                self.lbCurrPetKind.text = ""
                self.lbCurrPetNm.text = "등록된 펫 없음"

                self.currPetNMLabel.text = "댕댕이"

                self.ageLabel.text = "-"
                self.genderLabel.text = "-"
                self.weightLabel.text = "-"

                self.totalWalkTimeLabel.text = "00:00:00"
                self.totalWalkDistLabel.text = "0.0km"
            }
        }

        if (self.selectIdxFromPrevPage == false) {
            self.walkHistoryViewController?.selectIdxFromPrevPage = true
            self.walkHistoryViewController?.dailyLifePets = self.dailyLifePets
        } else {
            self.selectIdxFromPrevPage = false
        }
    }





    // MARK: - COMMON UI

    @IBOutlet weak var bgWeatherView: UIView!

    @IBOutlet weak var bgPetListView: UIView!

    @IBOutlet weak var btnWalkGo: UIControl!

    private func showCommonUI() {
        bgWeatherView.layer.cornerRadius = 13

        bgPetListView.layer.cornerRadius = 40
        bgPetListView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
//        bgPetListView.layer.masksToBounds = true

        bgPetListView.layer.borderColor = UIColor.init(hex: "#4E608526")?.cgColor
        bgPetListView.layer.borderWidth = 1

        bgPetListView.layer.shadowRadius = 5
        bgPetListView.layer.shadowOpacity = 0.15
        bgPetListView.layer.shadowOffset = CGSize(width: 2, height: 4)

        btnWalkGo.backgroundColor = UIColor(hex: "#ff4783f5")
        btnWalkGo.layer.cornerRadius = btnWalkGo.bounds.size.width / 2
        btnWalkGo.layer.shadowRadius = 2
        btnWalkGo.layer.shadowOpacity = 0.2
        btnWalkGo.layer.shadowOffset = CGSize(width: 2, height: 4)
//        btnWalkGo.setBackgroundColor(UIColor(hex: "#ff4783f5")!, for: UIControl.State.normal)
//        btnWalkGo.setBackgroundColor(UIColor(hex: "#ff4B64F5")!, for: UIControl.State.highlighted)

        lbCurrPetKind.text = ""
        lbCurrPetNm.text = ""
    }

    @IBAction func onWalkGo(_ sender: Any) {
        btnWalkGo.backgroundColor = UIColor(hex: "#ff4783f5")
        self.performSegue(withIdentifier: "segueMainToMap", sender: self)
    }
    @IBAction func onWalkGo_TouchDown(_ sender: Any) {
        btnWalkGo.backgroundColor = UIColor(hex: "#ff4B64F5")
    }
    @IBAction func onWalkGo_TouchUpOutside(_ sender: Any) {
        btnWalkGo.backgroundColor = UIColor(hex: "#ff4783f5")
    }

    func removeAllBeforeHistory() {
        self.navigationController?.viewControllers.removeAll(where: { vc -> Bool in
            if vc.isKind(of: MainViewController.self) {
                return false
            } else {
                return true
            }
        })
    }





    // MARK: - SELECTED PET INFO

    @IBOutlet weak var lbCurrPetKind: UILabel!
    @IBOutlet weak var lbCurrPetNm: UILabel!

    @IBOutlet weak var ageBgView: UIView!
    @IBOutlet weak var genderBgView: UIView!
    @IBOutlet weak var weightBgView: UIView!

    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!

    @IBOutlet weak var bgCompPetSetImg: UIView!
    @IBOutlet weak var bgCompPetSetImg2: UIView!
    @IBOutlet weak var bgCompPetFirstImg: UIView!
    @IBOutlet weak var bgCompPetSecondImg: UIView!

    @IBOutlet weak var compPetSetImg: UIImageView!
    @IBOutlet weak var compPetFirstImg: UIImageView!
    @IBOutlet weak var compPetSecondImg: UIImageView!

    @IBOutlet weak var compPetListLabel: UILabel!

    @IBOutlet weak var currPetNMLabel: UILabel!

    @IBOutlet weak var bgCompPetWalkInfo: UIView!
    @IBOutlet weak var bgCompPetWalkTimeIcon: UIView!
    @IBOutlet weak var bgCompPetWalkDistIcon: UIView!
    @IBOutlet weak var totalWalkTimeLabel: UILabel!
    @IBOutlet weak var totalWalkDistLabel: UILabel!

    private func showSelectedPetInfo() {

        ageBgView.layer.cornerRadius = 8
        genderBgView.layer.cornerRadius = 8
        weightBgView.layer.cornerRadius = 8

        bgCompPetSetImg.layer.cornerRadius = bgCompPetSetImg.bounds.size.width / 2
        bgCompPetSetImg2.layer.cornerRadius = bgCompPetSetImg2.bounds.size.width / 2
        bgCompPetFirstImg.layer.cornerRadius = bgCompPetFirstImg.bounds.size.width / 2
        bgCompPetSecondImg.layer.cornerRadius = bgCompPetSecondImg.bounds.size.width / 2

        bgCompPetSetImg.layer.shadowRadius = 2
        bgCompPetSetImg.layer.shadowOpacity = 0.2
        bgCompPetSetImg.layer.shadowOffset = CGSize(width: 2, height: 4)
        bgCompPetFirstImg.layer.shadowRadius = 2
        bgCompPetFirstImg.layer.shadowOpacity = 0.2
        bgCompPetFirstImg.layer.shadowOffset = CGSize(width: 2, height: 4)
        bgCompPetSecondImg.layer.shadowRadius = 2
        bgCompPetSecondImg.layer.shadowOpacity = 0.2
        bgCompPetSecondImg.layer.shadowOffset = CGSize(width: 2, height: 4)

        compPetSetImg.image = UIImage(named: "icon_animallist")
        compPetFirstImg.image = UIImage(named: "profile_default")
        compPetSecondImg.image = UIImage(named: "profile_default")

        compPetFirstImg.layer.cornerRadius = compPetFirstImg.bounds.size.width / 2
        compPetSecondImg.layer.cornerRadius = compPetSecondImg.bounds.size.width / 2

        compPetListLabel.attributedText = NSAttributedString(string: compPetListLabel.text!,
                                                             attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])

        bgCompPetWalkInfo.layer.cornerRadius = 20
        bgCompPetWalkInfo.layer.shadowRadius = 2
        bgCompPetWalkInfo.layer.shadowOpacity = 0.15
        bgCompPetWalkInfo.layer.shadowOffset = CGSize(width: 2, height: 4)

        bgCompPetWalkTimeIcon.layer.cornerRadius = 10
        bgCompPetWalkDistIcon.layer.cornerRadius = 10
    }





    // MARK: - SELECT MY PET

    var selectPetView: SelectPetView! = nil

    func showSelectMyPet() {
        if (dailyLifePets == nil || dailyLifePets?.pets.count == 0) {
            return
        }

        bottomSheetVC = BottomSheetViewController()
        bottomSheetVC.modalPresentationStyle = .overFullScreen
        bottomSheetVC.dismissIndicatorView.isHidden = true
//        bottomSheetVC.isDynamicHeight = true
        if let v = UINib(nibName: "SelectPetView", bundle: nil).instantiate(withOwner: self).first as? SelectPetView {
            bottomSheetVC.addContentSubView(v: v)
            v.initialize()
            v.setData(dailyLifePets?.pets as Any)
            v.setSelected(self.selectedPetIndex)
            v.setDelegate(self)
        }
        self.present(bottomSheetVC, animated: false, completion: nil)
    }





    // MARK: - COMPANION PET LIST

    var bottomSheetVC: BottomSheetViewController! = nil
    var compPetListView: CompPetListView! = nil

    func showCompPetListBottomSheet() {
        if (myPetList == nil || myPetList?.myPets.count == 0) {
            return
        }

        bottomSheetVC = BottomSheetViewController()
        bottomSheetVC.modalPresentationStyle = .overFullScreen
        bottomSheetVC.dismissIndicatorView.isHidden = true
        bottomSheetVC.isDynamicHeight = true
        if let v = UINib(nibName: "CompPetListView", bundle: nil).instantiate(withOwner: self).first as? CompPetListView {
            bottomSheetVC.addContentSubView(v: v)
            v.initialize()
            v.setData(myPetList?.myPets as Any)
            v.setDelegate(self)
            compPetListView = v
            if let _myPetList = myPetList {
                if _myPetList.myPets.count > 0 { v.tableView.selectRow(at: NSIndexPath(row: 0, section: 0) as IndexPath, animated: false, scrollPosition: .none) }
            }
        }
        self.present(bottomSheetVC, animated: false, completion: nil)
    }

    @IBAction func onShowCompPetListBottomSheet(_ sender: Any) {
        showCompPetListBottomSheet()
    }





    // MARK: - WEATHER INFO

    @IBOutlet weak var iv_weather: UIImageView!
    @IBOutlet weak var lb_temp: UILabel!
    @IBOutlet weak var lb_per: UILabel!

    private func requestCurrLocationForWeather() {
        requestLocation(type: 1)
    }

    override func updateCurrLocation(_ locations: [CLLocation]) {
        super.updateCurrLocation(locations)

        guard let recentLoc = locations.last else { return }

        startLoading()

        let lat = (recentLoc.coordinate.latitude)
        let lon = (recentLoc.coordinate.longitude)
        let request = WeatherRequest(lat: String(lat), lon: String(lon))
        WeatherAPI.weather(request: request) { weather, error in
            self.stopLoading()
            // self.processNetworkError(error)

            if let weather = weather {
                var temp: String! = nil
                var sky: String! = nil
                var pty: String! = nil
                var per: String! = nil
                var imageName: String! = nil

                for weatherData in weather.items {
                    if weatherData.category == "TMP" {
                        temp = weatherData.fcstValue
                    }
                    if weatherData.category == "PTY" {
                        pty = weatherData.fcstValue
                    }
                    if weatherData.category == "SKY" {
                        sky = weatherData.fcstValue
                    }
                    if weatherData.category == "POP" {
                        per = weatherData.fcstValue
                    }
                }

                var isNight: Bool = true
                let df = DateFormatter()
                df.dateFormat = "HH"
                let ch = Int(df.string(from: Date()))
                if let ch = ch {
                    if (ch >= 6 && ch < 18) {
                        isNight = false
                    }
                }

                if pty == "0" {
                    if sky == "1" {
                        imageName = isNight ? "night_ver2" : "sunny_ver2"
                    } else if sky == "3" {
                        imageName = isNight ? "cloudy_night_ver2" : "cloudy_day_ver2"
                    } else if sky == "4" {
                        imageName = "fog_ver2"
                    } else {
                        imageName = "sunny_ver2"
                    }

                } else {
                    if sky == "1" {
                        imageName = "rainy_ver2"
                    } else if sky == "2" {
                        imageName = "rainyandsnowy_ver2"
                    } else if sky == "3" {
                        imageName = "snowy_ver2"
                    } else if sky == "4" {
                        imageName = "shower_ver2"
                    } else {
                        imageName = "rainy_ver2"
                    }
                }

                self.iv_weather.image = UIImage(named: imageName)
                self.lb_temp.text = String("현재 기온 : \(temp!)℃")
                self.lb_per.text = String("강수 : \(per!)%")
            }

            // if let error = error { self.showSimpleAlert(title: "날씨오류", msg: error.localizedDescription) }
            NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][error:\(String(describing: error))][weather:\(String(describing: weather))]")
        }
    }





    // MARK: - REALTIME STORY

    @IBOutlet weak var storyCollectionView: UICollectionView!

    var realTimeList: RealTimeList? = nil

    var currStoryItemIndex: CGFloat = 0

    func story_realTimeList() {
        startLoading()

        let request = RealTimeListRequest()
        StoryAPI.realTimeList(request: request) { realTimeList, error in
            self.stopLoading()

            if let realTimeList = realTimeList {
                self.realTimeList = realTimeList
            }

            if let error = error {
                self.realTimeList = nil
                self.showSimpleAlert(title: "RealTimeList fail", msg: error.localizedDescription)
            }

            self.storyCollectionView.reloadData()
        }
    }

    private func showRealtimeStory() {
        let cellWidth = 200
        let cellHeight = 280

        //let insetX = (storyCollectionView.bounds.width - CGFloat(cellWidth)) / 2.0
        let insetX = CGFloat(20)
        //let insetY = (storyCollectionView.bounds.height - CGFloat(cellHeight)) / 2.0
        let insetY = CGFloat(0)

        let layout = storyCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.minimumLineSpacing = 12
        layout.scrollDirection = .horizontal
        storyCollectionView.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)

        storyCollectionView.delegate = self
        storyCollectionView.dataSource = self

        // 스크롤 시 빠르게 감속 되도록 설정
        storyCollectionView.decelerationRate = UIScrollView.DecelerationRate.fast

        story_realTimeList()
    }

    @IBAction func onMoreStory(_ sender: Any) {
        self.tabBarController?.selectedIndex = 2
    }





    // MARK: - FSPager

    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
            pagerView.register(UINib.init(nibName: "PetProfItemView", bundle: nil), forCellWithReuseIdentifier: "PetProfItemView")
        }
    }

    private func fsPagerInit() {
        pagerView.delegate = self
        pagerView.dataSource = self
        pagerView.isInfinite = false

        pagerView.transformer = FSPagerViewTransformer(type: .overlap)
        pagerView.transformer?.minimumAlpha = 0.4
        let transform: CGAffineTransform = CGAffineTransformMakeScale(0.2, 0.2)
        self.pagerView.itemSize = CGSizeApplyAffineTransform(CGSize(width: 900, height: 900), transform)
        self.pagerView.decelerationDistance = 1 // FSPagerViewAutomaticDistance
    }





    // MARK: - Top LogoTitleBar

    @IBOutlet weak var titleBarView: UIView!

    var titleBarPfImageView: UIImageView!
    var titleBarPfNMLabel: UILabel!

    func showLogoTitleBarView() {
        if let view = UINib(nibName: "LogoTitleBarView", bundle: nil).instantiate(withOwner: self).first as? LogoTitleBarView {
            view.frame = titleBarView.bounds
            titleBarPfImageView = view.profileImageView
            titleBarPfNMLabel = view.profileNameLabel
            view.delegate = self
            titleBarView.addSubview(view)
            view.initialize()
        }
    }





    // MARK: - Bottom TabBar

    private func customBottomTabBar() {
        if let tbc = self.tabBarController {
            tbc.delegate = self

            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)], for: .normal)

            tbc.tabBar.layer.applyShadow(color: .gray, alpha: 0.3, x: 0, y: 0, blur: 12)
            tbc.tabBar.backgroundColor = UIColor.white

            tbc.tabBar.items?[0].image = UIImage(named: "home")
            tbc.tabBar.items?[0].selectedImage = UIImage(named: "home_active")?.withRenderingMode(.alwaysOriginal)
            tbc.tabBar.items?[0].title = "홈"

            tbc.tabBar.items?[1].image = UIImage(named: "walk")
            tbc.tabBar.items?[1].selectedImage = UIImage(named: "walk_active")?.withRenderingMode(.alwaysOriginal)
            tbc.tabBar.items?[1].title = "산책"

            tbc.tabBar.items?[2].image = UIImage(named: "community")
            tbc.tabBar.items?[2].selectedImage = UIImage(named: "community_active")?.withRenderingMode(.alwaysOriginal)
            tbc.tabBar.items?[2].title = "커뮤니티"

            tbc.tabBar.items?[3].image = UIImage(named: "mypage")
            tbc.tabBar.items?[3].selectedImage = UIImage(named: "mypage_active")?.withRenderingMode(.alwaysOriginal)
            tbc.tabBar.items?[3].title = "MY"

            tbc.tabBar.selectionIndicatorImage = UIImage().createSelectionIndicator(color: UIColor.init(hexCode: "#4783f5"), size: CGSize(width: tbc.tabBar.frame.width / CGFloat(tbc.tabBar.items!.count) / 2.5, height: tbc.tabBar.frame.height), lineThickness: 4.0, side: .top)
        }
    }
}





// MARK: - FSPager Delegate

extension MainViewController: FSPagerViewDataSource, FSPagerViewDelegate {

    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        if let pets = dailyLifePets?.pets {
            if (pets.count == 0) { return 1 }
            return pets.count
        }

        return 1
    }

    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "PetProfItemView", at: index) as! PetProfItemView

        if let pets = dailyLifePets?.pets {
            if (pets.count > 0) {
                if let petRprsImgAddr = pets[index].petRprsImgAddr {
                    cell.profileImageView.af.setImage(
                        withURL: URL(string: petRprsImgAddr)!,
                        placeholderImage: UIImage(named: "profile_default")!,
                        filter: AspectScaledToFillSizeFilter(size: cell.profileImageView.frame.size)
                    )
                } else {
                    cell.profileImageView.image = UIImage(named: "profile_default")
                }
            } else {
                cell.profileImageView.image = UIImage(named: "profile_default")
            }
        } else {
            cell.profileImageView.image = UIImage(named: "profile_default")
        }
        cell.initialize()

        return cell
    }

    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
    }

    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            Global.selectedPetIndexBehaviorRelay.accept(targetIndex)
        })
    }
}





// MARK: - Realtime Story Delegate

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = realTimeList?.items.count {
            return count
        }

        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeStoryItemView", for: indexPath) as! HomeStoryItemView
        cell.initialize()

        if let realTimeList = realTimeList {
            if let storyImgSrc = realTimeList.items[indexPath.row].storyFile {
                cell.storyImgView.af.setImage(
                    withURL: URL(string: storyImgSrc)!,
                    placeholderImage: nil,
                    filter: AspectScaledToFillSizeFilter(size: cell.storyImgView.frame.size)
                )
            }

            cell.lb_schTtl.text = realTimeList.items[indexPath.row].schTTL
            cell.lb_petNM.text = realTimeList.items[indexPath.row].petNm
            cell.lb_cmdtnCnt.text = realTimeList.items[indexPath.row].rcmdtnCnt
            cell.lb_cmntCnt.text = realTimeList.items[indexPath.row].cmntCnt
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let realTimeList = realTimeList {
            Global.toSchUnqNo = realTimeList.items[indexPath.row].schUnqNo
            self.tabBarController?.selectedIndex = 2
        }
    }
}





// MARK: - COMPANION PET LIST DELEGATE

extension MainViewController: CompPetListViewProtocol {
    func onAddPet() {
        bottomSheetVC.hideBottomSheetAndGoBack()
        bottomSheetVC = nil

        compPetListView = nil

        let petAddViewController = UIStoryboard(name: "Pet", bundle: nil).instantiateViewController(identifier: "PetAddViewController") as PetAddViewController
        self.navigationController?.pushViewController(petAddViewController, animated: true)
    }

    func onPetManage(myPet: MyPet) {
        bottomSheetVC.hideBottomSheetAndGoBack()
        bottomSheetVC = nil

        compPetListView = nil

        let petProfileViewController = UIStoryboard(name: "Pet", bundle: nil).instantiateViewController(identifier: "PetProfileViewController") as PetProfileViewController
        petProfileViewController.petInfo = myPet

        self.navigationController?.pushViewController(petProfileViewController, animated: true)
    }
}





// MARK: - LOGO TITLE BAR VIEW DELEGATE

extension MainViewController: LogoTitleBarViewProtocol {
    func onShowSelectMyPet() {
        showSelectMyPet()
    }

    func onBack() {

    }
}





// MARK: - SELECT PET VIEW DELEGATE

extension MainViewController: SelectPetViewProtocol {
    func onSelectPet(_ selectedIdx: Int) {
        bottomSheetVC.hideBottomSheetAndGoBack()
        bottomSheetVC = nil

        selectPetView = nil

        pagerView.scrollToItem(at: selectedIdx, animated: true)
        Global.selectedPetIndexBehaviorRelay.accept(selectedIdx)
    }
}

