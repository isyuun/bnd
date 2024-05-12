//
//  StoryItemView2.swift
//  PetTip
//
//  Created by isyuun on 2024/5/9.
//

import UIKit

class StoryItemView2: StoryItemView, UICollectionViewDelegate, UICollectionViewDataSource {

    override func initialize(_ _parentWidth: Int, _ _spacing: Int) {
        // NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][_parentWidth:\(_parentWidth)][_spacing:\(_spacing)]")
        super.initialize(_parentWidth, _spacing)
        initDailyLifeGubun()
    }

    @IBOutlet weak var cv_dailyLifeGubun: UICollectionView!

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
        
        NSLog("[LOG][W][(\(#fileID):\(#line))::\(#function)][Global.schCodeList:\(String(describing: Global.schCodeList))]")
        if let schCodeList = Global.schCodeList {
            for i in 0..<schCodeList.count {
                NSLog("[LOG][W][(\(#fileID):\(#line))::\(#function)][schCodeList[i]:\(schCodeList[i])]")
            }
        
        }
        
        self.cv_dailyLifeGubun.reloadData()
    }

    // func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    //     return 0
    // }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == cv_dailyLifeGubun {
            if let cnt = Global.schCodeList?.count {
                NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][collectionView:\(collectionView)][section:\(section)]")
                return cnt
            }
        }
    
        return 0
    }

    // func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    //     return UICollectionViewCell()
    // }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == cv_dailyLifeGubun {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dailyLifeGubunItemView2", for: indexPath) as! DailyLifeGubunItemView2

            if let schCodeList = Global.schCodeList {
                cell.lb_gubun.text = schCodeList[indexPath.row].cdNm
                cell.update(false)  // cell.update(gubunItemSelected[indexPath.row])
                NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][cell:\(cell)][indexPath:\(indexPath)][text:\(String(describing: cell.lb_gubun.text))][cdNm:\(schCodeList[indexPath.row].cdNm)]")
            }

            return cell
        }

        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][collectionView:\(collectionView)][indexPath:\(indexPath)]")
        // if collectionView == cv_dailyLifeGubun {
        //     setGubunSelected(indexPath.row)
        //     cv_dailyLifeGubun.reloadData()
        //
        //     return gubunItemSelected[indexPath.row]
        // }
    
        return false
    }
}
