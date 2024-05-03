//
//  StoryModifyViewController.swift
//  PetTip
//
//  Created by carebiz on 1/22/24.
//

import UIKit
import AlamofireImage
import DropDown

class StoryModifyViewController: CommonViewController2 {

    var storyDetailViewController: StoryDetailViewController?
    var lifeViewData : LifeViewData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        showBackTitleBarView()
        
        showCommonUI()
    }
    
    // override func viewDidAppear(_ animated: Bool) {
    //     super.viewDidAppear(animated)
    //     addKeyboardObserver()
    // }
    // 
    // override func viewDidDisappear(_ animated: Bool) {
    //     super.viewDidDisappear(animated)
    //     removeKeyboardObserver()
    // }
    // 
    // private func addKeyboardObserver() {
    //     NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
    //     NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
    // }
    // 
    // private func removeKeyboardObserver() {
    //     NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    //     NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    // }
    // 
    // @objc private func keyboardWillShow(_ notification: NSNotification) {
    //     guard let userInfo = notification.userInfo else { return }
    //     guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
    //     let keyboardFrame = keyboardSize.cgRectValue
    //     
    //     sv_content.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
    //     sv_content.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
    //     
    //     let bottomOffset = CGPoint(x: 0, y: sv_content.contentSize.height - sv_content.bounds.height + sv_content.contentInset.bottom)
    //     if (bottomOffset.y > 0) {
    //         sv_content.setContentOffset(bottomOffset, animated: true)
    //     }
    // }
    // 
    // @objc private func keyboardWillHide(_ notification: NSNotification) {
    //     sv_content.contentInset = UIEdgeInsets.zero
    //     sv_content.scrollIndicatorInsets = UIEdgeInsets.zero
    // }
    
    private func reqCloseKeyboard() {
        view.endEditing(true)
    }

    @IBOutlet weak var sv_content: UIScrollView!

    @IBOutlet weak var lb_currDate: UILabel!
    
    private func showCommonUI() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        lb_currDate.text = dateFormatter.string(from: Date())
        
        initCurrSelectPet()
        
        initSelectEnablePet()
        
        initAttachFile()

        initDailyLifeGubun()
        
        initComboTitle()
        
        initMemo()
        
        initHashtag()
        
        initComplete()
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

    // MARK: - CURRENT SELECT PETS
    @IBOutlet weak var cv_currSelPet : UICollectionView!

    var items: [DailyLifePetList]?
    
    private func initCurrSelectPet() {
        cv_currSelPet.register(UINib(nibName: "SelectPetItemView", bundle: nil), forCellWithReuseIdentifier: "SelectPetItemView")
        cv_currSelPet.delegate = self
        cv_currSelPet.dataSource = self
        cv_currSelPet.showsHorizontalScrollIndicator = false
        
        let insetX = 20
        let insetY = 0
        let layout = cv_currSelPet.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: 100, height: 91)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        cv_currSelPet.contentInset = UIEdgeInsets(top: CGFloat(insetY), left: CGFloat(insetX), bottom: CGFloat(insetY), right: CGFloat(insetX))
        
        setCurrSelPetData(Global.dailyLifePetsBehaviorRelay.value?.pets as Any)
    }
    
    private func setCurrSelPetData(_ data: Any) {
        guard let _items = data as? [Pet] else { return }
        
        var arrCurrSelDailyLifePet = [DailyLifePetList]()
        
        if let dailyLifePetList = lifeViewData.dailyLifePetList {
            for i in 0..<dailyLifePetList.count {
                for j in 0..<_items.count {
                    if dailyLifePetList[i].ownrPetUnqNo == _items[j].ownrPetUnqNo {
                        arrCurrSelDailyLifePet.append(dailyLifePetList[i])
                        break
                    }
                }
            }
        }
        
        items = arrCurrSelDailyLifePet
        
        initAllSelected()
        
        cv_currSelPet.reloadData()
    }
    
    var itemSelected: Array<Bool> = Array()
    private func initAllSelected() {
        itemSelected = Array(repeating: false, count: items!.count)
        for i in 0..<itemSelected.count {
            itemSelected[i] = true
        }
    }
    private func setSelected(_ selIdx: Int) {
        itemSelected[selIdx].toggle()
    }

    // MARK: - SELECT ENABLE PETS
    @IBOutlet weak var cv_selEnablePet : UICollectionView!
    
    var selectEnableItems: [DailyLifePetList]?
    
    private func initSelectEnablePet() {
        cv_selEnablePet.register(UINib(nibName: "SelectPetItemView", bundle: nil), forCellWithReuseIdentifier: "SelectPetItemView")
        cv_selEnablePet.delegate = self
        cv_selEnablePet.dataSource = self
        cv_selEnablePet.showsHorizontalScrollIndicator = false
        
        let insetX = 20
        let insetY = 0
        let layout = cv_selEnablePet.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: 100, height: 91)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        cv_selEnablePet.contentInset = UIEdgeInsets(top: CGFloat(insetY), left: CGFloat(insetX), bottom: CGFloat(insetY), right: CGFloat(insetX))
        
        setSelectEnableData(Global.dailyLifePetsBehaviorRelay.value?.pets as Any)
    }
    
    private func setSelectEnableData(_ data: Any) {
        guard let _items = data as? [Pet] else { return }
        
        var arrSelEnablePet = [DailyLifePetList]()
        
        if let dailyLifePetList = lifeViewData.dailyLifePetList {
            for i in 0..<_items.count {
                var bSelected = false
                for j in 0..<dailyLifePetList.count {
                    if _items[i].ownrPetUnqNo == dailyLifePetList[j].ownrPetUnqNo {
                        bSelected = true
                        break
                    }
                }
                
                if bSelected == false {
                    let pet = DailyLifePetList(ownrPetUnqNo: _items[i].ownrPetUnqNo,
                                               petNm: _items[i].petNm,
                                               bwlMvmNmtm: nil,
                                               urineNmtm: nil,
                                               relmIndctNmtm: nil,
                                               stdgUmdNm: nil,
                                               age: nil,
                                               schUnqNo: nil,
                                               petImg: nil,
                                               rowState: "C")
                    arrSelEnablePet.append(pet)
                }
            }
            
            selectEnableItems = arrSelEnablePet
            
            initEnableSelected()
            
            cv_currSelPet.reloadData()
        }
    }
    
    var itemEnableSelected: Array<Bool> = Array()
    private func initEnableSelected() {
        itemEnableSelected = Array(repeating: false, count: selectEnableItems!.count)
        for i in 0..<itemEnableSelected.count {
            itemEnableSelected[i] = false
        }
    }
    private func setEnableSelected(_ selIdx: Int) {
        itemEnableSelected[selIdx].toggle()
    }

    // MARK: - ATTACH FILE
    @IBOutlet weak var cv_attachFile : UICollectionView!

    var arrStoryAtchHybidData = [StoryAtchHybridData]()
    var arrStoryAtchDelete = [DailyLifeFileList]()
    
    private func initAttachFile() {
        let layout = self.cv_attachFile.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 5
        layout.scrollDirection = .horizontal
        self.cv_attachFile.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
      
        self.cv_attachFile.delegate = self
        self.cv_attachFile.dataSource = self
        self.cv_attachFile.showsHorizontalScrollIndicator = false
        
        // 스크롤 시 빠르게 감속 되도록 설정
        self.cv_attachFile.decelerationRate = UIScrollView.DecelerationRate.fast
        
        if let dailyLifeFileList = lifeViewData.dailyLifeFileList {
            for i in 0..<dailyLifeFileList.count {
                var data = StoryAtchHybridData()
                data.remote = dailyLifeFileList[i]
                arrStoryAtchHybidData.append(data)
            }
        }
        
        self.cv_attachFile.reloadData()
    }
    
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

    // MARK: - DAILY LIFE GUBUN
    @IBOutlet weak var cv_dailyLifeGubun: UICollectionView!
    
    var idxSelectedGubunItem = -1
    var isGubunSingleSelectMode = false
    
    private func initDailyLifeGubun() {
        let layout = self.cv_dailyLifeGubun.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 3
        layout.scrollDirection = .horizontal
        self.cv_dailyLifeGubun.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
      
        self.cv_dailyLifeGubun.delegate = self
        self.cv_dailyLifeGubun.dataSource = self
        self.cv_dailyLifeGubun.showsHorizontalScrollIndicator = false
        
        // 스크롤 시 빠르게 감속 되도록 설정
        self.cv_dailyLifeGubun.decelerationRate = UIScrollView.DecelerationRate.fast
        
        code_list(cmmCdData: ["SCH"]) {
            self.initGubunSelected()
            
            if let schCodeList = self.schCodeList {
                for i in 0..<schCodeList.count {
                    for j in 0..<self.lifeViewData.dailyLifeSchSEList.count {
                        if schCodeList[i].cdID == self.lifeViewData.dailyLifeSchSEList[j].cdID {
                            self.setGubunSelected(i)
                            break
                        }
                    }
                }
                
            }
            
            self.cv_dailyLifeGubun.reloadData()
        }
    }
    
    var gubunItemSelected: Array<Bool> = Array()
    private func initGubunSelected() {
        gubunItemSelected = Array(repeating: false, count: schCodeList!.count)
        for i in 0..<gubunItemSelected.count {
            gubunItemSelected[i] = false
        }
        idxSelectedGubunItem = -1
    }
    private func setGubunSelected(_ selIdx: Int) {
        if (isGubunSingleSelectMode) {
            initGubunSelected();
            gubunItemSelected[selIdx] = true
            idxSelectedGubunItem = selIdx
            
        } else {
            gubunItemSelected[selIdx].toggle()
        }
    }

    // MARK: - CONN COMMON CODE-LIST
    private var schCodeList: [CDDetailList]?
    
    private func code_list(cmmCdData: [String], complete: (()-> Void)?) {
        if Global.schCodeList != nil {
            filterSchCodeListWithoutWalk()
            complete?()
            return
        }
        
        self.startLoading()
        
        let request = CodeListRequest(cmmCdData: cmmCdData)
        CommonAPI.codeList( request: request) { codeList, error in
            self.stopLoading()
            
            if let codeList = codeList, let data = codeList.data?[0] {
                Global.schCodeList = data.cdDetailList
                self.filterSchCodeListWithoutWalk()
                complete?()
            }
            
            self.processNetworkError(error)
        }
    }
    
    private func filterSchCodeListWithoutWalk() {
        if let list = Global.schCodeList {
            schCodeList = [CDDetailList]()
            for i in 0..<list.count {
                if list[i].cdID != "001" {
                    schCodeList?.append(list[i])
                }
            }
        }
    }

    // MARK: - COMBO TITLE
    @IBOutlet weak var vw_titleArea: UIView!
    @IBOutlet weak var tf_title: UITextField!
    @IBOutlet weak var vw_titleComboShowingArea: UIView!
    
    private var dropDown: DropDown?
    
    private var arrTitleComboText = [String]()
    
    private func initComboTitle() {
        vw_titleArea.layer.cornerRadius = 12
        vw_titleArea.layer.borderWidth = 1
        vw_titleArea.layer.borderColor = UIColor.init(hex: "#FFE3E9F2")?.cgColor
        
        tf_title.delegate = self
        tf_title.placeholder = "제목을 입력해주세요"
        
        tf_title.text = lifeViewData.schTTL
    }
    
    private func initTitleComboText() {
        arrTitleComboText.removeAll()
        
        if let items = Global.dailyLifePetsBehaviorRelay.value?.pets {
            for i in 0..<items.count {
                arrTitleComboText.append(String("\(items[i].petNm)와 즐거운 산책~!"))
            }
        }
    }
    
    private func showComboData() {
        initTitleComboText()
        
        dropDown = DropDown()
        guard let dropDown = dropDown else { return }

        // The view to which the drop down will appear on
        dropDown.anchorView = vw_titleComboShowingArea // UIView or UIBarButtonItem

        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = arrTitleComboText
        
        dropDown.direction = .bottom
//        dropDown.offsetFromWindowBottom = 400
        
        dropDown.width = vw_titleComboShowingArea.frame.size.width
        
        DropDown.startListeningToKeyboard()
        
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            tf_title.text = arrTitleComboText[index]
            tf_title.resignFirstResponder()
        }
    }
    

    // MARK: - MEMO
    @IBOutlet weak var tv_memo: UITextView!
    
    let textViewPlaceHolder = "일상을 기록해주세요"
    
    private func initMemo() {
        tv_memo.text = textViewPlaceHolder
        tv_memo.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        tv_memo.delegate = self
        
        tv_memo.text = lifeViewData.schCN
        
        textViewFitSize(tv_memo)
        inputTextNormalUI(view: tv_memo)
    }
    
    func textViewFitSize(_ textView: UITextView) {
        let size = CGSize(width: textView.frame.size.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        guard textView.contentSize.height < 200.0 else {
            textView.isScrollEnabled = true
            return
        }
        
        textView.isScrollEnabled = false
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height > 100 ? estimatedSize.height : 100
            }
        }
        
        if textView.text == textViewPlaceHolder {
            textView.textColor = UIColor.init(hex: "#FFB5B9BE")
        } else {
            textView.textColor = .black
        }
    }

    // MARK: - HASHTAG
    @IBOutlet weak var tf_hashtag: UITextField!
    
    private func initHashtag() {
        if let dailyLifeSchHashTagList = lifeViewData.dailyLifeSchHashTagList {
            var str = ""
            for i in 0..<dailyLifeSchHashTagList.count {
                if str != "" {
                    str += " "
                }
                str += String("#\(dailyLifeSchHashTagList[i].hashTagNm)")
            }
            tf_hashtag.text = str
        }
        
        tf_hashtag.delegate = self
        inputTextNormalUI(view: tf_hashtag)
        
        tf_hashtag.resolveHashTags()
    }

    // MARK: - SUBMIT
    @IBOutlet weak var btn_complete: UIButton!
    
    private func initComplete() {
        btn_complete.setAttrTitle("수정하기", 14, UIColor.white)
    }
    
    @IBAction func onComplete(_ sender: Any) {
        if let text = tf_title.text, text.count == 0 {
            self.showToast(msg: "제목을 입력해주세요")
            return
        }

        if getSelectedPetsCnt() == 0 {
            self.showToast(msg: "반려동물을 선택해주세요")
            return
        }
        
        if getSelectedDailyLifeCnt() == 0 {
            self.showToast(msg: "일상구분을 선택해주세요")
            return
        }
        
        dailylife_upload()
    }
    
    private func getSelectedPetsCnt() -> Int {
        var ret = 0
        
        for i in 0..<itemSelected.count {
            if itemSelected[i] {
                ret += 1
            }
        }
        
        for i in 0..<itemEnableSelected.count {
            if itemEnableSelected[i] {
                ret += 1
            }
        }
        
        return ret
    }
    
    private func getSelectedPets() -> [DailyLifePetList] {
        var ret = [DailyLifePetList]()
        
        for i in 0..<itemSelected.count {
            if itemSelected[i] == false, let items = items {
                let deleteItem = DailyLifePetList(ownrPetUnqNo: items[i].ownrPetUnqNo,
                                                  petNm: items[i].petNm,
                                                  bwlMvmNmtm: items[i].bwlMvmNmtm,
                                                  urineNmtm: items[i].urineNmtm,
                                                  relmIndctNmtm: items[i].relmIndctNmtm,
                                                  stdgUmdNm: items[i].stdgUmdNm,
                                                  age: items[i].age,
                                                  schUnqNo: items[i].schUnqNo,
                                                  petImg: items[i].petImg,
                                                  rowState: "D")
                ret.append(deleteItem)
            }
        }
        
        for i in 0..<itemEnableSelected.count {
            if itemEnableSelected[i] {
                ret.append(selectEnableItems![i])
            }
        }
        
        return ret;
    }
    
    private func getInsertedFile() -> [DailyLifeFileList]? {
        var ret = [DailyLifeFileList]()
        
        for i in 0..<arrStoryAtchDelete.count {
            let it = DailyLifeFileList(orgnlAtchFileNm: arrStoryAtchDelete[i].orgnlAtchFileNm,
                                       atchFileNm: arrStoryAtchDelete[i].atchFileNm,
                                       atchFileSz: arrStoryAtchDelete[i].atchFileSz,
                                       fileExtnNm: arrStoryAtchDelete[i].fileExtnNm,
                                       filePathNm: arrStoryAtchDelete[i].filePathNm,
                                       flmPstnLat: arrStoryAtchDelete[i].flmPstnLat,
                                       flmPstnLot: arrStoryAtchDelete[i].flmPstnLot,
                                       schUnqNo: arrStoryAtchDelete[i].schUnqNo,
                                       rowState: "D",
                                       atchFileSn: arrStoryAtchDelete[i].atchFileSn)
            ret.append(it)
        }
        
        guard let fileUploadResult = fileUploadResult, fileUploadResult.count > 0 else { return ret}
        
        for i in 0..<fileUploadResult.count {
            let it = DailyLifeFileList(orgnlAtchFileNm: fileUploadResult[i].orgnlAtchFileNm,
                                       atchFileNm: fileUploadResult[i].atchFileNm,
                                       atchFileSz: fileUploadResult[i].atchFileSz,
                                       fileExtnNm: fileUploadResult[i].fileExtnNm,
                                       filePathNm: fileUploadResult[i].filePathNm,
                                       flmPstnLat: nil,
                                       flmPstnLot: nil,
                                       schUnqNo: lifeViewData.schUnqNo,
                                       rowState: "C",
                                       atchFileSn: nil)
            ret.append(it)
        }
        
        return ret
    }
    
    private func getSelectedDailyLifeCnt() -> Int {
        var ret = 0
        
        let items = getSelectedDailyLife()
        for i in 0..<items.count {
            if items[i].rowState != "D" {
                ret += 1
            }
        }
        
        return ret
    }
    
    private func getSelectedDailyLife() -> [DailyLifeSchSEList] {
        var ret = [DailyLifeSchSEList]()
        
        for i in 0..<lifeViewData.dailyLifeSchSEList.count {
            var isExistCurrDelete = false
            for j in 0..<schCodeList!.count {
                if lifeViewData.dailyLifeSchSEList[i].cdID == schCodeList![j].cdID && gubunItemSelected[j] == false {
                    isExistCurrDelete = true
                    break
                }
            }
            
            if isExistCurrDelete == true {
                let it = DailyLifeSchSEList(cdID: lifeViewData.dailyLifeSchSEList[i].cdID,
                                            cdNm: lifeViewData.dailyLifeSchSEList[i].cdNm,
                                            schUnqNo: lifeViewData.dailyLifeSchSEList[i].schUnqNo,
                                            rowState: "D")
                ret.append(it)
            } else {
                ret.append(lifeViewData.dailyLifeSchSEList[i])
            }
        }
        
        for i in 0..<schCodeList!.count {
            var isExist = false
            for j in 0..<lifeViewData.dailyLifeSchSEList.count {
                if schCodeList![i].cdID == lifeViewData.dailyLifeSchSEList[j].cdID {
                    isExist = true
                    break
                }
            }
            
            if isExist == false && gubunItemSelected[i] == true {
                let it = DailyLifeSchSEList(cdID: schCodeList![i].cdID,
                                            cdNm: schCodeList![i].cdNm,
                                            schUnqNo: lifeViewData.schUnqNo,
                                            rowState: "C")
                ret.append(it)
            }
        }
        
        return ret
    }
    
    private func getMemo() -> String {
        if let text = tv_memo.text {
            if text == textViewPlaceHolder { return "" }
            
            return text
        }
        
        return ""
    }
    
    private func getInsertedHash() -> [DailyLifeSchHashTagList] {
        var ret = [DailyLifeSchHashTagList]()
        
        var arrSplit = [String]()
        if let text = tf_hashtag.text, text != "" {
            arrSplit = tf_hashtag.text!.components(separatedBy: " ")
        }
        for i in 0..<arrSplit.count {
            let removeCharacters: Set<Character> = ["#"]
            var str = arrSplit[i]
            str.removeAll(where: { removeCharacters.contains($0) } )
            arrSplit[i] = str
        }
        
        if let dailyLifeSchHashTagList = lifeViewData.dailyLifeSchHashTagList {
            for i in 0..<dailyLifeSchHashTagList.count {
                var isExist = false
                for j in 0..<arrSplit.count {
                    if dailyLifeSchHashTagList[i].hashTagNm == arrSplit[j] {
                        isExist = true
                        break
                    }
                }
                
                if isExist == false {
                    let it = DailyLifeSchHashTagList(rowState: "D",
                                                     hashTagNo: dailyLifeSchHashTagList[i].hashTagNo,
                                                     schUnqNo: dailyLifeSchHashTagList[i].schUnqNo,
                                                     hashTagNm: dailyLifeSchHashTagList[i].hashTagNm)
                    ret.append(it)
                    
                } else {
                    ret.append(dailyLifeSchHashTagList[i])
                }
            }
        }
        
        if let dailyLifeSchHashTagList = lifeViewData.dailyLifeSchHashTagList {
            for i in 0..<arrSplit.count {
                var isExist = false
                for j in 0..<dailyLifeSchHashTagList.count {
                    if arrSplit[i] == dailyLifeSchHashTagList[j].hashTagNm {
                        isExist = true
                        break
                    }
                }
                
                if isExist == false {
                    let it = DailyLifeSchHashTagList(rowState: "C",
                                                     hashTagNo: 0,
                                                     schUnqNo: lifeViewData.schUnqNo,
                                                     hashTagNm: String(arrSplit[i]))
                    ret.append(it)
                }
            }
            
        } else {
            for i in 0..<arrSplit.count {
                let it = DailyLifeSchHashTagList(rowState: "C",
                                                 hashTagNo: 0,
                                                 schUnqNo: lifeViewData.schUnqNo,
                                                 hashTagNm: String(arrSplit[i]))
                ret.append(it)
            }
        }
        
        return ret
    }

    // MARK: - CONN DAILY-LIFE UPLOAD
    private var fileUploadResult: [PhotoData]?
    
    private func dailylife_upload() {
        self.startLoading()
        
        var arrImage = [UIImage]()
        for i in 0..<arrStoryAtchHybidData.count {
            if let image = arrStoryAtchHybidData[i].local {
                arrImage.append(image)
            }
        }
        
        if arrImage.count == 0 {
            self.dailylife_update()
            return
        }
        
        let request = LifeUploadRequest(arrFile: arrImage)
        DailyLifeAPI.upload(request: request) { response, error in
            self.stopLoading()
            
            if let response = response {
                if response.statusCode == 200 {
                    self.fileUploadResult = response.data
                    
                    self.dailylife_update()
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

    // MARK: - CONN DAILY-LIFE UPDATE
    private func dailylife_update() {
        startLoading()
        
        let request = LifeUpdateRequest(cmntUseYn: lifeViewData.cmntUseYn,
                                        delYn: lifeViewData.delYn,
                                        rcmdtnYn: lifeViewData.rcmdtnYn,
                                        rlsYn: lifeViewData.rlsYn,
                                        schTtl: tf_title.text!,
                                        schUnqNo: lifeViewData.schUnqNo,
                                        schCn: getMemo(),
                                        dailyLifePetList: getSelectedPets(),
                                        dailyLifeFileList: getInsertedFile(),
                                        dailyLifeSchSeList: getSelectedDailyLife(),
                                        dailyLifeSchHashTagList: getInsertedHash())
        DailyLifeAPI.update(request: request) { lifeView, error in
            self.stopLoading()
            self.processNetworkError(error)
            
            if lifeView != nil && error == nil {
                self.storyDetailViewController?.isRequireRefresh = true
                self.onBack()
            } else {
                self.showToast(msg: "다시 시도해주세요")
            }
        }
    }

    // MARK: - Back TitleBar
    @IBOutlet weak var titleBarView : UIView!
    
    func showBackTitleBarView() {
        if let view = UINib(nibName: "BackTitleBarView", bundle: nil).instantiate(withOwner: self).first as? BackTitleBarView {
            view.frame = titleBarView.bounds
            view.lb_title.text = "일상 수정"
            view.delegate = self
            titleBarView.addSubview(view)
        }
    }
}

extension StoryModifyViewController: BackTitleBarViewProtocol {
    func onBack() {
        navigationController?.popViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
}

extension StoryModifyViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == cv_currSelPet {
            if let cnt = items?.count {
                return cnt
            }
            
        } else if collectionView == cv_selEnablePet {
            if let cnt = selectEnableItems?.count {
                return cnt
            }
            
        } else if collectionView == cv_attachFile {
            if arrStoryAtchHybidData.count < 5 {
                return arrStoryAtchHybidData.count + 1
            }
            
            return arrStoryAtchHybidData.count
            
        } else if collectionView == cv_dailyLifeGubun {
            if let cnt = schCodeList?.count {
                return cnt
            }
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == cv_currSelPet {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectPetItemView", for: indexPath) as! SelectPetItemView
            
            if let _item = items?[indexPath.row] {
                if let petRprsImgAddr = _item.petImg {
                    cell.ivProf.af.setImage(
                        withURL: URL(string: petRprsImgAddr)!,
                        placeholderImage: UIImage(named: "profile_default")!,
                        filter: AspectScaledToFillSizeFilter(size: cell.ivProf.frame.size)
                    )
                } else {
                    cell.ivProf.image = UIImage(named: "profile_default")
                }
                cell.lbName.text = _item.petNm
                cell.update(itemSelected[indexPath.row])
            }
            
            return cell
            
        } else if collectionView == cv_selEnablePet {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectPetItemView", for: indexPath) as! SelectPetItemView
            
            if let _item = selectEnableItems?[indexPath.row] {
                if let petRprsImgAddr = _item.petImg {
                    cell.ivProf.af.setImage(
                        withURL: URL(string: petRprsImgAddr)!,
                        placeholderImage: UIImage(named: "profile_default")!,
                        filter: AspectScaledToFillSizeFilter(size: cell.ivProf.frame.size)
                    )
                } else {
                    cell.ivProf.image = UIImage(named: "profile_default")
                }
                cell.lbName.text = _item.petNm
                cell.update(itemEnableSelected[indexPath.row])
            }
            
            return cell
            
        } else if collectionView == cv_attachFile {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "qnaModifyAttachFileItemView", for: indexPath) as! QnAModifyAttachFileItemView
            if indexPath.row > arrStoryAtchHybidData.count - 1 {
                cell.initializeModeAddImage()
                cell.didOnAddItem = {
                    self.requestAddImageFromGallary()
                }
            } else {
                cell.initialize(pathUri: "", data: arrStoryAtchHybidData[indexPath.row])
                cell.didOnRemoveItem = {
                    if let remote = self.arrStoryAtchHybidData[indexPath.row].remote {
                        self.arrStoryAtchDelete.append(remote)
                    }
                    
                    self.arrStoryAtchHybidData.remove(at: indexPath.row)
                    self.cv_attachFile.reloadData()
                }
                
                if indexPath.row == 0 {
                    cell.markRepresentative(flag: true)
                } else {
                    cell.markRepresentative(flag: false)
                }
            }
            
            return cell
            
        } else if collectionView == cv_dailyLifeGubun {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dailyLifeGubunItemView", for: indexPath) as! DailyLifeGubunItemView
            
            if let schCodeList = schCodeList {
                cell.lb_gubun.text = schCodeList[indexPath.row].cdNm
                cell.update(gubunItemSelected[indexPath.row])
            }
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if collectionView == cv_currSelPet {
            setSelected(indexPath.row)
            cv_currSelPet.reloadData()
            
            return itemSelected[indexPath.row]
            
        } else if collectionView == cv_selEnablePet {
            setEnableSelected(indexPath.row)
            cv_selEnablePet.reloadData()
            
            return itemEnableSelected[indexPath.row]
            
        } else if collectionView == cv_dailyLifeGubun {
            setGubunSelected(indexPath.row)
            cv_dailyLifeGubun.reloadData()
            
            return gubunItemSelected[indexPath.row]
        }
        
        return false
    }
}

extension StoryModifyViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        arrStoryAtchHybidData.append(StoryAtchHybridData(local: image.resizeImageForUpload(maxWidth: 1920, maxHeight: 1080), remote: nil))
        
        cv_attachFile.reloadData()
    }
}

// MARK: - UITextFieldDelegate
extension StoryModifyViewController {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField {
        case tf_hashtag:
            tf_hashtag.resolveHashTags()
            break
            
        default:
            break
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case tf_title:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                self.showComboData()
            })
            vw_titleArea.layer.borderWidth = 2
            vw_titleArea.layer.borderColor = UIColor.init(hex: "#FF000000")?.cgColor
            break
        
        case tf_hashtag:
            textField.layer.borderWidth = 2
            textField.layer.borderColor = UIColor.init(hex: "#FF000000")?.cgColor
            break
            
        default:
            break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case tf_title:
            dropDown?.hide()
            vw_titleArea.layer.borderWidth = 1
            vw_titleArea.layer.borderColor = UIColor.init(hex: "#FFE3E9F2")?.cgColor
            break
            
        case tf_hashtag:
            textField.layer.borderWidth = 1
            textField.layer.borderColor = UIColor.init(hex: "#FFE3E9F2")?.cgColor
            break
            
        default:
            break
        }
    }
}

// MARK: - UITextViewDelegate
extension StoryModifyViewController : UITextViewDelegate {
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

struct StoryAtchHybridData {
    var local: UIImage?
    var remote: DailyLifeFileList?
}
