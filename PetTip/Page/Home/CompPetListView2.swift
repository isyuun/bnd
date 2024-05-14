//
//  TestTableViewInSheet.swift
//  PetTip
//
//  Created by carebiz on 12/8/23.
//

import UIKit
import AlamofireImage

class CompPetListView2 : UIView {
    
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var constraintHeightTableView : NSLayoutConstraint!
    
    @IBOutlet weak var btnAddPet : UIButton!
    @IBOutlet weak var btnPetManage : UIButton!
    
    var delegate : CompPetListViewProtocol2!
    func setDelegate(_ _delegate : CompPetListViewProtocol2) {
        delegate = _delegate
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder : NSCoder) {
        super.init(coder: aDecoder);
    }
    
    func initialize() {
        tableView.register(UINib(nibName: "CompPetListItemView", bundle: nil), forCellReuseIdentifier: "CompPetListItemView")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
    var pets: [Pet]?
    func setData(_ data: Any) {
        if let items = data as? [Pet] {
            self.pets = items
            tableView.reloadData()
            
            if (items.count < 2) {
                constraintHeightTableView.constant = 72
            } else if (items.count < 3) {
                constraintHeightTableView.constant = 144
            } else if (items.count < 4) {
                constraintHeightTableView.constant = 216
            } else {
                constraintHeightTableView.constant = 252
            }
        }
    }
    
    @IBAction func onAddPet(_ sender: Any) {
        if (delegate != nil) {
            delegate.onAddPet()
        }
    }
    
    @IBAction func onPetManage(_ sender: Any) {
        if (delegate != nil) {
            if let pets = self.pets, let indexPath = tableView.indexPathForSelectedRow {
                delegate.onPetManage(myPet: pets[indexPath.row])
            }
        }
    }
}

extension CompPetListView2 : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let cnt = self.pets?.count {
            return cnt > 0 ? cnt : 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompPetListItemView", for: indexPath) as! CompPetListItemView
        
        if (self.pets?.count == 0) {
            cell.lbTitle.text = "등록된 반려동물이 없어요"
            
            cell.lbNone.isHidden = false
            cell.vwProfIvBorder.isHidden = true
            cell.ivProf.isHidden = true
            cell.lbTitle.isHidden = true
            cell.lbSubtitle.isHidden = true
            
        } else {
            if let pets = self.pets {
                let pet = pets[indexPath.row]
                Global2.setPetImage(imageView: cell.ivProf, petTypCd: pet.petTypCd, petImgAddr: pet.petRprsImgAddr)

                cell.lbTitle.text = pets[indexPath.row].petNm
                
                cell.lbSubtitle.text = pets[indexPath.row].petKindNm 
                + " | " + Util.transDiffDateStr(pets[indexPath.row].age)
                    + " | " + pets[indexPath.row].sexTypNm
            }
            
            cell.lbNone.isHidden = true
            cell.vwProfIvBorder.isHidden = false
            cell.ivProf.isHidden = false
            cell.lbTitle.isHidden = false
            cell.lbSubtitle.isHidden = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if (pets?.count == 0) {
            return false
        } else {
            return true
        }
    }
}

protocol CompPetListViewProtocol2: AnyObject {
    func onAddPet()
    func onPetManage(myPet: Pet)
}
