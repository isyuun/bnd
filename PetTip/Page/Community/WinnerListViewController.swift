//
//  WinnerListViewController.swift
//  PetTip
//
//  Created by carebiz on 12/30/23.
//

import UIKit

class WinnerListViewController: CommonListViewController {

    @IBOutlet weak var tb_list: UITableView!
    
    var tabBarContainer: CommnunityContainerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showWinnerList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Global.toSchUnqNo != 0 {
            tabBarContainer?.scrollToPage(.at(index: 0), animated: false)
        }
    }
    
    func showWinnerList() {
        tb_list.register(UINib(nibName: "WinnerListViewItem", bundle: nil), forCellReuseIdentifier: "WinnerListViewItem")
        tb_list.delegate = self
        tb_list.dataSource = self
        tb_list.separatorStyle = .none
        
        winner_list(false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueWinnerListToDetail" {
            let dest = segue.destination
            guard let vc = dest as? WinnerDetailViewController else { return }
//            vc.eventListViewController = self
            vc.pstSn = sender as? Int
        }
    }

    // MARK: - CONN EVENT LIST
    var pageIndex = 1
    var arrWinnerList : [BBSWinnerList] = []
    var isEnableNextPage = false
    
    func winner_list(_ isMore: Bool) {
        if (isMore) {
            pageIndex += 1
        } else {
            pageIndex = 1
            arrWinnerList = []
            tb_list.reloadData()
        }
        
        startLoading()
        
        let request = WinnerListRequest(page: pageIndex, pageSize: 10, recordSize: 20)
        BBSAPI.winnerList(request: request) { winnerListData, error in
            self.stopLoading()
            
            if let winnerListData = winnerListData {
            let bbsWinnerList = winnerListData.bbsWinnerList
                if (isMore) {
                    for i in 0 ..< bbsWinnerList.count {
                        self.arrWinnerList.append(bbsWinnerList[i])
                    }
                } else {
                    self.arrWinnerList = bbsWinnerList
                }
                self.tb_list.reloadData()
                
                if let _paginate = winnerListData.paginate {
                    self.isEnableNextPage = _paginate.existNextPage
                }
            }
            
            self.processNetworkError(error)
        }
    }
}

// MARK: - UITableView Delegate
extension WinnerListViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrWinnerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WinnerListViewItem", for: indexPath) as! WinnerListViewItem
        cell.initialize(item: arrWinnerList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row == arrWinnerList.count - 1) {
            if (isEnableNextPage) {
                winner_list(true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WinnerListViewItem", for: indexPath) as! WinnerListViewItem
        cell.initialize(item: arrWinnerList[indexPath.row])
        if cell.isEnable {
            self.performSegue(withIdentifier: "segueWinnerListToDetail", sender: arrWinnerList[indexPath.row].pstSn)
        }
    }
}

