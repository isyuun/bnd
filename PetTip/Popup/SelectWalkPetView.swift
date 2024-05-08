//
//  SelectWalkPetView.swift
//  PetTip
//
//  Created by carebiz on 2/2/24.
//

import UIKit
import AlamofireImage

class SelectWalkPetView: CommonPopupView {

    public var didTapOK: ((_ selectedPets: [Pet]) -> Void)?

    @IBOutlet weak var lb_title: UILabel!

    @IBOutlet weak var iv_chkAll: UIImageView!
    @IBOutlet weak var vw_chkAll: UIView!
    @IBOutlet weak var btn_chkAll: UIButton!
    @IBOutlet weak var lb_chkAll: UILabel!

    @IBOutlet weak var tb_selPet: UITableView!

    @IBOutlet weak var btn_select: UIButton!

    func initialize() {
        self.layer.cornerRadius = 27
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.clipsToBounds = true

        lb_title.text = "누구랑 산책할까요?"

        iv_chkAll.image = UIImage.imageFromColor(color: UIColor.clear)
        vw_chkAll.backgroundColor = UIColor.white
        vw_chkAll.layer.cornerRadius = 2
        vw_chkAll.layer.borderWidth = 1
        vw_chkAll.layer.borderColor = UIColor.init(hex: "#FFE3E9F2")?.cgColor
        lb_chkAll.text = "모두 함께 댕겨요"

        tb_selPet.register(UINib(nibName: "SelectWalkPetItemView", bundle: nil), forCellReuseIdentifier: "SelectWalkPetItemView")
        tb_selPet.delegate = self
        tb_selPet.dataSource = self
        tb_selPet.separatorStyle = .none
        tb_selPet.backgroundColor = UIColor.init(hex: "#FFF6F8FC")

        btn_select.setAttrTitle("산책하기", 14, UIColor.white)
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

            didTapOK?(selectedItems)
        }
    }

    @IBAction func onChkAll(_ sender: Any) {
        btn_chkAll.isSelected.toggle()

        for i in 0..<itemSelected.count {
            itemSelected[i] = btn_chkAll.isSelected
        }

        if btn_chkAll.isSelected {
            iv_chkAll.image = UIImage(named: "checkbox_white")
            vw_chkAll.backgroundColor = UIColor.init(hex: "#FF4783F5")

        } else {
            iv_chkAll.image = UIImage.imageFromColor(color: UIColor.clear)
            vw_chkAll.backgroundColor = UIColor.white
        }

        tb_selPet.reloadData()
    }
}

// MARK: - TABLEVIEW DELEGATE
extension SelectWalkPetView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let cnt = self.pets?.count {
            return cnt

        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectWalkPetItemView", for: indexPath) as! SelectWalkPetItemView

        guard let pets = self.pets else { return cell }
        cell.initialize(pet: pets[indexPath.row])
        cell.setSelect(isSelected: itemSelected[indexPath.row])

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        setSelected(indexPath.row)

        tableView.reloadData()
    }
}
