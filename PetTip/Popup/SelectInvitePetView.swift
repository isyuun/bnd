//
//  SelectPetView.swift
//  PetTip
//
//  Created by carebiz on 12/9/23.
//

import UIKit
import AlamofireImage

class SelectInvitePetView: CommonPopupView {

    @IBOutlet weak var lb_title: UILabel!
    @IBOutlet weak var selPetColView: UICollectionView!
    @IBOutlet weak var btn_select: UIButton!

    @IBOutlet weak var btn_isExistDeadline: UIButton!
    @IBOutlet weak var cr_deadlineInfoAreaHeight: NSLayoutConstraint!
    @IBOutlet weak var vw_deadlineInfoArea: UIView!
    @IBOutlet weak var vw_deadlineInfoBoxArea: UIView!
    @IBOutlet weak var lb_deadlineDt: UILabel!

    public var didTapOK: ((_ selectedPets: [Pet], _ endDt: String) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func initialize() {
        self.layer.cornerRadius = 27
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.clipsToBounds = true

        selPetColView.register(UINib(nibName: "SelectPetItemView", bundle: nil), forCellWithReuseIdentifier: "SelectPetItemView")
        selPetColView.delegate = self
        selPetColView.dataSource = self
        selPetColView.showsHorizontalScrollIndicator = false

        let insetX = 20
        let insetY = 0
        let layout = selPetColView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: 100, height: 91)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        selPetColView.contentInset = UIEdgeInsets(top: CGFloat(insetY), left: CGFloat(insetX), bottom: CGFloat(insetY), right: CGFloat(insetX))

        self.btn_isExistDeadline.layer.borderWidth = 1
        self.btn_isExistDeadline.layer.borderColor = UIColor.init(hex: "#FFE3E9F2")?.cgColor
        self.btn_isExistDeadline.setImage(UIImage.imageFromColor(color: UIColor.white), for: .normal)
        self.btn_isExistDeadline.setImage(UIImage.init(named: "checkbox_white"), for: .selected)
        self.btn_isExistDeadline.isSelected = false

        self.vw_deadlineInfoBoxArea.layer.cornerRadius = 5

        self.cr_deadlineInfoAreaHeight.constant = 0
        self.vw_deadlineInfoArea.isHidden = true
        self.lb_deadlineDt.text = "-"
    }

    var idxSelectedItem = -1
    var isSingleSelectMode = true

    private var pets: [Pet]?
    func setData(_ data: Any) {
        if let pets = data as? [Pet] {
            self.pets = pets
            initSelected()
        }
    }

    var itemSelected: Array<Bool> = Array()
    func initSelected() {
        itemSelected = Array(repeating: false, count: self.pets!.count)
        for i in 0..<itemSelected.count {
            itemSelected[i] = false
        }
        idxSelectedItem = -1
    }
    func setSelected(_ selIdx: Int) {
        if (isSingleSelectMode) {
            initSelected()
            itemSelected[selIdx] = true
            idxSelectedItem = selIdx

        } else {
            itemSelected[selIdx].toggle()
        }
    }

    var deadlineDateTime: String = "299912311159"

    @IBAction func onIsExistDeadline(_ sender: Any) {
        btn_isExistDeadline.isSelected.toggle()

        if btn_isExistDeadline.isSelected {
            UIView.animate(withDuration: 0.25) {
                self.cr_deadlineInfoAreaHeight.constant = 58
                self.layoutIfNeeded()
            } completion: { flag in
                self.btn_isExistDeadline.backgroundColor = UIColor.init(hex: "#FF4783F5")
                self.vw_deadlineInfoArea.isHidden = false
                self.deadlineDateTime = ""
            }
        } else {
            UIView.animate(withDuration: 0.25) {
                self.cr_deadlineInfoAreaHeight.constant = 0
                self.layoutIfNeeded()
            } completion: { flag in
                self.btn_isExistDeadline.backgroundColor = UIColor.white
                self.vw_deadlineInfoArea.isHidden = true
                self.deadlineDateTime = "299912311159"
            }
        }
    }

    @IBAction func onSelectDeadlineDateTime(_ sender: Any) {
        showSelectDeadlineDateTimePopup()
    }

    func showSelectDeadlineDateTimePopup() {
        guard let parentViewController = parentViewController else { return }

        if let v = UINib(nibName: "DatePickerView", bundle: nil).instantiate(withOwner: self).first as? DatePickerView {
            v.initialize()
            v.didTapOK = { datetime in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyyMMddHHmm"
                let date = dateFormatter.date(from: datetime)

                if Date().dateCompare(fromDate: date!) == "Past" {
                    parentViewController.showToast(msg: "이미 만료된 일시입니다")
                } else {
                    self.deadlineDateTime = datetime

                    let dateFormatter2 = DateFormatter()
                    dateFormatter2.dateFormat = "yyyy.MM.dd HH:mm"
                    self.lb_deadlineDt.text = dateFormatter2.string(from: date!)

                    parentViewController.didTapPopupOK()
                }
            }
            v.didTapCancel = {
                parentViewController.didTapPopupCancel()
            }

            parentViewController.popupShow(contentView: v, wSideMargin: 0)
        }
    }

    @IBAction func onSelectPet(_ sender: Any) {

        if isSingleSelectMode == false {
            var selectedItems = [Pet]()
            if let pets = self.pets {
                for i in 0..<pets.count {
                    if itemSelected[i] == true {
                        selectedItems.append(pets[i])
                    }
                }
            }
            if selectedItems.count == 0 {
                parentViewController!.showToast(msg: "펫을 선택해 주세요")
                return
            }

            if deadlineDateTime == "" {
                parentViewController!.showToast(msg: "종료할 일시를 선택해주세요")
                return
            }

            didTapOK?(selectedItems, deadlineDateTime)
        }
    }
}

extension SelectInvitePetView: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let cnt = self.pets?.count {
            return cnt > 0 ? cnt : 1
        } else {
            return 1
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectPetItemView", for: indexPath) as! SelectPetItemView

        if let pet = self.pets?[indexPath.row] {
            setPetImage(imageView: cell.ivProf, pet: pet)
            cell.lbName.text = pet.petNm
            cell.update(itemSelected[indexPath.row])
        }

        return cell
    }


    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        setSelected(indexPath.row)
        selPetColView.reloadData()

        return itemSelected[indexPath.row]
    }
}
