//
//  QnAAddViewController.swift
//  PetTip
//
//  Created by carebiz on 1/12/24.
//

import UIKit
import DropDown

class QnAAddViewController: CommonViewController {
    
    public var didListChanged: (()-> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showBackTitleBarView()
        
        showCommonUI()
    }
    
    
    
    
    
    @IBOutlet weak var vw_kind: UIView!
    @IBOutlet weak var lb_kind: UILabel!
    @IBOutlet weak var vw_kindComboShowingArea: UIView!
    
    @IBOutlet weak var tf_title: UITextField!
    
    @IBOutlet weak var tv_msg: UITextView!
    
    @IBOutlet weak var cv_attachFile : UICollectionView!
    
    @IBOutlet weak var lb_device: UILabel!
    
    @IBOutlet weak var vw_checkAgreeArea: UIView!
    @IBOutlet weak var iv_checkAgree: UIImageView!
    @IBOutlet weak var btn_checkAgree: UIButton!
    
    let textViewPlaceHolder = "문의 내용을 상세히 기재해주시면 문의 확인에 도움이 됩니다.\n\n-핸드폰기종 정보\n-문의 상세 내용\n-오류화면 캡쳐 첨부"
    
    func showCommonUI() {
        vw_kind.layer.cornerRadius = 12
        vw_kind.layer.borderWidth = 1
        vw_kind.layer.borderColor = UIColor.init(hex: "#FFE3E9F2")?.cgColor
        
        lb_kind.text = "문의유형을 선택해주세요"
        lb_kind.textColor = UIColor.init(hex: "#FFB5B9BE")
        
        tf_title.delegate = self
        inputTextNormalUI(view: tf_title)
        
        tv_msg.text = textViewPlaceHolder
        tv_msg.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        tv_msg.delegate = self
        textViewFitSize(tv_msg)
        inputTextNormalUI(view: tv_msg)
        
        let layout = self.cv_attachFile.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 5
        layout.scrollDirection = .horizontal
        self.cv_attachFile.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
      
        self.cv_attachFile.delegate = self
        self.cv_attachFile.dataSource = self
        
        // 스크롤 시 빠르게 감속 되도록 설정
        self.cv_attachFile.decelerationRate = UIScrollView.DecelerationRate.fast
        
        self.cv_attachFile.reloadData()
        
        lb_device.text = String("폰기종 : \(UIDevice.current.model) | OS : \(UIDevice.current.systemVersion) | AppVersion : \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)")
        
        iv_checkAgree.image = UIImage.imageFromColor(color: UIColor.clear)
        btn_checkAgree.isSelected = false
        vw_checkAgreeArea.backgroundColor = UIColor.white
        vw_checkAgreeArea.layer.cornerRadius = 2
        vw_checkAgreeArea.layer.borderWidth = 1
        vw_checkAgreeArea.layer.borderColor = UIColor.init(hex: "#FFE3E9F2")?.cgColor
    }
    
    private func inputTextSelectedUI(view: UIView) {
        view.layer.cornerRadius = 4
        
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor(hex: "#FF000000")?.cgColor // SELECTED COLOR
    }
    
    private func inputTextNormalUI(view: UIView) {
        view.layer.cornerRadius = 4
        
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(hex: "#ffe3e9f2")?.cgColor // NORMAL COLOR
    }
    
    @IBAction func onContentViewTap(_ sender: Any) {
        reqCloseKeyboard()
    }
    
    private func reqCloseKeyboard() {
        tf_title.resignFirstResponder()
        tv_msg.resignFirstResponder()
    }
    
    func textViewFitSize(_ textView: UITextView) {
        let size = CGSize(width: textView.frame.size.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        guard textView.contentSize.height < 400.0 else {
            textView.isScrollEnabled = true
            return
        }
        
        textView.isScrollEnabled = false
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height > 200 ? estimatedSize.height : 200
            }
        }
        
        if textView.text == textViewPlaceHolder {
            textView.textColor = UIColor.init(hex: "#FFB5B9BE")
        } else {
            textView.textColor = .black
        }
    }
    
    
    
    
    
    var selectedKind: CDDetailList?
    
    @IBAction func onKind(_ sender: Any) {
        reqCloseKeyboard()
        
        if Global.pstCodeList == nil {
            code_list()
        } else {
            showSelectKindCombo()
        }
    }
    
    private func showSelectKindCombo() {
        guard let pstCodeList = Global.pstCodeList else { return }
        
        var pstNmList = [String]()
        for i in 0..<pstCodeList.count {
            pstNmList.append(pstCodeList[i].cdNm)
        }
        
        let dropDown = DropDown()

        // The view to which the drop down will appear on
        dropDown.anchorView = vw_kindComboShowingArea // UIView or UIBarButtonItem

        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = pstNmList
        
        DropDown.startListeningToKeyboard()
        
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.selectedKind = pstCodeList[index]
            self.lb_kind.text = pstNmList[index]
            self.lb_kind.textColor = UIColor.darkText
        }
    }
    
    private func code_list() {
       self.startLoading()
        
        let request = CodeListRequest(cmmCdData: ["PST"])
        CommonAPI.codeList( request: request) { codeList, error in
            self.stopLoading()
            
            if let codeList = codeList, let data = codeList.data?[0] {
                Global.pstCodeList = data.cdDetailList
                self.showSelectKindCombo()
            }
            
            self.processNetworkError(error)
        }
    }
    
    
    
    
    
    var arrAttachFile = [UIImage]()
    
    private func requestAddImageFromGallary() {
        reqCloseKeyboard()
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false

            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    
    
    
    @IBAction func onTermsAgree(_ sender: Any) {
        reqCloseKeyboard()
        
        btn_checkAgree.isSelected.toggle()
        if btn_checkAgree.isSelected {
            iv_checkAgree.image = UIImage(named: "checkbox_white")
            vw_checkAgreeArea.backgroundColor = UIColor.init(hex: "#FF4783F5")
            
        } else {
            iv_checkAgree.image = UIImage.imageFromColor(color: UIColor.clear)
            vw_checkAgreeArea.backgroundColor = UIColor.white
        }
    }
    
    
    
    
    
    @IBAction func onComplete(_ sender: Any) {
        reqCloseKeyboard()
        
        if selectedKind == nil {
            showToast(msg: "문의 유형을 선택해주세요")
            return
        } else if let title = tf_title.text, title.isEmpty {
            showToast(msg: "제목을 입력해주세요")
            return
        } else if let msg = tv_msg.text, msg.isEmpty || msg == textViewPlaceHolder {
            showToast(msg: "내용을 입력해주세요")
            return
        } else if btn_checkAgree.isSelected == false {
            showToast(msg: "정보 수집에 동의해주세요")
            return
        }
        
        self.startLoading()
        
        if arrAttachFile.count > 0 {
            let request = QnAAtchUploadRequest(arrFile: arrAttachFile)
            BBSAPI.qnaAtchUpload(request: request) { response, error in
                self.stopLoading()
                
                if let response = response {
                    if response.statusCode == 200 {
                        let uploadResult = response.data
                        
                        let request2 = QnACreateRequest(bbsSn: 10, files: uploadResult, pstCn: self.tv_msg.text!, pstSeCd: String(self.selectedKind!.cdID), pstTtl: self.tf_title.text!)
                        BBSAPI.qnaCreate(request: request2) { response2, error in
                            if let response2 = response2 {
                                if response2.statusCode == 200 {
                                    self.showAlertPopup(title: "알림", msg: response2.resultMessage, didTapOK: {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                                            self.didListChanged?()
                                            self.onBack()
                                        })
                                    })
                                    
                                } else if response2.statusCode == 406 {
                                    self.showAlertPopup(title: response2.resultMessage, msg: response2.detailMessage!)
                                    
                                } else {
                                    self.showAlertPopup(title: "에러", msg: "통신 에러가 발생했어요")
                                    //self.showAlertPopup(title: response.resultMessage, msg: response.detailMessage!)
                                }
                            }
                        }
                    }
                    else if response.statusCode == 406 {
                        self.showAlertPopup(title: response.resultMessage != nil ? response.resultMessage! : "에러", msg: response.detailMessage!)
                        
                    } else {
                        self.showAlertPopup(title: "에러", msg: "통신 에러가 발생했어요")
                        //self.showAlertPopup(title: response.resultMessage, msg: response.detailMessage!)
                    }
                }
                
                self.processNetworkError(error)
            }
            
        } else {
            let request = QnACreateRequest(bbsSn: 10, files: [PhotoData](), pstCn: self.tv_msg.text!, pstSeCd: String(self.selectedKind!.cdID), pstTtl: self.tf_title.text!)
            BBSAPI.qnaCreate(request: request) { response, error in
                if let response = response {
                    if response.statusCode == 200 {
                        self.showAlertPopup(title: "알림", msg: response.resultMessage, didTapOK: {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                                self.didListChanged?()
                                self.onBack()
                            })
                        })
                        
                    } else if response.statusCode == 406 {
                        self.showAlertPopup(title: response.resultMessage, msg: response.detailMessage!)
                        
                    } else {
                        self.showAlertPopup(title: "에러", msg: "통신 에러가 발생했어요")
                        //self.showAlertPopup(title: response.resultMessage, msg: response.detailMessage!)
                    }
                }
            }
        }
    }
    
    
    
    
    
    // MARK: - Back TitleBar
    
    @IBOutlet weak var titleBarView : UIView!
    
    func showBackTitleBarView() {
        if let view = UINib(nibName: "BackTitleBarView", bundle: nil).instantiate(withOwner: self).first as? BackTitleBarView {
            view.frame = titleBarView.bounds
            view.lb_title.text = "1:1 문의"
            view.delegate = self
            titleBarView.addSubview(view)
            self.title = view.lb_title.text
        }
    }
}





extension QnAAddViewController: BackTitleBarViewProtocol {
    func onBack() {
        navigationController?.popViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
}





extension QnAAddViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        inputTextSelectedUI(view: textField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        inputTextNormalUI(view: textField)
    }
}





// MARK: - TextViewDelegate

extension QnAAddViewController : UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        textViewFitSize(textView)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .darkText
        }
        
        inputTextSelectedUI(view: textView)
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = UIColor.init(hex: "#FFB5B9BE")
        }
        
        inputTextNormalUI(view: textView)
    }
}





// MARK: - Attach ImageFile CollectionView Delegate

extension QnAAddViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if arrAttachFile.count < 5 {
            return arrAttachFile.count + 1
        }
        
        return arrAttachFile.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "qnaAddAttachFileItemView", for: indexPath) as! QnAAddAttachFileItemView
        if indexPath.row > arrAttachFile.count - 1 {
            cell.initializeModeAddImage()
            cell.didOnAddItem = {
                self.requestAddImageFromGallary()
            }
        } else {
            cell.initialize(image: arrAttachFile[indexPath.row])
            cell.didOnRemoveItem = { 
                self.arrAttachFile.remove(at: indexPath.row)
                self.cv_attachFile.reloadData()
            }
        }
        
        return cell
    }
}





extension QnAAddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        arrAttachFile.append(image.resizeImageForUpload(maxWidth: 1920, maxHeight: 1080))
        
        cv_attachFile.reloadData()
    }
}
