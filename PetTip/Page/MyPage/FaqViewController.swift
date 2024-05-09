//
//  FaqViewCotroller.swift
//  PetTip
//
//  Created by carebiz on 1/10/24.
//

import UIKit

class FaqViewController: CommonViewController {
    
    @IBOutlet weak var tb_list: UITableView!
    
    var expandedIndexSet : IndexSet = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        showFaqList()
    }
    
    private func showFaqList() {
        tb_list.register(UINib(nibName: "FaqListItemView", bundle: nil), forCellReuseIdentifier: "FaqListItemView")
        tb_list.delegate = self
        tb_list.dataSource = self
        tb_list.separatorStyle = .none
        
        tb_list.rowHeight = UITableView.automaticDimension
        tb_list.estimatedRowHeight = UITableView.automaticDimension
        
        faq_list(false)
    }
    
    
    
    
    
    // MARK: - CONN FAQ LIST
    
    var pageIndex = 1
    var arrFaqList : [BBSFAQList] = []
    var isEnableNextPage = false
    
    private func faq_list(_ isMore: Bool) {
        if (isMore) {
            pageIndex += 1
        } else {
            pageIndex = 1
            arrFaqList = []
            tb_list.reloadData()
        }
        
        self.startLoading()
        
        let request = FaqListRequest(bbsSn: 8, page: 1, pageSize: 10, recordSize: 20)
        BBSAPI.faqList(request: request) { response, error in
            self.stopLoading()
            
            if response?.statusCode == 200 {
                if let faqList = response?.data.bbsFAQList {
                    if (isMore) {
                        for i in 0 ..< faqList.count {
                            self.arrFaqList.append(faqList[i])
                        }
                    } else {
                        self.arrFaqList = faqList
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

extension FaqViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFaqList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FaqListItemView", for: indexPath) as! FaqListItemView
        cell.initialize(faq: arrFaqList[indexPath.row])
        
        if cell.cr_expandAreaHeight != nil {
            cell.cr_expandAreaHeight.isActive = false
        }
        
        if expandedIndexSet.contains(indexPath.row) {
            cell.toExpand()
        } else {
            cell.toUnexpand()
        }
        
        cell.didTapExpand = {
            if self.expandedIndexSet.contains(indexPath.row) {
                self.expandedIndexSet.remove(indexPath.row)
            } else {
                self.expandedIndexSet.insert(indexPath.row)
            }
            
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row == arrFaqList.count - 1) {
            if (isEnableNextPage) {
                faq_list(true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

