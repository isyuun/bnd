//
//  StoryAddViewController.swift
//  PetTip
//
//  Created by carebiz on 1/19/24.
//

import UIKit
import AlamofireImage
import DropDown

class StoryAddViewController: CommonViewController2 {

    public var storyListViewController: StoryListViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

        self.tabBarController?.tabBar.isHidden = true

        showBackTitleBarView()

        showCommonUI()
    }

    func reqRefreshStoryList() {
        storyListViewController?.isRequireRefresh = true
    }

    @IBOutlet weak var sv_content: UIScrollView!

    @IBOutlet weak var lb_currDate: UILabel!

    func showCommonUI() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        lb_currDate.text = dateFormatter.string(from: Date())

        initSelectPet()

        initAttachFile()

        initDailyLifeGubun()

        initComboTitle()

        initMemo()

        initHashtag()

        initStoryShareAgree()

        initComplete()
    }

    @IBAction func onContentViewTap(_ sender: Any) {
        reqCloseKeyboard()
    }

    private func reqCloseKeyboard() {
        tf_title.resignFirstResponder()
        tv_memo.resignFirstResponder()
        tf_hashtag.resignFirstResponder()
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

    // MARK: - SELECT PETS
    @IBOutlet weak var cv_selPet: UICollectionView!

    var idxSelectedItem = -1
    var isSingleSelectMode = false

    private func initSelectPet() {
        cv_selPet.register(UINib(nibName: "SelectPetItemView", bundle: nil), forCellWithReuseIdentifier: "SelectPetItemView")
        cv_selPet.delegate = self
        cv_selPet.dataSource = self
        cv_selPet.showsHorizontalScrollIndicator = false

        let insetX = 20
        let insetY = 0
        let layout = cv_selPet.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: 100, height: 91)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        cv_selPet.contentInset = UIEdgeInsets(top: CGFloat(insetY), left: CGFloat(insetX), bottom: CGFloat(insetY), right: CGFloat(insetX))

        setData(Global.dailyLifePetsBehaviorRelay.value?.pets as Any)
    }

    private var pets: [Pet]?
    private func setData(_ data: Any) {
        if let pets = data as? [Pet] {
            self.pets = pets

            initSelected()
        }
    }

    var itemSelected: Array<Bool> = Array()
    private func initSelected() {
        itemSelected = Array(repeating: false, count: self.pets!.count)
        for i in 0..<itemSelected.count {
            itemSelected[i] = false
        }
        idxSelectedItem = -1
    }
    private func setSelected(_ selIdx: Int) {
        if (isSingleSelectMode) {
            initSelected()
            itemSelected[selIdx] = true
            idxSelectedItem = selIdx

        } else {
            itemSelected[selIdx].toggle()
        }
    }

    // MARK: - ATTACH FILE
    @IBOutlet weak var cv_attachFile: UICollectionView!

    var arrAtchHybidData = [AtchHybridData]()
    var arrAtchDelete = [PhotoDataUp]()

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

        self.cv_attachFile.reloadData()
    }

    private func requestAddImageFromGallary() {
        reqCloseKeyboard()

        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
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

        Global3.code_list(cmmCdData: ["SCH"]) {
            self.initGubunSelected()
            self.cv_dailyLifeGubun.reloadData()
        }
    }

    var gubunItemSelected: Array<Bool> = Array()
    private func initGubunSelected() {
        if let schCodeList = Global.schCodeList {
            gubunItemSelected = Array(repeating: false, count: schCodeList.count)
            for i in 0..<gubunItemSelected.count {
                gubunItemSelected[i] = false
            }
        }
        idxSelectedGubunItem = -1
    }
    private func setGubunSelected(_ selIdx: Int) {
        if (isGubunSingleSelectMode) {
            initGubunSelected()
            gubunItemSelected[selIdx] = true
            idxSelectedGubunItem = selIdx

        } else {
            gubunItemSelected[selIdx].toggle()
        }
    }

    // MARK: - COMBO TITLE
    @IBOutlet weak var vw_titleArea: UIView!
    @IBOutlet weak var tf_title: UITextField2!
    @IBOutlet weak var vw_titleComboShowingArea: UIView!

    private var dropDown: DropDown?

    private var arrTitleComboText = [String]()

    private func initComboTitle() {
        vw_titleArea.layer.cornerRadius = 12
        vw_titleArea.layer.borderWidth = 1
        vw_titleArea.layer.borderColor = UIColor.init(hex: "#FFE3E9F2")?.cgColor

        tf_title.delegate = self
        tf_title.placeholder = "제목을 입력해주세요"
    }

    private func initTitleComboText() {
        arrTitleComboText.removeAll()

        if let pets = self.pets {
            for i in 0..<pets.count {
                arrTitleComboText.append(String("\(pets[i].petNm)와 즐거운 산책~!"))
            }
        }
    }

    private func showComboData() {
        initTitleComboText()

        dropDown = DropDown()
        guard let dropDown = dropDown else { return }

        // The view to which the drop down will appear on
        dropDown.anchorView = vw_titleComboShowingArea // UIView or UIBarButtonItem

        // The list of self.pets to display. Can be changed dynamically
        dropDown.dataSource = arrTitleComboText

        dropDown.direction = .bottom
        dropDown.offsetFromWindowBottom = 400

        dropDown.width = vw_titleComboShowingArea.frame.size.width

        DropDown.startListeningToKeyboard()

        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            tf_title.text = arrTitleComboText[index]
            tf_title.resignFirstResponder()
        }
    }

    // MARK: - MEMO
    @IBOutlet weak var tv_memo: UITextView2!

    let textViewPlaceHolder = "일상을 기록해주세요"

    private func initMemo() {
        tv_memo.text = textViewPlaceHolder
        tv_memo.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        tv_memo.delegate = self
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
    @IBOutlet weak var tf_hashtag: UITextField2!

    private func initHashtag() {
        tf_hashtag.delegate = self
        inputTextNormalUI(view: tf_hashtag)
    }

    // MARK: - STORY SHARE AGREE
    @IBOutlet weak var btn_storyShareAgree: UIButton!
    @IBOutlet weak var iv_storyShareAgree: UIImageView!
    @IBOutlet weak var vw_storyShareAgree: UIView!

    private func initStoryShareAgree() {
        iv_storyShareAgree.image = UIImage.imageFromColor(color: UIColor.clear)
        btn_storyShareAgree.isSelected = false
        vw_storyShareAgree.backgroundColor = UIColor.white
        vw_storyShareAgree.layer.cornerRadius = 2
        vw_storyShareAgree.layer.borderWidth = 1
        vw_storyShareAgree.layer.borderColor = UIColor.init(hex: "#FFE3E9F2")?.cgColor
    }

    @IBAction func onStoryShareAgreeCheck(_ sender: Any) {
        btn_storyShareAgree.isSelected.toggle()
        if btn_storyShareAgree.isSelected {
            iv_storyShareAgree.image = UIImage(named: "checkbox_white")
            vw_storyShareAgree.backgroundColor = UIColor.init(hex: "#FF4783F5")

        } else {
            iv_storyShareAgree.image = UIImage.imageFromColor(color: UIColor.clear)
            vw_storyShareAgree.backgroundColor = UIColor.white
        }
    }

    // MARK: - SUBMIT
    @IBOutlet weak var btn_complete: UIButton!

    private func initComplete() {
        btn_complete.setAttrTitle("등록하기", 14, UIColor.white)
    }

    @IBAction func onComplete(_ sender: Any) {
        if getSelectedPets().count == 0 {
            self.showToast(msg: "반려동물을 선택해주세요")
            return
        }

        if getSelectedDailyLife().count == 0 {
            self.showToast(msg: "일상구분을 선택해주세요")
            return
        }

        if let text = tf_title.text, text.count == 0 {
            self.showToast(msg: "제목을 입력해주세요")
            return
        }

        if arrAtchHybidData.count == 0 {
            dailylife_create()

        } else {
            dailylife_upload()
        }
    }

    private func getSelectedPets() -> [DailyLifePet] {
        var ret = [DailyLifePet]()

        for i in 0..<itemSelected.count {
            if itemSelected[i] {
                let item = DailyLifePet(ownrPetUnqNo: self.pets![i].ownrPetUnqNo,
                                        petNm: self.pets![i].petNm,
                                        bwlMvmNmtm: "0",
                                        urineNmtm: "0",
                                        relmIndctNmtm: "0")
                ret.append(item)
            }
        }

        return ret
    }

    private func getSelectedDailyLife() -> [String] {
        var ret = [String]()

        if let schCodeList = Global.schCodeList {
            for i in 0..<gubunItemSelected.count {
                if gubunItemSelected[i] {
                    ret.append(schCodeList[i].cdID)
                }
            }
        }

        return ret
    }

    private func getInsertedFile() -> [DailyLifeFile]? {
        guard let fileUploadResult = fileUploadResult, fileUploadResult.count > 0 else { return nil }

        var ret = [DailyLifeFile]()

        for i in 0..<fileUploadResult.count {
            let it = DailyLifeFile(orgnlAtchFileNm: fileUploadResult[i].orgnlAtchFileNm,
                                   atchFileNm: fileUploadResult[i].atchFileNm,
                                   fileExtnNm: fileUploadResult[i].fileExtnNm,
                                   filePathNm: fileUploadResult[i].filePathNm,
                                   flmPstnLat: fileUploadResult[i].flmPstnLat,
                                   flmPstnLot: fileUploadResult[i].flmPstnLot,
                                   atchFileSz: fileUploadResult[i].atchFileSz)
            ret.append(it)
        }

        return ret
    }

    private func getInsertedHash() -> [String] {
        var ret = [String]()

        let arrSplit = tf_hashtag.text!.components(separatedBy: " ")
        for i in 0..<arrSplit.count {
            if arrSplit[i].starts(with: "#") {
                var str = String(arrSplit[i])

                let removeCharacters: Set<Character> = ["#"]
                str.removeAll(where: { removeCharacters.contains($0) })

                ret.append(str)
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

    // MARK: - CONN DAILY-LIFE UPLOAD
    private var fileUploadResult: [PhotoData]?

    private func dailylife_upload() {
        self.startLoading()

        var arrImage = [UIImage]()
        for i in 0..<arrAtchHybidData.count {
            if let image = arrAtchHybidData[i].local {
                arrImage.append(image)
            }
        }

        let request = LifeUploadRequest(arrFile: arrImage)
        DailyLifeAPI.upload(request: request) { response, error in
            self.stopLoading()

            if let response = response {
                if response.statusCode == 200 {
                    self.fileUploadResult = response.data

                    self.dailylife_create()
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

    // MARK: - CONN DAILY-LIFE CREATE
    private func dailylife_create() {
        self.startLoading()

        let request = LifeCreateRequest(cmntUseYn: "Y",
                                        rcmdtnYn: "Y",
                                        rlsYn: btn_storyShareAgree.isSelected ? "Y" : "N",
                                        schTtl: tf_title.text!,
                                        schCn: getMemo(),
                                        hashTag: getInsertedHash(),
                                        pet: getSelectedPets(),
                                        schCdList: getSelectedDailyLife(),
                                        totClr: 0,
                                        totDstnc: 0,
                                        walkDptreDt: "",
                                        walkEndDt: "",
                                        files: getInsertedFile())
        DailyLifeAPI.create(request: request) { response, error in
            self.stopLoading()

            if (response?.data) != nil {
                self.reqRefreshStoryList()
                self.onBack()

            } else {
                self.showAlertPopup(title: "에러", msg: "통신 에러가 발생했어요")
            }

            self.processNetworkError(error)
        }
    }

    // MARK: - Back TitleBar
    @IBOutlet weak var titleBarView: UIView!

    func showBackTitleBarView() {
        if let view = UINib(nibName: "BackTitleBarView", bundle: nil).instantiate(withOwner: self).first as? BackTitleBarView {
            view.frame = titleBarView.bounds
            view.lb_title.text = "일상 등록"
            view.delegate = self
            titleBarView.addSubview(view)
        }
    }
}

extension StoryAddViewController: BackTitleBarViewProtocol {
    func onBack() {
        navigationController?.popViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
}

extension StoryAddViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == cv_selPet {
            if let cnt = self.pets?.count {
                return cnt
            }

        } else if collectionView == cv_attachFile {
            if arrAtchHybidData.count < 5 {
                return arrAtchHybidData.count + 1
            }

            return arrAtchHybidData.count

        } else if collectionView == cv_dailyLifeGubun {
            if let cnt = Global.schCodeList?.count {
                return cnt
            }
        }

        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == cv_selPet {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectPetItemView", for: indexPath) as! SelectPetItemView

            if let pet = self.pets?[indexPath.row] {
                Global2.setPetImage(imageView: cell.ivProf, pet: pet)
                cell.lbName.text = pet.petNm
                cell.update(itemSelected[indexPath.row])
            }

            return cell

        } else if collectionView == cv_attachFile {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "qnaModifyAttachFileItemView", for: indexPath) as! QnAModifyAttachFileItemView
            if indexPath.row > arrAtchHybidData.count - 1 {
                cell.initializeModeAddImage()
                cell.didOnAddItem = {
                    self.requestAddImageFromGallary()
                }
            } else {
                cell.initialize(pathUri: "", data: arrAtchHybidData[indexPath.row])
                cell.didOnRemoveItem = {
                    if let remote = self.arrAtchHybidData[indexPath.row].remote {
                        let data = PhotoDataUp(flmPstnLat: "", filePathNm: remote.filePathNm, flmPstnLot: "", orgnlAtchFileNm: remote.orgnlAtchFileNm, atchFileNm: remote.atchFileNm, atchFileSz: remote.atchFileSz, fileExtnNm: remote.fileExtnNm, atchFileSn: remote.atchFileSn, rowState: "D")
                        self.arrAtchDelete.append(data)
                    }

                    self.arrAtchHybidData.remove(at: indexPath.row)
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

            if let schCodeList = Global.schCodeList {
                cell.lb_gubun.text = schCodeList[indexPath.row].cdNm
                cell.update(gubunItemSelected[indexPath.row])
            }

            return cell
        }

        return UICollectionViewCell()
    }


    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if collectionView == cv_selPet {
            setSelected(indexPath.row)
            cv_selPet.reloadData()

            return itemSelected[indexPath.row]

        } else if collectionView == cv_dailyLifeGubun {
            setGubunSelected(indexPath.row)
            cv_dailyLifeGubun.reloadData()

            return gubunItemSelected[indexPath.row]
        }

        return false
    }
}

extension StoryAddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }

        arrAtchHybidData.append(AtchHybridData(local: image.resizeImageForUpload(maxWidth: 1920, maxHeight: 1080), remote: nil))

        cv_attachFile.reloadData()
    }
}

// MARK: - UITextFieldDelegate
extension StoryAddViewController {
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
extension StoryAddViewController: UITextViewDelegate {

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
