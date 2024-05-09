//
//  AddressSelectViewController.swift
//  PetTip
//
//  Created by carebiz on 1/7/24.
//

import UIKit
import DropDown

protocol AddressSelectViewControllerDelegate {
    func selectComplete(selectedSido: Sido?, selectedSigungu: SggListData?, selectedUpmeondong: UmdListData?)
}

class AddressSelectViewController: CommonViewController {
    
    var delegate: AddressSelectViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showBackTitleBarView()
        
        showCommonUI()
    }
    
    
    
    
    
    @IBOutlet weak var vw_sido: UIView!
    @IBOutlet weak var lb_sido: UILabel!
    @IBOutlet weak var btn_sido: UIButton!
    @IBOutlet weak var vw_sidoComboShowingArea: UIView!
    
    @IBOutlet weak var vw_sigunguArea: UIView!
    @IBOutlet weak var vw_sigungu: UIView!
    @IBOutlet weak var lb_sigungu: UILabel!
    @IBOutlet weak var btn_sigungu: UIButton!
    @IBOutlet weak var vw_sigunguComboShowingArea: UIView!
    
    @IBOutlet weak var vw_upmeundongArea: UIView!
    @IBOutlet weak var vw_upmeundong: UIView!
    @IBOutlet weak var lb_upmeundong: UILabel!
    @IBOutlet weak var btn_upmeundong: UIButton!
    @IBOutlet weak var vw_upmeundongComboShowingArea: UIView!
    
    func showCommonUI() {
        initSido()
        initSigungu()
        initUpmeondong()
    }
    
    private func initSido() {
        vw_sido.layer.cornerRadius = 12
        vw_sido.layer.borderWidth = 1
        vw_sido.layer.borderColor = UIColor.init(hex: "#FFE3E9F2")?.cgColor
        
        lb_sido.text = "시/도를 선택해주세요"
        lb_sido.textColor = UIColor.init(hex: "#FFB5B9BE")
        
        selectedSido = nil
    }
    
    private func initSigungu() {
        vw_sigungu.layer.cornerRadius = 12
        vw_sigungu.layer.borderWidth = 1
        vw_sigungu.layer.borderColor = UIColor.init(hex: "#FFE3E9F2")?.cgColor
        
        lb_sigungu.text = "시/군/구를 선택해주세요"
        lb_sigungu.textColor = UIColor.init(hex: "#FFB5B9BE")
        
        vw_sigunguArea.isHidden = true
        
        sigunguList = nil
        selectedSigungu = nil
    }
    
    private func initUpmeondong() {
        vw_upmeundong.layer.cornerRadius = 12
        vw_upmeundong.layer.borderWidth = 1
        vw_upmeundong.layer.borderColor = UIColor.init(hex: "#FFE3E9F2")?.cgColor
        
        lb_upmeundong.text = "읍/면/동을 선택해주세요"
        lb_upmeundong.textColor = UIColor.init(hex: "#FFB5B9BE")
        
        vw_upmeundongArea.isHidden = true
        
        upmeondongList = nil
        selectedUpmeondong = nil
    }
    
    @IBAction func onComplete(_ sender: Any) {
        if selectedSido == nil {
            self.showAlertPopup(title: "확인", msg: "시/도를 선택해주세요")
        } else if selectedSigungu == nil {
            self.showAlertPopup(title: "확인", msg: "시/군/구를 선택해주세요")
        } else if upmeondongList != nil && upmeondongList!.count > 0 && selectedUpmeondong == nil {
            self.showAlertPopup(title: "확인", msg: "읍/면/동을 선택해주세요")
        } else {
            self.delegate?.selectComplete(selectedSido: selectedSido, selectedSigungu: selectedSigungu, selectedUpmeondong: selectedUpmeondong)
            onBack()
        }
    }
    
    
    
    
    
    var selectedSido: Sido?
    
    @IBAction func onSido(_ sender: Any) {
        var sidoNmList = [String]()
        for i in 0..<Global.cmmSidoList.count {
            sidoNmList.append(Global.cmmSidoList[i].cdNm)
        }
        
        let dropDown = DropDown()

        // The view to which the drop down will appear on
        dropDown.anchorView = vw_sidoComboShowingArea // UIView or UIBarButtonItem

        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = sidoNmList
        
        DropDown.startListeningToKeyboard()
        
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
//          print("Selected item: \(item) at index: \(index)")
            self.selectedSido = Global.cmmSidoList[index]
            self.lb_sido.text = sidoNmList[index]
            self.lb_sido.textColor = UIColor.darkText
            
            initSigungu()
            initUpmeondong()
            
            sgg_list()
        }
    }
    
    
    
    
    
    private var sigunguList: [SggListData]?
    private var selectedSigungu: SggListData?
    
    private func sgg_list() {
        guard let selectedSido = selectedSido else { return }
        
        self.startLoading()
        
        let request = SggListRequest(sidoCd: selectedSido.cdld)
        CommonAPI.sggList(request: request) { response, error in
            self.stopLoading()
            
            if let response = response {
                if response.statusCode == 200 {
                    self.sigunguList = response.data
                    self.showSigungu()
                    
                } else {
                    self.showAlertPopup(title: "에러", msg: "통신 에러가 발생했어요")
                }
            }
            
            self.processNetworkError(error)
        }
    }
    
    private func showSigungu() {
        self.vw_sigunguArea.alpha = 0.0
        self.vw_sigunguArea.isHidden = false
        UIView.animate(withDuration: 0.5) {
            self.vw_sigunguArea.alpha = 1.0
            self.view.layoutIfNeeded()
        } completion: { flag in }
    }
    
    @IBAction func onSigungu(_ sender: Any) {
        guard let sigunguList = sigunguList else { return }
        
        var sigunguNmList = [String]()
        for i in 0..<sigunguList.count {
            sigunguNmList.append(sigunguList[i].sggNm)
        }
        
        let dropDown = DropDown()

        // The view to which the drop down will appear on
        dropDown.anchorView = vw_sigunguComboShowingArea // UIView or UIBarButtonItem

        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = sigunguNmList
        
        DropDown.startListeningToKeyboard()
        
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
//          print("Selected item: \(item) at index: \(index)")
            self.selectedSigungu = sigunguList[index]
            self.lb_sigungu.text = sigunguNmList[index]
            self.lb_sigungu.textColor = UIColor.darkText
            
            initUpmeondong()
            
            umd_list()
        }
    }
    
    
    
    
    
    private var upmeondongList: [UmdListData]?
    private var selectedUpmeondong: UmdListData?
    
    private func umd_list() {
        guard let selectedSido = selectedSido else { return }
        guard let selectedSigungu = selectedSigungu else { return }
        
        self.startLoading()
        
        let request = UmdListRequest(sidoCd: selectedSido.cdld, sggCd: Int(selectedSigungu.sggCD)!)
        CommonAPI.umdList(request: request) { response, error in
            self.stopLoading()
            
            if let response = response {
                if response.statusCode == 200 {
                    self.upmeondongList = response.data
                    self.showUpmeondong()
                    
                } else {
                    self.showAlertPopup(title: "에러", msg: "통신 에러가 발생했어요")
                }
            }
            
            self.processNetworkError(error)
        }
    }
    
    private func showUpmeondong() {
        guard upmeondongList != nil && upmeondongList!.count > 0 else { return }
        
        self.vw_upmeundongArea.alpha = 0.0
        self.vw_upmeundongArea.isHidden = false
        UIView.animate(withDuration: 0.5) {
            self.vw_upmeundongArea.alpha = 1.0
            self.view.layoutIfNeeded()
        } completion: { flag in }
    }
    
    @IBAction func onUpmeondong(_ sender: Any) {
        guard let upmeondongList = upmeondongList else { return }
        
        var upmeondongNmList = [String]()
        for i in 0..<upmeondongList.count {
            upmeondongNmList.append(upmeondongList[i].umdNm)
        }
        
        let dropDown = DropDown()

        // The view to which the drop down will appear on
        dropDown.anchorView = vw_upmeundongComboShowingArea // UIView or UIBarButtonItem

        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = upmeondongNmList
        
        DropDown.startListeningToKeyboard()
        
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
//          print("Selected item: \(item) at index: \(index)")
            self.selectedUpmeondong = upmeondongList[index]
            self.lb_upmeundong.text = upmeondongNmList[index]
            self.lb_upmeundong.textColor = UIColor.darkText
        }
    }
    
    
    
    
    
    // MARK: - Back TitleBar
    
    @IBOutlet weak var titleBarView : UIView!
    
    func showBackTitleBarView() {
        if let view = UINib(nibName: "BackTitleBarView", bundle: nil).instantiate(withOwner: self).first as? BackTitleBarView {
            view.frame = titleBarView.bounds
            view.lb_title.text = "지역 선택"
            view.delegate = self
            titleBarView.addSubview(view)
        }
    }
}





extension AddressSelectViewController: BackTitleBarViewProtocol {
    func onBack() {
        navigationController?.popViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
}
