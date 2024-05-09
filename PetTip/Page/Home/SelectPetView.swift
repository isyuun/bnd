//
//  SelectPetView.swift
//  PetTip
//
//  Created by carebiz on 12/9/23.
//

import UIKit
import AlamofireImage

class SelectPetView: UIView {

    var delegate: SelectPetViewProtocol!
    func setDelegate(_ _delegate: SelectPetViewProtocol) {
        delegate = _delegate
    }

    @IBOutlet weak var selPetColView: UICollectionView!

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func initialize() {
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
        if let _delegate = delegate {
            _delegate.onSelectPet(idxSelectedItem)
        }
    }
}

extension SelectPetView: UICollectionViewDataSource, UICollectionViewDelegate {
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
            Global2.setPetImage(imageView: cell.ivProf, pet: pet)
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

protocol SelectPetViewProtocol: AnyObject {
    func onSelectPet(_ selectedIdx: Int)
}
