//
//  TestTableViewInSheet.swift
//  PetTip
//
//  Created by carebiz on 12/8/23.
//

import UIKit
import AlamofireImage

class CompPetListView : UIView {
    
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var constraintHeightTableView : NSLayoutConstraint!
    
    @IBOutlet weak var btnAddPet : UIButton!
    @IBOutlet weak var btnPetManage : UIButton!
    
    var delegate : CompPetListViewProtocol!
    func setDelegate(_ _delegate : CompPetListViewProtocol) {
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
    
    var itemDatas: [MyPet]?
    func setData(_ data: Any) {
        if let items = data as? [MyPet] {
            itemDatas = items
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
            if let itemDatas = itemDatas, let indexPath = tableView.indexPathForSelectedRow {
                delegate.onPetManage(myPet: itemDatas[indexPath.row])
            }
        }
    }
}

extension CompPetListView : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let cnt = itemDatas?.count {
            return cnt > 0 ? cnt : 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompPetListItemView", for: indexPath) as! CompPetListItemView
        
        if (itemDatas?.count == 0) {
            cell.lbTitle.text = "등록된 반려동물이 없어요"
            
            cell.lbNone.isHidden = false
            cell.vwProfIvBorder.isHidden = true
            cell.ivProf.isHidden = true
            cell.lbTitle.isHidden = true
            cell.lbSubtitle.isHidden = true
            
        } else {
            if let _itemDatas = itemDatas {
                if let petRprsImgAddr = _itemDatas[indexPath.row].petRprsImgAddr {
                    cell.ivProf.af.setImage(
                        withURL: URL(string: petRprsImgAddr)!,
                        placeholderImage: UIImage(named: "profile_default")!,
                        filter: AspectScaledToFillSizeFilter(size: cell.ivProf.frame.size)
                    )
                } else {
                    cell.ivProf.image = UIImage(named: "profile_default")
                }
                
                cell.lbTitle.text = _itemDatas[indexPath.row].petNm
                
                cell.lbSubtitle.text = _itemDatas[indexPath.row].petKindNm 
                + " | " + Util.transDiffDateStr(_itemDatas[indexPath.row].petBrthYmd)
                    + " | " + _itemDatas[indexPath.row].sexTypNm
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
        if (itemDatas?.count == 0) {
            return false
        } else {
            return true
        }
    }
}

protocol CompPetListViewProtocol: AnyObject {
    func onAddPet()
    func onPetManage(myPet: MyPet)
}
