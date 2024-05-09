//
//  NoticeViewController.swift
//  PetTip
//
//  Created by carebiz on 1/10/24.
//

import UIKit

class NoticeViewController: CommonViewController {
    
    @IBOutlet weak var tb_list: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        showNoticeList()
    }
    
    private func showNoticeList() {
        tb_list.register(UINib(nibName: "NoticeListItemView", bundle: nil), forCellReuseIdentifier: "NoticeListItemView")
        tb_list.delegate = self
        tb_list.dataSource = self
        tb_list.separatorStyle = .none
        
        notice_list(false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueNoticeListToDetail") {
            let dest = segue.destination
            guard let vc = dest as? NoticeDetailViewController else { return }
            vc.pstSn = sender as? Int
        }
    }
    
    
    
    
    
    // MARK: - CONN NOTICE LIST
    
    var pageIndex = 1
    var arrNoticeList : [BBSNtcList] = []
    var isEnableNextPage = false
    
    private func notice_list(_ isMore: Bool) {
        if (isMore) {
            pageIndex += 1
        } else {
            pageIndex = 1
            arrNoticeList = []
            tb_list.reloadData()
        }
        
        self.startLoading()
        
        let request = NoticeListRequest(bbsSn: 7, page: pageIndex, pageSize: 10, recordSize: 20)
        BBSAPI.noticeList(request: request) { response, error in
            self.stopLoading()
            
            if response?.statusCode == 200 {
                if let noticeList = response?.data.bbsNtcList {
                    if (isMore) {
                        for i in 0 ..< noticeList.count {
                            self.arrNoticeList.append(noticeList[i])
                        }
                    } else {
                        self.arrNoticeList = noticeList
                    }
                    self.tb_list.reloadData()
                    
                    if let _paginate = response?.data.paginate {
                        self.isEnableNextPage = _paginate.existNextPage
                    }
                }
            }
            
            self.processNetworkError(error)
        }
    }
}





// MARK: - UITableView Delegate

extension NoticeViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrNoticeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeListItemView", for: indexPath) as! NoticeListItemView
        cell.initialize(notice: arrNoticeList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row == arrNoticeList.count - 1) {
            if (isEnableNextPage) {
                notice_list(true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "segueNoticeListToDetail", sender: arrNoticeList[indexPath.row].pstSn)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


