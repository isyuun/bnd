//
//  TestViewController.swift
//  PetTip
//
//  Created by carebiz on 12/8/23.
//

import UIKit

import Alamofire

import RxSwift
import RxCocoa

class TestViewController: CommonViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            // self.performSegue(withIdentifier: "showNaverMap", sender: self)
            //
            // self.showBottomSheet() // Dynamic height UISCrollView inside Custom View
            //
            // self.showSelectMyPet() // Horizontal UICollectionView inside Custom View
            //
            // self.connLogin() // Alamofire CONN

            self.rxTest()
        })
    }

    // MARK: - rxSwift + rxCocoa
    @IBAction func onRxAction(_ sender: Any) {
        //ccc.accept("1")
        image.accept(UIImage.init(named: "profile_default"))
    }

    let disposeBag = DisposeBag()

    let ccc = BehaviorRelay(value: "")
    let image = BehaviorRelay<UIImage?>(value: nil)
    let idx = BehaviorRelay<Int>(value: 0)

    func rxTest() {

        ccc.subscribe(onNext: { _ in
            self.rxTestAfter()
        }, onError: { _ in

        }).disposed(by: disposeBag)

        image.subscribe(onNext: { _ in
            self.rxTestAfter2()
        }).disposed(by: disposeBag)
    }

    func rxTestAfter() {
        print("# rxTestAfter")
    }

    func rxTestAfter2() {
        print("# rxTestAfter2")
    }

    // MARK: - Alamofire CONN
    @IBAction func onMemberLogin(_ sender: Any) {
        self.member_Login()
    }

    func member_Login() {
        let request = LoginRequest(appTypNm: getModel(), userID: "cheongyh@nate.com", userPW: "pt1122")
        MemberAPI.login(request: request) { login, error in
            if let login = login {
                let userDef = UserDefaults.standard
                userDef.set(login.accessToken, forKey: "accessToken")
                userDef.set(login.refreshToken, forKey: "refreshToken")
                userDef.set(login.userId, forKey: "userId")
                userDef.synchronize()
                // KeychainServiceImpl.shared.accessToken = login.accessToken
                // KeychainServiceImpl.shared.refreshToken = login.refreshToken

                self.showSimpleAlert(title: "Login success", msg: "User \(login.nckNm)님 환영~")
            }

            if let error = error {
                // let userDef = UserDefaults.standard
                // userDef.removeObject(forKey: "accessToken")
                // userDef.removeObject(forKey: "refreshToken")
                // userDef.synchronize()

                self.showSimpleAlert(title: "Login fail", msg: error.description)
            }
        }
    }

    @IBAction func onMemberRefreshToken(_ sender: Any) {
        self.member_RefreshToken()
    }
    func member_RefreshToken() {
        let request = RefreshTokenRequest(refreshToken: UserDefaults.standard.value(forKey: "refreshToken")! as! String)
        MemberAPI.refreshToken(request: request) { refreshToken, error in
            if let refreshToken = refreshToken {
                let userDef = UserDefaults.standard
                userDef.set(refreshToken.accessToken, forKey: "accessToken")
                userDef.set(refreshToken.refreshToken, forKey: "refreshToken")
                userDef.synchronize()
                // KeychainServiceImpl.shared.accessToken = refreshToken.accessToken
                // KeychainServiceImpl.shared.refreshToken = refreshToken.refreshToken
                self.showSimpleAlert(title: "RefreshToken success", msg: "token refresh success")
            }

            if let error = error {
                self.showSimpleAlert(title: "RefreshToken fail", msg: error.localizedDescription)
            }
        }
    }

    @IBAction func onDailyLifePetList(_ sender: Any) {
        self.dailyLife_PetList()
    }
    func dailyLife_PetList() {
        let request = PetListRequest(userId: UserDefaults.standard.value(forKey: "userId")! as! String)
        DailyLifeAPI.petList(request: request) { petList, error in
            if let petList = petList {

                self.showSimpleAlert(title: "PetList success", msg: "\(petList.pets.count)마리 등록중... 첫번째 펫 이름은 \(petList.pets.first!.petNm)")
            }

            if let error = error {
                self.showSimpleAlert(title: "PetList fail", msg: error.localizedDescription)
            }
        }
    }

    @IBAction func onMyPetList(_ sender: Any) {
        self.myPet_list()
    }
    func myPet_list() {
        let request = MyPetListRequest(userId: UserDefaults.standard.value(forKey: "userId")! as! String)
        MyPetAPI.list(request: request) { myPetList, error in
            if let myPetList = myPetList {

                self.showSimpleAlert(title: "MyPetList success", msg: "마이펫 \(myPetList.myPets.count)마리 등록중... 첫번째 펫 이름은 \(myPetList.myPets.first!.petNm)")
            }

            self.processNetworkError(error)
        }
    }

    func getModel() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let model = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        print("#model: ", model)
        return model
    }

    // MARK: - Horizontal UICollectionView inside Custom View
    @IBAction func onShowSelectMyPet(_ sender: Any) {
        self.showSelectMyPet() // Dynamic height UISCrollView inside Custom View
    }

    // let pets: Array<String> = []
    // let pets = ["aaa"]
    // let pets = ["aaa", "bbb"]
    // let pets = ["aaa", "bbb", "ccc"]
    // let pets = ["aaa", "bbb", "ccc", "ddd"]
    let pets = ["aaa", "bbb", "ccc", "ddd", "eee", "fff", "ggg"]

    // var selectPetView: SelectPetView! = nil

    func showSelectMyPet() {

        self.bottomSheetVC = BottomSheetViewController()
        if let bottomSheetVC = self.bottomSheetVC {
            bottomSheetVC.modalPresentationStyle = .overFullScreen
            bottomSheetVC.dismissIndicatorView.isHidden = true
            // bottomSheetVC.isDynamicHeight = true
            if let v = UINib(nibName: "SelectPetView", bundle: nil).instantiate(withOwner: self).first as? SelectPetView {
                bottomSheetVC.addContentSubView(v: v)
                v.initialize()
                v.setData(pets)
                // v.setDelegate(self)
                // selectPetView = v
                // if (names.count > 0) { v.tableView.selectRow(at: NSIndexPath(row: 0, section: 0) as IndexPath, animated: false, scrollPosition: .none) }
            }
            self.present(bottomSheetVC, animated: false, completion: nil)
        }
    }

    // MARK: - Dynamic height UISCrollView inside Custom View
    @IBAction func onShowCompPetList(_ sender: Any) {
        self.showBottomSheet() // Dynamic height UISCrollView inside Custom View
    }

    // let names: Array<String> = []
    // let names = ["aaa"]
    // let names = ["aaa", "bbb"]
    // let names = ["aaa", "bbb", "ccc"]
    let names = ["aaa", "bbb", "ccc", "ddd"]

    // TestTableViewInSheetView

    var bottomSheetVC: BottomSheetViewController? = nil
    var compPetListView: CompPetListView? = nil

    func showBottomSheet() {
        // self.bottomSheetVC = BottomSheetViewController()
        // if let bottomSheetVC = self.bottomSheetVC {
        //     bottomSheetVC.modalPresentationStyle = .overFullScreen
        //     bottomSheetVC.dismissIndicatorView.isHidden = true
        //     bottomSheetVC.isDynamicHeight = true
        //     if let v = UINib(nibName: "CompPetListView", bundle: nil).instantiate(withOwner: self).first as? CompPetListView {
        //         bottomSheetVC.addContentSubView(v: v)
        //         v.initialize()
        //         v.setData(names)
        //         v.setDelegate(self)
        //         compPetListView = v
        //         if (names.count > 0) { v.tableView.selectRow(at: NSIndexPath(row: 0, section: 0) as IndexPath, animated: false, scrollPosition: .none) }
        //     }
        //     self.present(bottomSheetVC, animated: false, completion: nil)
        // }
    }
}

extension TestViewController: CompPetListViewProtocol {
    func onAddPet() { }
    func onPetManage(myPet: MyPet) { }
}
