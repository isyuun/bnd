//
//  OneNOneInquiryViewController.swift
//  PetTip
//
//  Created by carebiz on 1/10/24.
//

import UIKit

class QnAViewController: CommonViewController {
    
    @IBOutlet weak var tb_list: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        showQnAList()
    }
        
    private func showQnAList() {
        tb_list.register(UINib(nibName: "QnAListItemView", bundle: nil), forCellReuseIdentifier: "QnAListItemView")
        tb_list.delegate = self
        tb_list.dataSource = self
        tb_list.separatorStyle = .none
        
        qna_list(false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueQnAListToDetail") {
            let dest = segue.destination
            guard let vc = dest as? QnADetailViewController else { return }
            vc.pstSn = sender as? Int
            vc.didListChanged = {
                self.qna_list(false)
            }
            
        } else if (segue.identifier == "segueQnAListToAdd") {
            let dest = segue.destination
            guard let vc = dest as? QnAAddViewController else { return }
            vc.didListChanged = {
                self.qna_list(false)
            }
        }
    }
    
    
    
    
    
    // MARK: - CONN Q&A LIST
    
    var pageIndex = 1
    var arrQnaList : [BBSQnaList] = []
    var isEnableNextPage = false
    
    private func qna_list(_ isMore: Bool) {
        if (isMore) {
            pageIndex += 1
        } else {
            pageIndex = 1
            arrQnaList = []
            tb_list.reloadData()
        }
        
        startLoading()
        
        let request = QnAListRequest(bbsSn: 10, page: 1, pageSize: 10, recordSize: 20)
        BBSAPI.qnaList(request: request) { response, error in
            self.stopLoading()
            
            if response?.statusCode == 200 {
                if let qnaList = response?.data.bbsQnaList {
                    if (isMore) {
                        for i in 0 ..< qnaList.count {
                            self.arrQnaList.append(qnaList[i])
                        }
                    } else {
                        self.arrQnaList = qnaList
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

extension QnAViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrQnaList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QnAListItemView", for: indexPath) as! QnAListItemView
        cell.initialize(qna: arrQnaList[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row == arrQnaList.count - 1) {
            if (isEnableNextPage) {
                qna_list(true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "segueQnAListToDetail", sender: arrQnaList[indexPath.row].pstSn)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
