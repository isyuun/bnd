//
//  PostViewController.swift
//  PetTip
//
//  Created by carebiz on 12/2/23.
//

import UIKit
import NMapsMap
import AlamofireImage
import DropDown

class PostViewController: CommonViewController2 {

    var arrTrack: Array<Track>?
    var arrImageFromCamera: [UIImage]?
    var movedSec: Double = 0
    var movedDist: Double = 0
    var selectedPets: [Pet]?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardWhenTappedAround()

        showCommonUI()
    }

    @IBOutlet weak var sv_content: UIScrollView!

    @IBOutlet weak var lb_currDate: UILabel!

    @IBOutlet weak var vw_walkInfoBG: UIView!
    @IBOutlet weak var lb_walkTime: UILabel!
    @IBOutlet weak var lb_walkDist: UILabel!

    @IBOutlet weak var naverMapView: NMFNaverMapView!

    @IBOutlet weak var sv_walkPet: UIStackView!

    private func showCommonUI() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        lb_currDate.text = dateFormatter.string(from: Date())

        showWalkTimeDist()

        showMap()

        showPetData()

        showAttachFile()

        initComboTitle()

        initMemo()

        initHashtag()

        initStoryShareAgree()
    }

    @IBOutlet weak var btnComplete: UIButton!
    @IBAction func onBtnComplete(_ sender: Any) {
        dailylife_upload()
    }

    // MARK: - CONN DAILY-LIFE CREATE
    private func dailylife_create() {
        self.startLoading()

        var walkDptreDt = ""
        var walkEndDt = ""
        if let arrTrack = arrTrack {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMddHHmmss"
            walkDptreDt = dateFormatter.string(from: arrTrack.first!.location!.timestamp)
            walkEndDt = dateFormatter.string(from: arrTrack.last!.location!.timestamp)
        }

        let request = LifeCreateRequest(cmntUseYn: "Y",
                                        rcmdtnYn: "Y",
                                        rlsYn: btn_storyShareAgree.isSelected ? "Y" : "N",
                                        schTtl: tf_title.text!,
                                        schCn: getMemo(),
                                        hashTag: getInsertedHash(),
                                        pet: getSelectedPets(),
                                        schCdList: ["001"],
                                        totClr: 300,
                                        totDstnc: Int(movedDist),
                                        walkDptreDt: walkDptreDt,
                                        walkEndDt: walkEndDt,
                                        files: getInsertedFile())
        DailyLifeAPI.create(request: request) { response, error in
            self.stopLoading()

            if (response?.data) != nil {
                self.navigationController!.popToViewController(self.navigationController!.viewControllers.first!, animated: true)

            } else {
                self.showAlertPopup(title: "에러", msg: "통신 에러가 발생했어요")
            }

            self.processNetworkError(error)
        }
    }

    private func getMemo() -> String {
        if let text = tv_memo.text {
            if text == textViewPlaceHolder { return "" }

            return text
        }

        return ""
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

    private func getSelectedPets() -> [DailyLifePet] {
        var ret = [DailyLifePet]()

        guard let selectedPets = selectedPets else { return ret }

        for i in 0..<selectedPets.count {
            let petEventCnt = getPetEventCnt(pet: selectedPets[i])

            let item = DailyLifePet(ownrPetUnqNo: selectedPets[i].ownrPetUnqNo,
                                    petNm: selectedPets[i].petNm,
                                    bwlMvmNmtm: String(petEventCnt[0]), urineNmtm: String(petEventCnt[1]), relmIndctNmtm: String(petEventCnt[2]))
            ret.append(item)
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

        let request = LifeUploadRequest(arrFile: arrImage, gpxFileData: getGPXData()?.data(using: .utf8))
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

    private func showWalkTimeDist() {
        vw_walkInfoBG.layer.cornerRadius = 20
        vw_walkInfoBG.layer.masksToBounds = true

        let seconds: UInt = UInt(movedSec)
        let minutes = seconds / 60
        let hours = minutes / 60
        lb_walkTime.text = String(format: "%02d:%02d:%02d", hours, minutes % 60, seconds % 60)

        let distKm: Double = movedDist / Double(1000)
        lb_walkDist.text = String(format: "%.2f km", distKm)
    }

    private func showMap() {
        naverMapView.showCompass = false
        naverMapView.showIndoorLevelPicker = true
        naverMapView.showZoomControls = false
        naverMapView.showLocationButton = false

        naverMapView.mapView.mapType = .basic
        naverMapView.mapView.isNightModeEnabled = traitCollection.userInterfaceStyle == .dark ? true : false // default:false
        // naverMapView.mapView.positionMode = .direction
        naverMapView.mapView.zoomLevel = 17
        naverMapView.mapView.minZoomLevel = 5.0
        // naverMapView.mapView.maxZoomLevel = 18.0

        showTrackSummaryMap()

        guard let arrTrack = arrTrack else { return }

        let pathOverlay = NMFPath()
        pathOverlay.width = 6
        pathOverlay.color = UIColor(hex: "#A0FFDBDB")!
        pathOverlay.outlineWidth = 2
        pathOverlay.outlineColor = UIColor(hex: "#A0FF5000")!
        pathOverlay.mapView = naverMapView.mapView

        for i in 0..<arrTrack.count {
            if i == 0 {
                let startMarker = NMapViewController.getTextMarker(loc: NMGLatLng(lat: arrTrack[i].location!.coordinate.latitude, lng: arrTrack[i].location!.coordinate.longitude), text: "출발", forceShow: false)
                startMarker.mapView = self.naverMapView.mapView
            }

            if i == arrTrack.count - 1 {
                let endMarker = NMapViewController.getTextMarker(loc: NMGLatLng(lat: arrTrack[i].location!.coordinate.latitude, lng: arrTrack[i].location!.coordinate.longitude), text: "도착", forceShow: false)
                endMarker.mapView = self.naverMapView.mapView
            }

            if arrTrack[i].event != nil && (arrTrack[i].event == .pee || arrTrack[i].event == .poo || arrTrack[i].event == .mrk) {
                var event: NMapViewController.EventMark = .MRK
                if arrTrack[i].event! == .pee {
                    event = .PEE

                } else if arrTrack[i].event! == .poo {
                    event = .POO

                } else if arrTrack[i].event! == .mrk {
                    event = .MRK
                }

                let eventMarker = NMapViewController.getEventMarker(loc: NMGLatLng(lat: arrTrack[i].location!.coordinate.latitude, lng: arrTrack[i].location!.coordinate.longitude), event: event)
                eventMarker.mapView = self.naverMapView.mapView
            }

            if i == 1 {
                pathOverlay.path = NMGLineString(points: [
                    NMGLatLng(lat: arrTrack[0].location!.coordinate.latitude, lng: arrTrack[0].location!.coordinate.longitude),
                    NMGLatLng(lat: arrTrack[1].location!.coordinate.latitude, lng: arrTrack[1].location!.coordinate.longitude)])
                pathOverlay.mapView = naverMapView.mapView

            } else if i > 1 {
                let path = pathOverlay.path
                path.addPoint(NMGLatLng(lat: arrTrack[i].location!.coordinate.latitude, lng: arrTrack[i].location!.coordinate.longitude))
                pathOverlay.path = path
                pathOverlay.mapView = naverMapView.mapView
            }
        }
    }

    func showTrackSummaryMap() {
        guard let arrTrack = arrTrack else { return }

        var lat1 = Double(arrTrack.first?.location?.coordinate.latitude ?? 0)
        var lon1 = Double(arrTrack.first?.location?.coordinate.longitude ?? 0)
        var lat2 = Double(arrTrack.last?.location?.coordinate.latitude ?? 0)
        var lon2 = Double(arrTrack.last?.location?.coordinate.longitude ?? 0)
        for tr in arrTrack {
            let lat = Double(tr.location?.coordinate.latitude ?? 0)
            let lon = Double(tr.location?.coordinate.longitude ?? 0)
            if (lat < lat1) { lat1 = lat }
            if (lon < lon1) { lon1 = lon }
            if (lat > lat2) { lat2 = lat }
            if (lon > lon2) { lon2 = lon }
        }
        let latLng1 = NMGLatLng(lat: lat1, lng: lon1)
        let latLng2 = NMGLatLng(lat: lat2, lng: lon2)
        let bounds = NMGLatLngBounds(southWest: latLng1, northEast: latLng2)
        let cameraUpdate = NMFCameraUpdate.init(fit: bounds, padding: 40)
        naverMapView.mapView.moveCamera(cameraUpdate)
    }

    private func showPetData() {
        guard let selectedPets = selectedPets, selectedPets.count > 0 else { return }

        for i in 0 ..< selectedPets.count {
            if let view = UINib(nibName: "WalkHistoryPetItemView", bundle: nil).instantiate(withOwner: self).first as? WalkHistoryPetItemView {
                sv_walkPet.addArrangedSubview(view)

                let pet = selectedPets[i]
                Global2.setPetImage(imageView: view.iv_prof, petTypCd: pet.petTypCd, petImgAddr: pet.petRprsImgAddr)

                view.lb_nm.text = selectedPets[i].petNm

                let petEventCnt = getPetEventCnt(pet: selectedPets[i])
                view.lb_cnt_poop.text = String("\(petEventCnt[0])회")
                view.lb_cnt_pee.text = String("\(petEventCnt[1])회")
                view.lb_cnt_marking.text = String("\(petEventCnt[2])회")
                view.initialize()

                view.translatesAutoresizingMaskIntoConstraints = false
            }
        }



    }

    func getPetEventCnt(pet: Pet) -> [Int] {
        var ret = [0, 0, 0]

        guard let arrTrack = arrTrack, arrTrack.count > 0 else { return ret }

        for i in 0..<arrTrack.count {
            guard let trackPet = arrTrack[i].pet else { continue }

            if trackPet.ownrPetUnqNo == pet.ownrPetUnqNo {
                if arrTrack[i].event == .pee {
                    ret[0] += 1

                } else if arrTrack[i].event == .poo {
                    ret[1] += 1

                } else if arrTrack[i].event == .mrk {
                    ret[2] += 1
                }
            }
        }

        return ret
    }

    // MARK: - ATTACH FILE
    @IBOutlet weak var cv_attachFile: UICollectionView!

    var arrAtchHybidData = [AtchHybridData]()
    var arrAtchDelete = [PhotoDataUp]()

    private func showAttachFile() {
        let layout = self.cv_attachFile.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 5
        layout.scrollDirection = .horizontal
        self.cv_attachFile.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)

        self.cv_attachFile.delegate = self
        self.cv_attachFile.dataSource = self
        self.cv_attachFile.showsHorizontalScrollIndicator = false

        // 스크롤 시 빠르게 감속 되도록 설정
        self.cv_attachFile.decelerationRate = UIScrollView.DecelerationRate.fast

        if let arrImageFromCamera = arrImageFromCamera {
            for i in 0..<arrImageFromCamera.count {
                var pic = AtchHybridData()
                pic.local = arrImageFromCamera[i]
                arrAtchHybidData.append(pic)
            }
        }

        self.cv_attachFile.reloadData()
    }

    private func requestAddImageFromGallary() {
        self.view.endEditing(true)

        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum // .photoLibrary
            imagePicker.allowsEditing = false

            present(imagePicker, animated: true, completion: nil)
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
        tf_title.autocorrectionType = .no
        tf_title.spellCheckingType = .no
    }

    private func initTitleComboText() {
        arrTitleComboText.removeAll()

        arrTitleComboText.append("댕댕이와 함께하는 행복한 산책")
        arrTitleComboText.append("댕댕이와 걷기 완료")
        arrTitleComboText.append("댕댕이 응아를 위한 산책")
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
        dropDown.offsetFromWindowBottom = 400

        dropDown.width = vw_titleComboShowingArea.frame.size.width

//        DropDown.startListeningToKeyboard()

        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            tf_title.text = arrTitleComboText[index]
            tf_title.resignFirstResponder()
        }
    }

    // MARK: - MEMO
    @IBOutlet weak var tv_memo: UITextView2!

    let textViewPlaceHolder = "오늘 산책 중 재미있던 일을 기록해주세요."

    private func initMemo() {
        tv_memo.text = textViewPlaceHolder
        tv_memo.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        tv_memo.delegate = self
        tv_memo.autocorrectionType = .no
        tv_memo.spellCheckingType = .no
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

    // MARK: - HASHTAG
    @IBOutlet weak var tf_hashtag: UITextField2!

    private func initHashtag() {
        tf_hashtag.delegate = self
        tf_hashtag.autocorrectionType = .no
        tf_hashtag.spellCheckingType = .no
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

    // MARK: - GPX
    func getGPXData() -> String? {
        guard let arrTrack = arrTrack else { return nil }

        var firstTime = ""
        if let location = arrTrack.first?.location {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMdd.HHmmss"
            firstTime = dateFormatter.string(from: location.timestamp)
        }

        var firstTime2 = ""
        if let location = arrTrack.first?.location {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            firstTime2 = dateFormatter.string(from: location.timestamp)
        }

        let totalDist = String(movedDist / Double(1000))

        let seconds: UInt = UInt(movedSec)
        let minutes = seconds / 60
        let hours = minutes / 60
        let totalTime = String(format: "%02d:%02d:%02d", hours, minutes % 60, seconds % 60)

        var maxAltitudeGap = 0.0
        var maxSpeed = 0.0
        var totalSpeed = 0.0
        for i in 0..<arrTrack.count {
            if i > 0 {
                let prevLocation = arrTrack[i - 1]
                let currentLocation = arrTrack[i]
                let altitudeGap = abs(currentLocation.location!.altitude - prevLocation.location!.altitude)
                if (altitudeGap > maxAltitudeGap) {
                    maxAltitudeGap = altitudeGap
                }
            }

            if arrTrack[i].location!.speed > maxSpeed {
                maxSpeed = arrTrack[i].location!.speed
            }

            totalSpeed += arrTrack[i].location!.speed
        }
        let strMaxAltitudeGap = String(format: "%.2f", maxAltitudeGap)
        let strMaxSpeed = String(format: "%.2f", maxSpeed)
        let strAvgSpeed = String(format: "%.2f", totalSpeed / Double(arrTrack.count))

        let comment = """
                        <!-- Created with PetTip -->
                        <!-- Track = \(arrTrack.count) TrackPoints + 0 Placemarks -->
                        <!-- Track Statistics (based on Total Time | Time in Movement): -->
                        <!-- Distance = \(totalDist) -->
                        <!-- Duration = \(totalTime) | N/A -->
                        <!-- Altitude Gap = \(strMaxAltitudeGap) -->
                        <!-- Max Speed = \(strMaxSpeed) m/s -->
                        <!-- Avg Speed = \(strAvgSpeed) | N/A -->
                        <!-- Direction = N/A -->
                        <!-- Activity = N/A -->
                        <!-- Altitudes = N/A -->
                    """.trimmingCharacters(in: NSCharacterSet.whitespaces) + "\n"

        let metadata = """
                        <metadata>
                         <name>PetTip \(firstTime)</name>
                         <time>\(firstTime2)</time>
                        </metadata>
                    """.trimmingCharacters(in: NSCharacterSet.whitespaces) + "\n"

        let header = """
                        <gpx version="1.1"
                             creator="PetTip"
                             xmlns="http://www.topografix.com/GPX/1/1"
                             xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                             xsi:schemaLocation="$GPX_NAMESPACE http://www.topografix.com/GPX/1/1/gpx.xsd">
                    """.trimmingCharacters(in: NSCharacterSet.whitespaces) + "\n"

        let footer = "</gpx>"

        var trkpt = ""
        for i in 0..<arrTrack.count {
            var no = "P00000000000000"
            if let pet = arrTrack[i].pet {
                no = pet.ownrPetUnqNo
            } else {
                no = "P00000000000000"
            }

            var event = "NNN"
            if let _event = arrTrack[i].event {
                switch _event {
                case .img:
                    event = "IMG"
                    break
                case .mrk:
                    event = "MRK"
                    break
                case .non:
                    event = "NNN"
                    break
                case .pee:
                    event = "PEE"
                    break
                case .poo:
                    event = "POO"
                    break
                }
            }

            var lat = "0"
            if let location = arrTrack[i].location {
                lat = String(location.coordinate.latitude)
            }

            var lon = "0"
            if let location = arrTrack[i].location {
                lon = String(location.coordinate.longitude)
            }

            var time = ""
            if let location = arrTrack[i].location {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                time = dateFormatter.string(from: location.timestamp)
            }

            var speed = ""
            if let location = arrTrack[i].location {
                speed = String(location.speed)
            }

            var altitude = ""
            if let location = arrTrack[i].location {
                altitude = String(location.altitude)
            }

            trkpt.append(
                """
                <trkpt no="\(no)" event="\(event)" lat="\(lat)" lon="\(lon)"><time>\(time)</time><speed>\(speed)</speed><ele>\(altitude)</ele><uri></uri></trkpt>
                """.trimmingCharacters(in: NSCharacterSet.whitespaces) + "\n")
        }

        let trkseg = "<trkseg>\n\(trkpt)</trkseg>\n"
        let trk = "<trk>\n<name>\(firstTime)</name>\n\(trkseg)</trk>\n"
        let content = header + metadata + trkseg + footer

        return comment + content
    }
}

extension PostViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == cv_attachFile {
            if arrAtchHybidData.count < 5 {
                return arrAtchHybidData.count + 1
            }

            return arrAtchHybidData.count

        }

        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == cv_attachFile {
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

        }

        return UICollectionViewCell()
    }
}

extension PostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
extension PostViewController {
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
extension PostViewController: UITextViewDelegate {

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
