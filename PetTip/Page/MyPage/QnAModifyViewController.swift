//
//  QnAModifyViewController.swift
//  PetTip
//
//  Created by carebiz on 1/13/24.
//

import UIKit
import DropDown

class QnAModifyViewController: CommonViewController {
    
    public var didDetailChanged: (()-> Void)?
    
    public var qnaQuestData: QnADtlData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showBackTitleBarView()
        
        showCommonUI()
        
        showOriginData()
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
    
    
    
    
    
    private func showOriginData() {
        guard let qnaQuestData = qnaQuestData else { return }
        
        if Global.pstCodeList == nil {
            code_list()
        } else {
            selectOriginKind()
        }
        
        tf_title.text = qnaQuestData.pstTTL
        
        tv_msg.text = qnaQuestData.pstCN
        tv_msg.textColor = UIColor.darkText
        
        if let files = qnaQuestData.files {
            for i in 0..<files.count {
                arrAtchHybidData.append(AtchHybridData(local: nil, remote: files[i]))
            }
        }
        
        onTermsAgree(self)
    }
    
    private func selectOriginKind() {
        guard let pstCodeList = Global.pstCodeList else { return }
        
        for i in 0..<pstCodeList.count {
            if pstCodeList[i].cdID == String(qnaQuestData!.pstSECD) {
                self.selectedKind = pstCodeList[i]
                self.lb_kind.text = selectedKind?.cdNm
                self.lb_kind.textColor = UIColor.darkText
                break
            }
        }
    }
    
    private func code_list() {
       self.startLoading()
        
        let request = CodeListRequest(cmmCdData: ["PST"])
        CommonAPI.codeList( request: request) { codeList, error in
            self.stopLoading()
            
            if let codeList = codeList, let data = codeList.data?[0] {
                Global.pstCodeList = data.cdDetailList
                self.selectOriginKind()
            }
            
            self.processNetworkError(error)
        }
    }
    
    
    
    
    
    var selectedKind: CDDetailList?
    
    @IBAction func onKind(_ sender: Any) {
        reqCloseKeyboard()
        
        showSelectKindCombo()
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
    
    
    
    
    
    var arrAtchHybidData = [AtchHybridData]()
    var arrAtchDelete = [PhotoDataUp]()
    
    private func requestAddImageFromGallary() {
        reqCloseKeyboard()
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum // .photoLibrary
            imagePicker.allowsEditing = false

            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    
    
    
    @IBAction func onTermsAgree(_ sender: Any) {
        reqCloseKeyboard()
        
        btn_checkAgree.isSelected.toggle()
        if btn_checkAgree.isSelected {
            iv_checkAgree.image = UIImage(named: "checkbox_white")
            vw_checkAgreeArea.backgroundColor = UIColor.lightGray
            
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
        
        if arrAtchHybidData.count > 0 {
            var arrAttachFile = [UIImage]()
            for i in 0..<arrAtchHybidData.count {
                if let local = arrAtchHybidData[i].local {
                    arrAttachFile.append(local)
                }
            }
            
            if arrAttachFile.count > 0 {
                qnaAtch_upload(files: arrAttachFile)
                
            } else {
                qna_update(newUploadFiles: nil)
            }
            
            
        } else {
            qna_update(newUploadFiles: nil)
        }
    }
    
    private func qnaAtch_upload(files: [UIImage]) {
        self.startLoading()
        
        let request = QnAAtchUploadRequest(arrFile: files)
        BBSAPI.qnaAtchUpload(request: request) { response, error in
            self.stopLoading()
            
            if let response = response {
                if response.statusCode == 200 {
                    let uploadResult = response.data
                    
                    self.qna_update(newUploadFiles: uploadResult)
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
    }
    
    private func qna_update(newUploadFiles: [PhotoData]?) {
        guard let qnaQuestData = qnaQuestData else { return }
        
        self.startLoading()
        
        var combinePhotoData = [PhotoDataUp]()
        for i in 0..<arrAtchHybidData.count {
            if let remote = arrAtchHybidData[i].remote {
                
                let data = PhotoDataUp(flmPstnLat: "", filePathNm: remote.filePathNm, flmPstnLot: "", orgnlAtchFileNm: remote.orgnlAtchFileNm, atchFileNm: remote.atchFileNm, atchFileSz: remote.atchFileSz, fileExtnNm: remote.fileExtnNm, atchFileSn: remote.atchFileSn, rowState: "")
                combinePhotoData.append(data)
            }
        }
        
        for i in 0..<arrAtchDelete.count {
            combinePhotoData.append(arrAtchDelete[i])
        }
        
        if let newUploadFiles = newUploadFiles {
            for i in 0..<newUploadFiles.count {
                let data = PhotoDataUp(flmPstnLat: "", filePathNm: newUploadFiles[i].filePathNm, flmPstnLot: "", orgnlAtchFileNm: newUploadFiles[i].orgnlAtchFileNm, atchFileNm: newUploadFiles[i].atchFileNm, atchFileSz: newUploadFiles[i].atchFileSz, fileExtnNm: newUploadFiles[i].fileExtnNm, atchFileSn: 0, rowState: "C")
                combinePhotoData.append(data)
            }
        }
        
        let request = QnAUpdateRequest(pstSn: qnaQuestData.pstSn, files: combinePhotoData, pstCn: self.tv_msg.text!, pstSeCd: String(self.selectedKind!.cdID), pstTtl: self.tf_title.text!)
        BBSAPI.qnaUpdate(request: request) { response, error in
            self.stopLoading()
         
            if let response = response {
                if response.statusCode == 200 {
                    self.showAlertPopup(title: "알림", msg: response.resultMessage, didTapOK: {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                            self.didDetailChanged?()
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
    
    
    
    
    
    // MARK: - Back TitleBar
    
    @IBOutlet weak var titleBarView : UIView!
    
    func showBackTitleBarView() {
        if let view = UINib(nibName: "BackTitleBarView", bundle: nil).instantiate(withOwner: self).first as? BackTitleBarView {
            view.frame = titleBarView.bounds
            view.lb_title.text = "1:1 문의 수정"
            view.delegate = self
            titleBarView.addSubview(view)
            self.title = view.lb_title.text
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideBackTitleBarView()
    }
}





extension QnAModifyViewController: BackTitleBarViewProtocol {
    func onBack() {
        navigationController?.popViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
}





extension QnAModifyViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        inputTextSelectedUI(view: textField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        inputTextNormalUI(view: textField)
    }
}





// MARK: - TextViewDelegate

extension QnAModifyViewController : UITextViewDelegate {
    
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

extension QnAModifyViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if arrAtchHybidData.count < 5 {
            return arrAtchHybidData.count + 1
        }
        
        return arrAtchHybidData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "qnaModifyAttachFileItemView", for: indexPath) as! QnAModifyAttachFileItemView
        if indexPath.row > arrAtchHybidData.count - 1 {
            cell.initializeModeAddImage()
            cell.didOnAddItem = {
                self.requestAddImageFromGallary()
            }
        } else {
            cell.initialize(pathUri: qnaQuestData!.atchPath, data: arrAtchHybidData[indexPath.row])
            cell.didOnRemoveItem = {
                if let remote = self.arrAtchHybidData[indexPath.row].remote {
                    let data = PhotoDataUp(flmPstnLat: "", filePathNm: remote.filePathNm, flmPstnLot: "", orgnlAtchFileNm: remote.orgnlAtchFileNm, atchFileNm: remote.atchFileNm, atchFileSz: remote.atchFileSz, fileExtnNm: remote.fileExtnNm, atchFileSn: remote.atchFileSn, rowState: "D")
                    self.arrAtchDelete.append(data)
                }
                
                self.arrAtchHybidData.remove(at: indexPath.row)
                self.cv_attachFile.reloadData()
            }
        }
        
        return cell
    }
}





extension QnAModifyViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
//        if let asset: PHAsset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset {
//            print("# Asset: ", asset)
//        } else {
//            print("# Asset: nil !!!")
//        }
//        
//        if let url: URL = (info as NSDictionary).object(forKey: UIImagePickerController.InfoKey.referenceURL) as? URL {
//            print("# url: ", url)
//            
//            if let img = CIImage(contentsOf: url), metaData = img.properties, gpsData = metaData[kCGImagePropertyGPSDictionary as String] as? [String: AnyObject] {
//                
//            }
//        } else {
//            print("# url: nil !!!")
//        }
        
        arrAtchHybidData.append(AtchHybridData(local: image.resizeImageForUpload(maxWidth: 1920, maxHeight: 1080), remote: nil))
        
        cv_attachFile.reloadData()
    }
}





struct AtchHybridData {
    var local: UIImage?
    var remote: File?
}

struct PhotoDataUp: Codable {
    let flmPstnLat: String?
    let filePathNm: String
    let flmPstnLot: String?
    let orgnlAtchFileNm, atchFileNm: String
    let atchFileSz: Int
    let fileExtnNm: String
    let atchFileSn: Int
    let rowState: String
}
