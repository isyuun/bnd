//
//  PetTypeSelectViewController.swift
//  PetTip
//
//  Created by carebiz on 1/6/24.
//

import UIKit
import DropDown

protocol PetTypeSelectViewControllerDelegate {
    func selectComplete(pet: CmmPetListData)
}

class PetTypeSelectViewController: CommonViewController {
    
    var delegate: PetTypeSelectViewControllerDelegate?
    
    var petTypCd: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showBackTitleBarView()
        
        showCommonUI()
        
        if let petTypCd = self.petTypCd {
            
            var isNeedConn = false
            if petTypCd == "001" {
                if let cmmPetListDog = Global.cmmPetListDog {
                    petList = cmmPetListDog
                } else {
                    isNeedConn = true
                }
                
            } else if petTypCd == "002" {
                if let cmmPetListCat = Global.cmmPetListCat {
                    petList = cmmPetListCat
                } else {
                    isNeedConn = true
                }
            }
            
            if isNeedConn {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.pet_list(petTypCd: petTypCd)
                })
            }
        }
    }
    
    
    
    
    
    @IBOutlet weak var vw_petType: UIView!
    @IBOutlet weak var tf_petType: UITextField!
    @IBOutlet weak var btn_petType: UIButton!
    
    @IBOutlet weak var vw_petTypeComboShowingArea: UIView!
    
    @IBOutlet weak var btn_ok: UIButton!
    
    func showCommonUI() {
        vw_petType.layer.cornerRadius = 12
        vw_petType.layer.borderWidth = 1
        vw_petType.layer.borderColor = UIColor.init(hex: "#FFE3E9F2")?.cgColor
        
        tf_petType.delegate = self
        tf_petType.placeholder = "펫종을 선택해주세요"
    }
    
    @IBAction func onContentViewTap(_ sender: Any) {
        reqCloseKeyboard()
    }
    
    private func reqCloseKeyboard() {
        tf_petType.resignFirstResponder()
    }
    
    @IBAction func onTfPetTypeTap(_ sender: Any) {
        self.showComboData()
    }
    
    @IBAction func onComplete(_ sender: Any) {
        if let selectedPet = selectedPet {
            delegate?.selectComplete(pet: selectedPet)
            onBack()
        } else {
            self.showAlertPopup(title: "확인", msg: "펫종을 선택해주세요")
        }
    }
    
    
    
    
    
    var petList = [CmmPetListData]()
    var selectedPet: CmmPetListData?
    
    func pet_list(petTypCd: String) {
        self.startLoading()
        
        let request = CmmPetListRequest(petDogSzCd: "", petTypCd: petTypCd)
        CommonAPI.petList(request: request) { response, error in
            self.stopLoading()
            
            if let response = response {
                if response.statusCode == 200 {
                    if petTypCd == "001" {
                        Global.cmmPetListDog = response.data
                    } else if petTypCd == "002" {
                        Global.cmmPetListCat = response.data
                    }
                    self.petList = response.data
                    
                } else {
                    self.showAlertPopup(title: "에러", msg: "통신 에러가 발생했어요")
                }
            }
            
            self.processNetworkError(error)
        }
    }
    
    func showComboData() {
        var sortedPetList = [CmmPetListData]()
        var petNmList = [String]()
        if tf_petType.text == "" {
            for i in 0..<petList.count {
                sortedPetList.append(petList[i])
                petNmList.append(petList[i].petNm)
            }
            
        } else {
            for i in 0..<petList.count {
                if petList[i].petNm.contains(tf_petType.text!) {
                    sortedPetList.append(petList[i])
                    petNmList.append(petList[i].petNm)
                }
            }
        }
        
        let dropDown = DropDown()

        // The view to which the drop down will appear on
        dropDown.anchorView = vw_petTypeComboShowingArea // UIView or UIBarButtonItem

        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = petNmList
        
        DropDown.startListeningToKeyboard()
        
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
//          print("Selected item: \(item) at index: \(index)")
            self.selectedPet = sortedPetList[index]
            self.tf_petType.text = sortedPetList[index].petNm
            self.tf_petType.resignFirstResponder()
        }
    }
    
    
    
    
    
    // MARK: - Back TitleBar
    
    @IBOutlet weak var titleBarView : UIView!
    
    func showBackTitleBarView() {
        if let view = UINib(nibName: "BackTitleBarView", bundle: nil).instantiate(withOwner: self).first as? BackTitleBarView {
            view.frame = titleBarView.bounds
            view.lb_title.text = "사이즈/품종 선택"
            view.delegate = self
            titleBarView.addSubview(view)
        }
    }
}





extension PetTypeSelectViewController: BackTitleBarViewProtocol {
    func onBack() {
        navigationController?.popViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
}





extension PetTypeSelectViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField {
        case tf_petType:
            if let selectedPet = selectedPet {
                if selectedPet.petNm != tf_petType.text {
                    showComboData()
                }
            } else {
                showComboData()
            }
            break
        default:
            break
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case tf_petType:
            vw_petType.layer.borderWidth = 2
            vw_petType.layer.borderColor = UIColor.init(hex: "#FF000000")?.cgColor
            break
        default:
            break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case tf_petType:
            vw_petType.layer.borderWidth = 1
            vw_petType.layer.borderColor = UIColor.init(hex: "#FFE3E9F2")?.cgColor
            
            if let selectedPet = self.selectedPet {
                if selectedPet.petNm != tf_petType.text {
                    self.selectedPet = nil
                }
            }
            break
        default:
            break
        }
    }
}
