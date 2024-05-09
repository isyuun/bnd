//
//  WalkHistoryDetailViewController.swift
//  PetTip
//
//  Created by carebiz on 12/14/23.
//

import UIKit
import AlamofireImage
import CoreLocation
import NMapsMap

class WalkHistoryDetailViewController: CommonDetailViewController {

    @IBOutlet weak var lb_dt: UILabel!

    @IBOutlet weak var naverMapView: NMFNaverMapView!

    @IBOutlet weak var cr_imgHeight: NSLayoutConstraint!
    @IBOutlet weak var vw_img: UIView!
    @IBOutlet weak var sv_img: UIScrollView!
    @IBOutlet weak var pc_img: UIPageControl!

    @IBOutlet weak var lb_walker: UILabel!
    @IBOutlet weak var lb_time: UILabel!
    @IBOutlet weak var lb_dist: UILabel!

    @IBOutlet weak var cr_petListAreaHeight: NSLayoutConstraint!
    @IBOutlet weak var vw_petListContent: UIView!

    @IBOutlet weak var cr_msgAreaHeight: NSLayoutConstraint!
    @IBOutlet weak var vw_msgContent: UIView!
    @IBOutlet weak var lb_msg: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        requestLifeViewData()
    }

    // MARK: - CONN LIFE-VIEW DATA
    var schUnqNo: Int? = 0

    var arrTrack = [Track]()

    var slides: [CommonDetailImageItemView]!

    func requestLifeViewData() {
        if let schUnqNo = schUnqNo {
            self.startLoading()

            let request = LifeViewRequest(cmntYn: "N", schUnqNo: schUnqNo)
            DailyLifeAPI.view(request: request) { lifeView, error in
                self.stopLoading()

                if let lifeView = lifeView {
                    self.lb_title?.text = lifeView.lifeViewData.schTTL
                    self.lb_dt.text = lifeView.lifeViewData.walkDptreDt


                    if let fileList = lifeView.lifeViewData.dailyLifeFileList {
                        if (fileList.count > 0) {
                            self.slides = [CommonDetailImageItemView](repeating: CommonDetailImageItemView(), count: fileList.count)

                            self.sv_img.contentSize = CGSize(width: self.sv_img.frame.width * CGFloat(self.slides.count), height: self.sv_img.frame.height)
                            self.sv_img.showsHorizontalScrollIndicator = false
                            self.sv_img.isPagingEnabled = true
                            self.sv_img.delegate = self

                            self.pc_img.numberOfPages = self.slides.count
                            self.pc_img.currentPage = 0

                            for i in 0 ..< fileList.count {
                                let slide = Bundle.main.loadNibNamed("CommonDetailImageItemView", owner: self, options: nil)?.first as! CommonDetailImageItemView

                                slide.frame = CGRect(x: self.sv_img.frame.width * CGFloat(i), y: 0, width: self.sv_img.frame.width, height: self.sv_img.frame.height)

                                slide.iv_img.af.setImage(
                                    withURL: URL(string: String("\(lifeView.lifeViewData.atchPath)\(fileList[i].filePathNm)\(fileList[i].atchFileNm)"))!
                                )
                                slide.didTapImage = {
                                    let vc = UIStoryboard.init(name: "Common", bundle: nil).instantiateViewController(withIdentifier: "ImageViewController") as! ImageViewController
                                    vc.initialize(image: nil, strUrl: String("\(lifeView.lifeViewData.atchPath)\(fileList[i].filePathNm)\(fileList[i].atchFileNm)"))
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }

                                self.slides[i] = slide
                                self.sv_img.addSubview(self.slides[i])
                            }

                        } else {
                            self.pc_img.isHidden = true
                            self.cr_imgHeight.constant = 0
                        }
                    } else {
                        self.pc_img.isHidden = true
                        self.cr_imgHeight.constant = 0
                    }

                    self.lb_walker.text = lifeView.lifeViewData.runNcknm
                    self.lb_time.text = lifeView.lifeViewData.runTime
                    self.lb_dist.text = String(format: "%.1fkm", Float(lifeView.lifeViewData.runDstnc) / Float(1000.0))


                    if let petList = lifeView.lifeViewData.dailyLifePetList {
                        if petList.count > 0 {
                            var petViews = [WalkHistoryPetItemView](repeating: WalkHistoryPetItemView(), count: petList.count)
                            for i in 0 ..< petList.count {
                                if let view = UINib(nibName: "WalkHistoryPetItemView", bundle: nil).instantiate(withOwner: self).first as? WalkHistoryPetItemView
                                {
                                    petViews[i] = view
                                    self.vw_petListContent.addSubview(view)

                                    Global2.setPetImage(imageView: view.iv_prof, petTypCd: petList[i].petTypCd, petImgAddr: petList[i].petImg)

                                    view.lb_nm.text = petList[i].petNm

                                    view.lb_cnt_poop.text = "0회"
                                    view.lb_cnt_pee.text = "0회"
                                    view.lb_cnt_marking.text = "0회"
                                    if let bwlMvmNmtm = petList[i].bwlMvmNmtm {
                                        view.lb_cnt_poop.text = String("\(bwlMvmNmtm)회")
                                    }
                                    if let urineNmtm = petList[i].urineNmtm {
                                        view.lb_cnt_pee.text = String("\(urineNmtm)회")
                                    }
                                    if let relmIndctNmtm = petList[i].relmIndctNmtm {
                                        view.lb_cnt_marking.text = String("\(relmIndctNmtm)회")
                                    }

                                    view.initialize()

                                    view.translatesAutoresizingMaskIntoConstraints = false

                                    var topConstraint: NSLayoutConstraint!
                                    if (i == 0) {
                                        topConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.vw_petListContent, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0)
                                    } else {
                                        topConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: petViews[i - 1], attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 8)
                                    }

                                    let leadingConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.vw_petListContent, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0)

                                    let trailingConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.vw_petListContent, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0)

                                    let heightConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 104)

                                    if (i < petList.count - 1) {
                                        self.vw_petListContent.addConstraints([topConstraint, leadingConstraint, trailingConstraint, heightConstraint])

                                    } else {
                                        let bottomConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.vw_petListContent, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)

                                        self.vw_petListContent.addConstraints([topConstraint, leadingConstraint, trailingConstraint, heightConstraint, bottomConstraint])
                                    }
                                }
                            }
                        } else {
                            self.cr_petListAreaHeight.constant = 0
                        }
                    } else {
                        self.cr_petListAreaHeight.constant = 0
                    }

                    if let schCN = lifeView.lifeViewData.schCN, schCN.count > 0, schCN != " " {
                        self.vw_msgContent.layer.cornerRadius = 10
                        self.vw_msgContent.backgroundColor = UIColor(hex: "#FFF6F8FC")

                        self.lb_msg.preferredMaxLayoutWidth = self.lb_msg.frame.size.width
                        self.lb_msg.text = lifeView.lifeViewData.schCN
                        self.cr_msgAreaHeight.priority = .defaultLow

                    } else {
                        self.cr_msgAreaHeight.constant = 0
                        self.cr_msgAreaHeight.priority = UILayoutPriority.init(1000)
                    }

                    if let totMvmnPathFileSn = lifeView.lifeViewData.totMvmnPathFileSn {
                        self.locationFile(fileSn: totMvmnPathFileSn)
                    }
                }

                self.processNetworkError(error)
            }
        }
    }

    // MARK: - NAVER MAP SHOW
    private func showMap() {
        naverMapView.showCompass = false
        naverMapView.showIndoorLevelPicker = true
        naverMapView.showZoomControls = false
        naverMapView.showLocationButton = false

        naverMapView.mapView.mapType = .navi
        naverMapView.mapView.isNightModeEnabled = traitCollection.userInterfaceStyle == .dark ? true : false // default:false
//        naverMapView.mapView.positionMode = .direction
        naverMapView.mapView.zoomLevel = 17
        naverMapView.mapView.minZoomLevel = 5.0
//        naverMapView.mapView.maxZoomLevel = 18.0

        showTrackSummaryMap()

        let pathOverlay = NMFPath()
        pathOverlay.width = 6
        pathOverlay.color = UIColor(hex: "#A0FFDBDB")!
        pathOverlay.outlineWidth = 2
        pathOverlay.outlineColor = UIColor(hex: "#A0FF5000")!
        pathOverlay.mapView = naverMapView.mapView

        for i in 0..<arrTrack.count {
            if i == 0 {
                let startMarker = NMapViewController.getTextMarker(loc: NMGLatLng(lat: arrTrack[i].location!.coordinate.latitude, lng: arrTrack[i].location!.coordinate.longitude), text: "출발", forceShow: true)
                startMarker.mapView = self.naverMapView.mapView
            }

            if i == arrTrack.count - 1 {
                let endMarker = NMapViewController.getTextMarker(loc: NMGLatLng(lat: arrTrack[i].location!.coordinate.latitude, lng: arrTrack[i].location!.coordinate.longitude), text: "도착", forceShow: true)
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

                } else if arrTrack[i].event! == .img {
                    event = .IMG
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

    // MARK: - CONN LOCATION-FILE DATA
    private func locationFile(fileSn: String) {
        self.startLoading()

        let request = LocationFileRequest(totMvmnPathFileSn: fileSn)
        DailyLifeAPI.locationFile(request: request) { response, error in
            self.stopLoading()

            if let response = response {
                if response.statusCode == 200 {
                    if let data = response.data {
//                        let xml = String(data: data, encoding: .utf8)
                        let parser = XMLParser.init(data: data)
                        parser.delegate = self
                        parser.parse()

                    } else {

                    }
                }
                else if response.statusCode == 406 {
                    self.showAlertPopup(title: "에러", msg: "406 통신 에러가 발생했어요")

                } else {
                    self.showAlertPopup(title: "에러", msg: "통신 에러가 발생했어요")
                    //self.showAlertPopup(title: response.resultMessage, msg: response.detailMessage!)
                }
            }

            self.processNetworkError(error)
        }
    }

    var trackEvent: String?
    var trackLat: String?
    var trackLon: String?
}

// MARK: - LOCATION DATA XML PARSE
extension WalkHistoryDetailViewController: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String] = [:]) {

        for (attr_key, attr_val) in attributeDict {
            if attr_key == "event" {
                trackEvent = attr_val
            } else if attr_key == "lat" {
                trackLat = attr_val
            } else if attr_key == "lon" {
                trackLon = attr_val
            }

            if let trackEvent = trackEvent, let trackLat = trackLat, let trackLon = trackLon {
                let track = Track()

                switch trackEvent {
                case "NNN":
                    track.event = .non
                    break
                case "PEE":
                    track.event = .pee
                    break
                case "POO":
                    track.event = .poo
                    break
                case "MRK":
                    track.event = .mrk
                    break
                case "IMG":
                    track.event = .img
                    break
                default:
                    break
                }

                track.location = CLLocation(latitude: Double(trackLat)!, longitude: Double(trackLon)!)

                arrTrack.append(track)

                self.trackEvent = nil
                self.trackLat = nil
                self.trackLon = nil
            }

//            print("Key: \(attr_key), value: \(attr_val)")
        }
    }

    func parserDidEndDocument(_ parser: XMLParser) {
        showMap()
    }
}

// MARK: - IMAGE VIEW SCROLLVIEW DELEGATE
extension WalkHistoryDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
        if (Int(pageIndex) > slides.count - 1) {
            return
        }

        pc_img.currentPage = Int(pageIndex)

        let maximumHorizontalOffset: CGFloat = scrollView.contentSize.width - scrollView.frame.width
        let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x

        let maximumVerticalOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.height
        let currentVerticalOffset: CGFloat = scrollView.contentOffset.y

        let percentageHorizontalOffset: CGFloat = currentHorizontalOffset / maximumHorizontalOffset
        let percentageVerticalOffset: CGFloat = currentVerticalOffset / maximumVerticalOffset

        let percentOffset: CGPoint = CGPoint(x: percentageHorizontalOffset, y: percentageVerticalOffset)

        let itemOffset = 1 / Float(slides.count - 1)
        if itemOffset > 0 && percentOffset.x > 0 && percentOffset.x <= 1 {
            let transOffset = CGFloat(itemOffset) * CGFloat(Int(pageIndex) + 1)

            if (Int(pageIndex) < slides.count - 1) {
                slides[Int(pageIndex)].iv_img.transform = CGAffineTransform(scaleX: (transOffset - percentOffset.x) / CGFloat(itemOffset), y: (transOffset - percentOffset.x) / CGFloat(itemOffset))
                slides[Int(pageIndex) + 1].iv_img.transform = CGAffineTransform(scaleX: percentOffset.x / transOffset, y: percentOffset.x / transOffset)

            } else {
                slides[Int(pageIndex)].iv_img.transform = CGAffineTransform(scaleX: percentOffset.x, y: percentOffset.x)
            }
        }
    }
}
