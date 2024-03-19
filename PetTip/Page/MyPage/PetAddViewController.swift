//
//  AddPetViewController.swift
//  PetTip
//
//  Created by carebiz on 1/6/24.
//

import UIKit

class PetAddViewController: CommonViewController {
    
    public var memberData: MemberJoinData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        
        showBackTitleBarView()
        
        showCommonUI()
    }
    
    
    
    
    
    @IBOutlet weak var vw_profileBg: UIView!
    @IBOutlet weak var vw_profileIv: UIView!
    @IBOutlet weak var iv_profile: UIImageView!
    @IBOutlet weak var btn_profile: UIButton!
    
    @IBOutlet weak var btn_petTypeDog, btn_petTypeCat: UIButton!
    
    @IBOutlet weak var vw_petKindBg: UIView!
    @IBOutlet weak var lb_petKind: UILabel!
    
    @IBOutlet weak var vw_addrBg: UIView!
    @IBOutlet weak var lb_addr: UILabel!
    
    @IBOutlet weak var tf_name: UITextField!
    
    @IBOutlet weak var tf_birth: UITextField!
    @IBOutlet weak var btn_birth_unkown: UIButton!
    @IBOutlet weak var iv_birth_unknown: UIImageView!
    @IBOutlet weak var vw_birth_unknown: UIView!
    
    @IBOutlet weak var tf_weight: UITextField!
    
    @IBOutlet weak var btn_sex_male, btn_sex_female, btn_sex_unknown: UIButton!
    
    @IBOutlet weak var btn_neuter_yes, btn_neuter_no, btn_neuter_unknown: UIButton!
    
    @IBOutlet weak var btn_complete: UIButton!
    
    @IBOutlet weak var btn_skipAddFromMemberJoin: UIButton!
    
    func showCommonUI() {
        self.vw_profileBg.layer.cornerRadius = self.vw_profileBg.bounds.size.width / 2
        self.vw_profileBg.layer.shadowRadius = 2
        self.vw_profileBg.layer.shadowOpacity = 0.2
        self.vw_profileBg.layer.shadowColor = UIColor.init(hex: "#70000000")?.cgColor
        self.vw_profileBg.layer.shadowOffset = CGSize(width: 2, height: 3)
        
        self.vw_profileIv.backgroundColor = UIColor.white
        self.vw_profileIv.layer.cornerRadius = self.vw_profileIv.bounds.size.width / 2
        self.vw_profileIv.layer.borderColor = UIColor.init(hex: "#4E608526")?.cgColor
        self.vw_profileIv.layer.borderWidth = 1
        self.vw_profileIv.layer.masksToBounds = true
        
        self.iv_profile.backgroundColor = UIColor.white
        self.iv_profile.layer.cornerRadius = self.iv_profile.bounds.size.width / 2
        self.iv_profile.layer.masksToBounds = true
        self.iv_profile.image = UIImage(named: "profile_default")
        self.iv_profile.contentMode = .scaleAspectFill
        
        self.btn_profile.layer.cornerRadius = self.btn_profile.bounds.size.width / 2
        self.btn_profile.layer.masksToBounds = true
        
        btn_petTypeDog.titleLabel?.text = "강아지"
        btn_petTypeDog.isSelected = true
        btnSelectedUI(view: btn_petTypeDog)
        
        btn_petTypeCat.titleLabel?.text = "고양이"
        btn_petTypeCat.isSelected = false
        btnNormalUI(view: btn_petTypeCat)
        
        lb_petKind.text = "사이즈 / 품종 선택"
        btnNormalUI(view: vw_petKindBg)
        
        lb_addr.text = "주소 선택"
        btnNormalUI(view: vw_addrBg)
        
        tf_name.delegate = self
        tfNormalUI(view: tf_name)
        
        tf_birth.delegate = self
        tfNormalUI(view: tf_birth)
        iv_birth_unknown.image = UIImage.imageFromColor(color: UIColor.clear)
        btn_birth_unkown.isSelected = false
        vw_birth_unknown.backgroundColor = UIColor.white
        vw_birth_unknown.layer.cornerRadius = 2
        vw_birth_unknown.layer.borderWidth = 1
        vw_birth_unknown.layer.borderColor = UIColor.init(hex: "#FFE3E9F2")?.cgColor
        
        tf_weight.delegate = self
        tfNormalUI(view: tf_weight)
        
        btn_sex_male.titleLabel?.text = "남아"
        btn_sex_male.isSelected = true
        btnSelectedUI(view: btn_sex_male)
        
        btn_sex_female.titleLabel?.text = "여아"
        btn_sex_female.isSelected = false
        btnNormalUI(view: btn_sex_female)
        
        btn_sex_unknown.titleLabel?.text = "모름"
        btn_sex_unknown.isSelected = false
        btnNormalUI(view: btn_sex_unknown)
        
        btn_neuter_yes.titleLabel?.text = "했어요"
        btn_neuter_yes.isSelected = true
        btnSelectedUI(view: btn_neuter_yes)
        
        btn_neuter_no.titleLabel?.text = "안했어요"
        btn_neuter_no.isSelected = false
        btnNormalUI(view: btn_neuter_no)
        
        btn_neuter_unknown.titleLabel?.text = "모름"
        btn_neuter_unknown.isSelected = false
        btnNormalUI(view: btn_neuter_unknown)
        
        if memberData == nil {
            btn_complete.setAttrTitle("등록하기", 14, UIColor.white)
            btn_skipAddFromMemberJoin.isHidden = true
        } else {
            btn_complete.setAttrTitle("가입하기", 14, UIColor.white)
            btn_skipAddFromMemberJoin.isHidden = false
        }
        
        btn_skipAddFromMemberJoin.setAttributedTitle(NSAttributedString(string: "건너뛰기", attributes: 
            [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
            .font : UIFont.systemFont(ofSize: CGFloat(14)),
             .foregroundColor : UIColor.init(hex: "#FF737980")!]), for: .normal)
    }
    
    @IBAction func onContentViewTap(_ sender: Any) {
        reqCloseKeyboard()
    }
    
    private func reqCloseKeyboard() {
        tf_name.resignFirstResponder()
        tf_birth.resignFirstResponder()
        tf_weight.resignFirstResponder()
    }
    
    @IBAction func onPetType(_ sender: Any) {
        guard let button = sender as? UIButton else { return }
        
        if button == btn_petTypeDog {
            btnSelectedUI(view: btn_petTypeDog)
            btnNormalUI(view: btn_petTypeCat)
            btn_petTypeDog.isSelected = true
            btn_petTypeCat.isSelected = false
            
        } else if button == btn_petTypeCat {
            btnNormalUI(view: btn_petTypeDog)
            btnSelectedUI(view: btn_petTypeCat)
            btn_petTypeDog.isSelected = false
            btn_petTypeCat.isSelected = true
        }
        
        selectedPetKind = nil
        lb_petKind.text = "사이즈 / 품종 선택"
    }
    
    @IBAction func onBirth(_ sender: Any) {
        if btn_birth_unkown.isSelected { return }
        
        showSelectBirthDayPopup()
    }
    
    @IBAction func onBirthUnknownCheck(_ sender: Any) {
        btn_birth_unkown.isSelected.toggle()
        if btn_birth_unkown.isSelected {
            iv_birth_unknown.image = UIImage(named: "checkbox_white")
            vw_birth_unknown.backgroundColor = UIColor.init(hex: "#FF4783F5")
            
            self.tf_birth.text = ""
            
        } else {
            iv_birth_unknown.image = UIImage.imageFromColor(color: UIColor.clear)
            vw_birth_unknown.backgroundColor = UIColor.white
        }
    }
    
    func showSelectBirthDayPopup() {
        reqCloseKeyboard()
        
        tfSelectedUI(view: tf_birth)
        
        if let v = UINib(nibName: "DatePickerView", bundle: nil).instantiate(withOwner: self).first as? DatePickerView {
            v.initialize()
            v.datePicker.preferredDatePickerStyle = .wheels
            v.datePicker.datePickerMode = .date
            v.didTapOK = { datetime in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyyMMddHHmm"
                let date = dateFormatter.date(from: datetime)
                
                if Date().dateCompare(fromDate: date!) == "Future" {
                    self.showToast(msg: "생일이 현재보다 미래일 수는 없어요")
                    
                } else {
                    let dateFormatter2 = DateFormatter()
                    dateFormatter2.dateFormat = "yyyy년 MM월 dd일"
                    self.tf_birth.text = dateFormatter2.string(from: date!)
                    
                    self.didTapPopupOK()
                    self.tfNormalUI(view: self.tf_birth)
                }
            }
            v.didTapCancel = {
                self.didTapPopupCancel()
                self.tfNormalUI(view: self.tf_birth)
            }
            
            popupShow(contentView: v, wSideMargin: 0)
        }
    }
    
    @IBAction func onSex(_ sender: Any) {
        guard let button = sender as? UIButton else { return }
        
        if button == btn_sex_male {
            btnSelectedUI(view: btn_sex_male)
            btnNormalUI(view: btn_sex_female)
            btnNormalUI(view: btn_sex_unknown)
            btn_sex_male.isSelected = true
            btn_sex_female.isSelected = false
            btn_sex_unknown.isSelected = false
            
        } else if button == btn_sex_female {
            btnNormalUI(view: btn_sex_male)
            btnSelectedUI(view: btn_sex_female)
            btnNormalUI(view: btn_sex_unknown)
            btn_sex_male.isSelected = false
            btn_sex_female.isSelected = true
            btn_sex_unknown.isSelected = false
            
        } else if button == btn_sex_unknown {
            btnNormalUI(view: btn_sex_male)
            btnNormalUI(view: btn_sex_female)
            btnSelectedUI(view: btn_sex_unknown)
            btn_sex_male.isSelected = false
            btn_sex_female.isSelected = false
            btn_sex_unknown.isSelected = true
        }
    }
    
    @IBAction func onNeuter(_ sender: Any) {
        guard let button = sender as? UIButton else { return }
        
        if button == btn_neuter_yes {
            btnSelectedUI(view: btn_neuter_yes)
            btnNormalUI(view: btn_neuter_no)
            btnNormalUI(view: btn_neuter_unknown)
            btn_neuter_yes.isSelected = true
            btn_neuter_no.isSelected = false
            btn_neuter_unknown.isSelected = false
            
        } else if button == btn_neuter_no {
            btnNormalUI(view: btn_neuter_yes)
            btnSelectedUI(view: btn_neuter_no)
            btnNormalUI(view: btn_neuter_unknown)
            btn_neuter_yes.isSelected = false
            btn_neuter_no.isSelected = true
            btn_neuter_unknown.isSelected = false
            
        } else if button == btn_neuter_unknown {
            btnNormalUI(view: btn_neuter_yes)
            btnNormalUI(view: btn_neuter_no)
            btnSelectedUI(view: btn_neuter_unknown)
            btn_neuter_yes.isSelected = false
            btn_neuter_no.isSelected = false
            btn_neuter_unknown.isSelected = true
        }
    }
    
    private func integrityCheck() -> Bool {
        if selectedPetKind == nil {
            showToast(msg: "펫 종류를 선택해주세요")
            return false
        // } else if selectedSido == nil || selectedSigungu == nil {
        //     showToast(msg: "주소를 입력해주세요")
        //     return false
        } else if let name = tf_name.text, name.count == 0 {
            showToast(msg: "이름을 입력해주세요")
            return false
        } else if btn_birth_unkown.isSelected == false, let birth = tf_birth.text, birth.count == 0 {
            showToast(msg: "생일을 입력해주세요")
            return false
            
        } else if let weight = tf_weight.text, weight.count == 0 {
            showToast(msg: "몸무게를 입력해주세요")
            return false
        }
        return true
    }
    
    private func getBirthData() -> String {
        if btn_birth_unkown.isSelected {
            return "미상"
            
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy년 MM월 dd일"
            let birthdayDt = dateFormatter.date(from: tf_birth.text!)
           
            let dateFormatter2 = DateFormatter()
            dateFormatter2.dateFormat = "yyyyMMdd"
            let birthdayStr = dateFormatter2.string(from: birthdayDt!)
            
            return birthdayStr
        }
    }
    
    @IBAction func onComplete(_ sender: Any) {
        guard integrityCheck() else { return }
        
        if memberData == nil {
            myPet_create()
            
        } else {
            create_user(bAddPet: true)
        }
    }
    
    func myPet_create() {
        let petRelCd = "001"
        let petNm = tf_name.text!
        let petRegNo = "Y"
        let stdgSggCd = selectedSigungu == nil ? "" : selectedSigungu!.sggCD        //isyuun
        let petInfoUnqNo = String(selectedPetKind!.petInfoUnqNo)
        let petBrthYmd = getBirthData()
        let stdgUmdCd = selectedUpmeondong == nil ? "1" : selectedUpmeondong!.umdCD //isyuun
        let delYn = "N"
        let ntrTypCd = btn_neuter_yes.isSelected ? "001" : btn_neuter_no.isSelected ? "002" : "003"
        let petRprsYn = "Y"
        let sexTypCd = btn_sex_female.isSelected ? "001" : btn_sex_male.isSelected ? "002" : "003"
        let petMngrYn = "Y"
        let stdgCtpvCd = selectedSido == nil ? "" : String(selectedSido!.cdld)     //isyuun
        let wghtVl = Float(tf_weight.text!)!
        
        startLoading()
        
        let request = MyPetCreateRequest(petRelCd: petRelCd,
                                         petNm: petNm,
                                         petRegNo: petRegNo,
                                         stdgSggCd: stdgSggCd,
                                         petInfoUnqNo: petInfoUnqNo,
                                         petBrthYmd: petBrthYmd,
                                         stdgUmdCd: stdgUmdCd,
                                         delYn: delYn,
                                         file: img,
                                         ntrTypCd: ntrTypCd,
                                         petRprsYn: petRprsYn,
                                         sexTypCd: sexTypCd,
                                         petMngrYn: petMngrYn,
                                         stdgCtpvCd: stdgCtpvCd,
                                         wghtVl: wghtVl)
        MyPetAPI.create(request: request) { response, error in
            self.stopLoading()
            
            if let response = response {
                if response.statusCode == 200 {
                    if self.memberData == nil {
                        self.showAlertPopup(title: "알림", msg: response.resultMessage, didTapOK: {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                                self.myPet_list()
                            })
                        })
                        
                    } else {
                        self.moveMainPage()
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
    
    func myPet_list() {
        startLoading()
        
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
        startLoading()
        
        let request = PetListRequest(userId: UserDefaults.standard.value(forKey: "userId")! as! String)
        DailyLifeAPI.petList(request: request) { petList, error in
            self.stopLoading()
            
            if let petList = petList {
                Global.dailyLifePetsBehaviorRelay.accept(petList)
                Global.selectedPetIndexBehaviorRelay.accept(0)
                
                self.onBack()
            }
            
            if let error = error {
                self.showSimpleAlert(title: "PetList fail", msg: error.localizedDescription)
            }
        }
    }
    
    
    
    
    
    @IBAction func onSkipAddFromMemberJoin(_ sender: Any) {
        guard memberData != nil else {
            showToast(msg: "등록 중 장애가 발생했어요")
            return
        }
        
        create_user(bAddPet: false)
    }
    
    private func create_user(bAddPet: Bool) {
        guard let memberData = memberData else { return }
        
        startLoading()
        
        let request = CreateUserRequest(appKey: Global.appKey, appOs: "002", appTypNm: Util.getModel(), ncknm: memberData.nick, snsLogin: memberData.method, userID: memberData.id, userName: memberData.nick, userPW: memberData.pw)
        MemberAPI.createUser(request: request) { response, error in
            self.stopLoading()
            
            if let response = response {
                if let data = response.data, data.status == true {
                    self.member_Login(bAddPet: bAddPet)
                    
                } else {
                    self.showAlertPopup(title: response.resultMessage!, msg: response.detailMessage!, didTapOK: {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                            self.onBack()
                        })
                    })
                }
            }
            
            self.processNetworkError(error)
        }
    }
    
    func member_Login(bAddPet: Bool) {
        guard let memberData = memberData else { return }
        
        startLoading()
        
        let request = LoginRequest(appTypNm: Util.getModel(), userID: memberData.id, userPW: memberData.pw)
        MemberAPI.login(request: request) { login, error in
            self.stopLoading()
            
            if let login = login {
                let userDef = UserDefaults.standard
                userDef.set(login.accessToken, forKey: "accessToken")
                userDef.set(login.refreshToken, forKey: "refreshToken")
                userDef.set(login.userId, forKey: "userId")
                userDef.set(login.email, forKey: "email")
                userDef.set(login.nckNm, forKey: "nckNm")
                userDef.synchronize()
//                KeychainServiceImpl.shared.accessToken = login.accessToken
//                KeychainServiceImpl.shared.refreshToken = login.refreshToken
                
                if bAddPet {
                    self.myPet_create()
                    
                } else {
                    self.moveMainPage()
                }
            }
            
            self.processNetworkError(error)
        }
    }
    
    private func moveMainPage() {
        let tabBarControllerView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "TabBarControllerView") as UITabBarController
        self.navigationController?.pushViewController(tabBarControllerView, animated: true)
    }
    
    
    
    
    
    private var img: UIImage?
    
    @IBAction func onProfileImg(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false

            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    
    
    
    private func btnSelectedUI(view: UIView) {
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        
        view.layer.borderColor = UIColor(hex: "#ff4783f5")?.cgColor // SELECTED COLOR
        view.layer.backgroundColor = UIColor(hex: "#ffF6F8FC")?.cgColor // SELECTED COLOR
        
        view.layer.shadowColor = UIColor.init(hex: "#70000000")?.cgColor
        view.layer.shadowRadius = 2
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 1, height: 2)
        
        if view is UIButton, let btn = view as? UIButton {
            btn.setAttrTitle(btn.titleLabel!.text!, 14, UIColor.init(hex: "#FF4783F5")!)
        }
    }
    
    private func btnNormalUI(view: UIView) {
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        
        view.layer.borderColor = UIColor(hex: "#ffe3e9f2")?.cgColor // NORMAL COLOR
        view.layer.backgroundColor = UIColor(hex: "#ffffffff")?.cgColor // NORMAL COLOR
        
        view.layer.shadowColor = UIColor.clear.cgColor
        view.layer.shadowRadius = 0
        view.layer.shadowOpacity = 0
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        if view is UIButton, let btn = view as? UIButton {
            btn.setAttrTitle(btn.titleLabel!.text!, 14, UIColor.darkText)
        }
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
    
    
    
    
    
    var selectedPetKind: CmmPetListData?
    
    @IBAction func onKind(_ sender: Any) {
        self.performSegue(withIdentifier: "seguePetAddToPetKind", sender: btn_petTypeDog.isSelected ? "001" : "002")
    }
    
    
    
    
    
    private var selectedSido: Sido?
    private var selectedSigungu: SggListData?
    private var selectedUpmeondong: UmdListData?
    
    
    
    
    
    // MARK: - Back TitleBar
    
    @IBOutlet weak var titleBarView : UIView!
    
    func showBackTitleBarView() {
        if let view = UINib(nibName: "BackTitleBarView", bundle: nil).instantiate(withOwner: self).first as? BackTitleBarView {
            view.frame = titleBarView.bounds
            view.lb_title.text = "반려동물 정보 입력"
            view.delegate = self
            titleBarView.addSubview(view)
        }
    }
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "seguePetAddToPetKind") {
            let dest = segue.destination
            guard let vc = dest as? PetTypeSelectViewController else { return }
            vc.petTypCd = sender as? String
            vc.delegate = self
            
        } else if (segue.identifier == "seguePetAddToAddress") {
            let dest = segue.destination
            guard let vc = dest as? AddressSelectViewController else { return }
            vc.delegate = self
        }
    }
}





extension PetAddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            picker.dismiss(animated: true, completion: nil)
            guard let image = info[.originalImage] as? UIImage else {
                fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
            }
            
        img = image.resizeImageForUpload(maxWidth: 1024, maxHeight: 768)
        iv_profile.image = img
    }
}





extension PetAddViewController: BackTitleBarViewProtocol {
    func onBack() {
        navigationController?.popViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
}





extension PetAddViewController: PetTypeSelectViewControllerDelegate {
    func selectComplete(pet: CmmPetListData) {
        self.selectedPetKind = pet
        self.lb_petKind.text = self.selectedPetKind?.petNm
    }
}





extension PetAddViewController: AddressSelectViewControllerDelegate {
    func selectComplete(selectedSido: Sido?, selectedSigungu: SggListData?, selectedUpmeondong: UmdListData?) {
        self.selectedSido = selectedSido
        self.selectedSigungu = selectedSigungu
        self.selectedUpmeondong = selectedUpmeondong
        
        var addrStr = ""
        if let _selectedSido = self.selectedSido {
            addrStr += _selectedSido.cdNm + " "
        }
        if let _selectedSigungu = self.selectedSigungu {
            addrStr += _selectedSigungu.sggNm + " "
        }
        if let _selectedUpmeondong = self.selectedUpmeondong {
            addrStr += _selectedUpmeondong.umdNm
        }
        self.lb_addr.text = addrStr
    }
}





extension PetAddViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        tfSelectedUI(view: textField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        tfNormalUI(view: textField)
    }
}

