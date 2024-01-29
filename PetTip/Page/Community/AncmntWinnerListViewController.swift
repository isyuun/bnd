//
//  AncmntWinnerListViewController.swift
//  PetTip
//
//  Created by carebiz on 12/30/23.
//

import UIKit

class AncmntWinnerListViewController: CommonViewController {
    
    @IBOutlet weak var tb_list: UITableView!
    
    var tabBarContainer: CommnunityContainerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showAncmntWinnerList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Global.toSchUnqNo != 0 {
            tabBarContainer?.scrollToPage(.at(index: 0), animated: false)
        }
    }
    
    func showAncmntWinnerList() {
        tb_list.register(UINib(nibName: "AncmntListItemView", bundle: nil), forCellReuseIdentifier: "AncmntListItemView")
        tb_list.delegate = self
        tb_list.dataSource = self
        tb_list.separatorStyle = .none
        
        ancmntWinner_list(false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueAncmntWinnerListToDetail" {
            let dest = segue.destination
            guard let vc = dest as? AncmntWinnerDetailViewController else { return }
//            vc.eventListViewController = self
            vc.pstSn = sender as? Int
        }
    }
    
    
    
    
    
    // MARK: - CONN EVENT LIST
    
    var pageIndex = 1
    var arrAncmntWinnerList : [BBSAncmntWinnerList] = []
    var isEnableNextPage = false
    
    func ancmntWinner_list(_ isMore: Bool) {
        if (isMore) {
            pageIndex += 1
        } else {
            pageIndex = 1
            arrAncmntWinnerList = []
            tb_list.reloadData()
        }
        
        startLoading()
        
        let request = AncmntWinnerListRequest(page: pageIndex, pageSize: 10, recordSize: 20)
        BBSAPI.ancmntWinnerList(request: request) { ancmntWinnerListData, error in
            self.stopLoading()
            
            if let ancmntWinnerListData = ancmntWinnerListData {
                let bbsAncmntWinnerList = ancmntWinnerListData.bbsAncmntWinnerList
                if (isMore) {
                    for i in 0 ..< bbsAncmntWinnerList.count {
                        self.arrAncmntWinnerList.append(bbsAncmntWinnerList[i])
                    }
                } else {
                    self.arrAncmntWinnerList = bbsAncmntWinnerList
                }
                self.tb_list.reloadData()
                
                if let _paginate = ancmntWinnerListData.paginate {
                    self.isEnableNextPage = _paginate.existNextPage
                }
            }
            
            self.processNetworkError(error)
        }
    }
}





// MARK: - UITableView Delegate

extension AncmntWinnerListViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAncmntWinnerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AncmntListItemView", for: indexPath) as! AncmntListItemView
        cell.initialize(item: arrAncmntWinnerList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row == arrAncmntWinnerList.count - 1) {
            if (isEnableNextPage) {
                ancmntWinner_list(true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AncmntListItemView", for: indexPath) as! AncmntListItemView
        cell.initialize(item: arrAncmntWinnerList[indexPath.row])
        if cell.isEnable {
            self.performSegue(withIdentifier: "segueAncmntWinnerListToDetail", sender: arrAncmntWinnerList[indexPath.row].pstSn)
        }
    }
}

