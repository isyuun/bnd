//
//  StoryListViewController.swift
//  PetTip
//
//  Created by carebiz on 12/17/23.
//

import UIKit
import DropDown
import AlamofireImage

class StoryListViewController: CommonListViewController {

    @IBOutlet weak var vw_sort: UIView!
    @IBOutlet weak var lb_sort: UILabel!

    @IBOutlet weak var vw_mode: UIView!
    @IBOutlet weak var lb_mode: UILabel!

    var isRequireRefresh = false

    override func viewDidLoad() {
        super.viewDidLoad()

        showCommonUI()

        showStoryList()
    }

    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            if Global.toSchUnqNo != 0 {
                self.performSegue(withIdentifier: "segueStoryListToDetail", sender: Global.toSchUnqNo)
                Global.toSchUnqNo = 0
            }
        })

        if isRequireRefresh {
            requestStoryList(false)
        }
    }

    // MARK: - COMMON UI
    @IBOutlet weak var btn_storyWrite: UIControl!

    private func showCommonUI() {
        btn_storyWrite.backgroundColor = UIColor(hex: "#FFF54F68")
        btn_storyWrite.layer.cornerRadius = btn_storyWrite.bounds.size.width / 2
        btn_storyWrite.layer.shadowRadius = 2
        btn_storyWrite.layer.shadowOpacity = 0.2
        btn_storyWrite.layer.shadowOffset = CGSize(width: 2, height: 4)
    }

    @IBAction func onStoryWrite(_ sender: Any) {
        btn_storyWrite.backgroundColor = UIColor(hex: "#FFF54F68")

        if let petList = Global.dailyLifePetsBehaviorRelay.value, petList.pets.count > 0 {
            self.performSegue(withIdentifier: "segueStoryListToAdd", sender: self)
        } else {
            self.showToast(msg: "등록된 펫이 없습니다")
        }
    }
    @IBAction func onStoryWrite_TouchDown(_ sender: Any) {
        btn_storyWrite.backgroundColor = UIColor(hex: "#FFD74F68")
    }
    @IBAction func onStoryWrite_TouchUpOutside(_ sender: Any) {
        btn_storyWrite.backgroundColor = UIColor(hex: "#FFF54F68")
    }

    // MARK: - SEARCH COMBO BOX
    var sortOrderParam: String = "001"
    var showModeParam: String = "001"

    @IBAction func onSortOrder(_ sender: Any) {
        // 최신순 001, 인기순 002

        let dropDown = DropDown()

        // The view to which the drop down will appear on
        dropDown.anchorView = vw_sort // UIView or UIBarButtonItem

        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = ["최신순", "인기순"]

        DropDown.startListeningToKeyboard()

        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
//          print("Selected item: \(item) at index: \(index)")
            let selectedItemParam = index == 0 ? "001" : "002"
            if (selectedItemParam != sortOrderParam) {
                lb_sort.text = item
                sortOrderParam = selectedItemParam

                requestStoryList(false)
            }
        }
    }

    @IBAction func onShowMode(_ sender: Any) {
        // 전체 001, 내 스토리 002

        let dropDown = DropDown()

        // The view to which the drop down will appear on
        dropDown.anchorView = vw_mode // UIView or UIBarButtonItem

        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = ["전체", "내 스토리"]

        DropDown.startListeningToKeyboard()

        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
//          print("Selected item: \(item) at index: \(index)")
            let selectedItemParam = index == 0 ? "001" : "002"
            if (selectedItemParam != showModeParam) {
                lb_mode.text = item
                showModeParam = selectedItemParam

                requestStoryList(false)
            }
        }
    }

    @IBOutlet weak var storyCollectionView: UICollectionView!

    var pageIndex = 1
    var arrStoryList: [StoryListObj] = []
    var isEnableNextPage = false

    private func showStoryList() {
        let layout = storyCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 12
        layout.scrollDirection = .vertical
        storyCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)

        storyCollectionView.delegate = self
        storyCollectionView.dataSource = self

        // 스크롤 시 빠르게 감속 되도록 설정
        storyCollectionView.decelerationRate = UIScrollView.DecelerationRate.fast

        requestStoryList(false)
    }

    private func requestStoryList(_ isMore: Bool) {
        var delay = 0.0
        if (isMore) {
            delay = 0.0
            pageIndex += 1
        } else {
            delay = 0.2
            pageIndex = 1
            arrStoryList = []
            storyCollectionView.reloadData()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            self.story_list(isMore)
        })
    }

    func story_list(_ isMore: Bool) {
        startLoading()

        let request = StoryListRequest(orderType: sortOrderParam, viewType: showModeParam, page: pageIndex, pageSize: 10, recordSize: 20)
        StoryAPI.list(request: request) { storyList, error in
            self.stopLoading()

            if let storyList = storyList {
                if let _storyList = storyList.storyListData.storyList {
                    if (isMore) {
                        for i in 0 ..< _storyList.count {
                            self.arrStoryList.append(_storyList[i])
                        }
                    } else {
                        self.arrStoryList = _storyList
                    }
                    self.storyCollectionView.reloadData()
                }
            
                if let _paginate = storyList.storyListData.paginate {
                    self.isEnableNextPage = _paginate.existNextPage
                }
            }

            self.processNetworkError(error)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueStoryListToDetail") {
            let dest = segue.destination
            guard let vc = dest as? StoryDetailViewController else { return }
            vc.storyListViewController = self
            vc.schUnqNo = sender as? Int

        } else if (segue.identifier == "segueStoryListToAdd") {
            let dest = segue.destination
            guard let vc = dest as? StoryAddViewController else { return }
            vc.storyListViewController = self
        }
    }
}





// MARK: - Story Delegate
extension StoryListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = storyCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        return StoryItemView.getCalcSize(Int(collectionView.bounds.width), Int(layout.minimumLineSpacing))
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrStoryList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "storyItemView", for: indexPath) as! StoryItemView
        let layout = storyCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        cell.initialize(Int(storyCollectionView.bounds.size.width), Int(layout.minimumLineSpacing))

        let storyListObj = arrStoryList[indexPath.row]
        if let storyImgSrc = arrStoryList[indexPath.row].storyFile {
            cell.storyImgView.af.setImage(
                withURL: URL(string: storyImgSrc)!,
                placeholderImage: UIImage(named: "img_blank"),
                filter: AspectScaledToFillSizeFilter(size: cell.storyImgView.frame.size)
            )
        } else {
            cell.storyImgView.image = UIImage(named: "img_blank")
        }
        cell.lb_schTtl.text = storyListObj.schTTL
        cell.lb_petNM.text = storyListObj.petNm
        cell.lb_cmdtnCnt.text = storyListObj.rcmdtnCnt
        cell.lb_cmntCnt.text = storyListObj.cmntCnt

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.row == arrStoryList.count - 1) {
            if (isEnableNextPage) {
                requestStoryList(true)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let bldYn = arrStoryList[indexPath.row].bldYn, bldYn == "Y" {
            self.showToast(msg: arrStoryList[indexPath.row].schTTL)
        } else {
            self.performSegue(withIdentifier: "segueStoryListToDetail", sender: arrStoryList[indexPath.row].schUnqNo)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView.numberOfItems(inSection: section) == 1 {
            let layout = storyCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
            let singleItemRightInset = StoryItemView.getCalcSize(Int(collectionView.bounds.width), Int(layout.minimumLineSpacing)).width + layout.minimumLineSpacing
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: singleItemRightInset)

        } else {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
}
