//
//  MyPageViewController.swift
//  PetTip
//
//  Created by carebiz on 12/3/23.
//

import UIKit
import RxSwift
import RxRelay

class MyPageViewController: CommonViewController, SelectPetViewProtocol {

    @IBOutlet weak var lb_title: UILabel!
    @IBOutlet weak var iv_prof: UIImageView!
    @IBOutlet weak var lb_userNm: UILabel!

    @IBOutlet weak var cr_tvCompPetHeight: NSLayoutConstraint!
    @IBOutlet weak var tv_compPet: UITableView!

    @IBOutlet weak var vw_csBtnIconBg: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        showCommonUI()
    }

    private func showCommonUI() {
        lb_title.text = "마이페이지"

        iv_prof.layer.cornerRadius = iv_prof.bounds.size.width / 2
        iv_prof.layer.masksToBounds = true

        lb_userNm.text = "USER"
        if let nckNm = UserDefaults.standard.value(forKey: "nckNm") as? String {
            lb_userNm.text = nckNm
            Global.userNckNmBehaviorRelay.accept(nckNm)
        }

        tv_compPet.register(UINib(nibName: "MyPageCompPetListItemView", bundle: nil), forCellReuseIdentifier: "MyPageCompPetListItemView")
        tv_compPet.register(UINib(nibName: "MyPageCompPetListIEmptytemView", bundle: nil), forCellReuseIdentifier: "MyPageCompPetListIEmptytemView")
        tv_compPet.delegate = self
        tv_compPet.dataSource = self
        tv_compPet.separatorStyle = .none

        vw_csBtnIconBg.layer.cornerRadius = vw_csBtnIconBg.bounds.size.width / 2
        vw_csBtnIconBg.layer.masksToBounds = true
    }

    private let disposeBag = DisposeBag()

    var myPetList: MyPetList?
    var dailyLifePetList: PetList?

    internal func initRx() {
        Global.myPetList.subscribe(onNext: { [weak self] myPetList in
            self?.refreshMyPetList(data: myPetList)
        }).disposed(by: disposeBag)

        Global.dailyLifePetList.subscribe(onNext: { [weak self] petList in
            self?.refreshDailyLifePetList(data: petList)
        }).disposed(by: disposeBag)

        Global.userNckNm.subscribe(onNext: { [weak self] nckNm in
            self?.refreshUserNckNm(data: nckNm)
        }).disposed(by: disposeBag)
    }

    internal func refreshMyPetList(data: MyPetList?) {
        guard let myPetList = data else { return }
        self.myPetList = myPetList
        self.tv_compPet.reloadData()
    }

    internal func refreshDailyLifePetList(data: PetList?) {
        guard let petList = data else { return }
        self.dailyLifePetList = petList
    }

    private func refreshUserNckNm(data: String?) {
        guard let userNckNm = data else { return }
        self.lb_userNm.text = userNckNm
    }

    @IBAction func onLogout(_ sender: Any) {
        logout()
    }

    internal func logout() {
        self.startLoading()

        let request = LogoutRequest()
        MemberAPI.logout(request: request) { response, error in
            self.stopLoading()

            self.logoutCallback()

            self.processNetworkError(error)
        }
    }

    private func logoutCallback() {
        let userDef = UserDefaults.standard
        userDef.removeObject(forKey: "accessToken")
        userDef.removeObject(forKey: "refreshToken")
        userDef.synchronize()

        self.moveLoginPage()
    }

    var bottomSheetVC: BottomSheetViewController? = nil

    var selectPetView: SelectPetView! = nil

    func showSelectMyPetForInvite() {
        if (dailyLifePetList == nil || dailyLifePetList?.pets.count == 0) {
            self.showToast(msg: "등록된 펫이 없습니다")
            return
        }

        if let v = UINib(nibName: "SelectInvitePetView", bundle: nil).instantiate(withOwner: self).first as? SelectInvitePetView {
            v.initialize()
            v.setData(dailyLifePetList?.pets as Any)
            v.lb_title.text = "누구를 위해 초대를 할까요?"
            v.btn_select.setAttrTitle("초대하기", 14)
            v.isSingleSelectMode = false
            v.didTapOK = { selectedPets, endDt in
                self.didTapPopupOK()

                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyyMMddHHmm"
                let nowDt = dateFormatter.string(from: Date())

                self.invtt_create(pets: selectedPets, beginDt: nowDt, endDt: endDt)
            }

            self.popupShow(contentView: v, wSideMargin: 0, type: .bottom)
        }
    }

    func invtt_create(pets: [Pet], beginDt: String, endDt: String) {
        // self.startLoading()
        // 
        // let request = MyPetInvttCreateRequest(pet: pets, relBgngDt: beginDt, relEndDt: endDt)
        // MyPetAPI.invttCreate(request: request) { response, error in
        //     self.stopLoading()
        // 
        //     if let response = response {
        //         self.performSegue(withIdentifier: "segueMyPageToInviteCreate", sender: response.invttKeyVl)
        //     }
        // 
        //     self.processNetworkError(error)
        // }
    }

    @IBAction func onInvite(_ sender: Any) {
        showSelectMyPetForInvite()
    }

    @IBAction func onAddCompPet(_ sender: Any) {
        let showItemStoryboard = UIStoryboard(name: "Pet", bundle: nil)
        let petAddViewController = showItemStoryboard.instantiateViewController(withIdentifier: "PetAddViewController") as! PetAddViewController
        self.navigationController?.pushViewController(petAddViewController, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueMyPageToInviteCreate") {
            let dest = segue.destination
            guard let vc = dest as? InviteCreateViewController else { return }
            vc.invttKeyVl = sender as? String
        }
    }

    // MARK: - SELECT PET VIEW DELEGATE
    func onSelectPet(_ selectedIdx: Int) {
        bottomSheetVC?.hideBottomSheetAndGoBack()
        bottomSheetVC = nil

        selectPetView = nil
    }
}

// MARK: - UITableView Delegate
extension MyPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = myPetList?.myPets.count else { return 1 }
        if count == 0 {
            return 1
        } else {
            return count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let count = myPetList?.myPets.count else { return UITableViewCell() }
        if count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyPageCompPetListIEmptytemView", for: indexPath) as! MyPageCompPetListIEmptytemView
            cell.initialize()

            tv_compPet.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            cr_tvCompPetHeight.constant = cell.frame.size.height + (tv_compPet.contentInset.top + tv_compPet.contentInset.bottom)

            return cell

        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyPageCompPetListItemView", for: indexPath) as! MyPageCompPetListItemView
            if let pet = myPetList?.myPets[indexPath.row] { cell.initialize(myPet: pet) }

            if count == 1 {
                cr_tvCompPetHeight.constant = cell.frame.size.height
            } else if count == 2 {
                cr_tvCompPetHeight.constant = cell.frame.size.height * 2
            } else {
                cr_tvCompPetHeight.constant = cell.frame.size.height * 3
            }

            tv_compPet.contentInset = UIEdgeInsets(top: -4, left: 0, bottom: -4, right: 0)
            cr_tvCompPetHeight.constant += (tv_compPet.contentInset.top + tv_compPet.contentInset.bottom)

            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let petProfileViewController = UIStoryboard(name: "Pet", bundle: nil).instantiateViewController(identifier: "PetProfileViewController") as PetProfileViewController2
        petProfileViewController.myPet = myPetList?.myPets[indexPath.row]

        self.navigationController?.pushViewController(petProfileViewController, animated: true)
    }
}
