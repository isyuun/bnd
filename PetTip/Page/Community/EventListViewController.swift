//
//  EventListViewController.swift
//  PetTip
//
//  Created by carebiz on 12/30/23.
//

import UIKit

class EventListViewController: CommonViewController {
    
    @IBOutlet weak var tb_list: UITableView!
    
    var tabBarContainer: CommnunityContainerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showEventList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Global.toSchUnqNo != 0 {
            tabBarContainer?.scrollToPage(.at(index: 0), animated: false)
        }
    }
    
    func showEventList() {
        tb_list.register(UINib(nibName: "EventListItemView", bundle: nil), forCellReuseIdentifier: "EventListItemView")
        tb_list.delegate = self
        tb_list.dataSource = self
        tb_list.separatorStyle = .none
        
        event_list(false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueEventListToDetail") {
            let dest = segue.destination
            guard let vc = dest as? EventDetailViewController else { return }
            vc.pstSn = sender as? Int
        }
    }
    
    
    
    
    
    // MARK: - CONN EVENT LIST
    
    var pageIndex = 1
    var arrEventList : [BBSEvntList] = []
    var isEnableNextPage = false
    
    func event_list(_ isMore: Bool) {
        if (isMore) {
            pageIndex += 1
        } else {
            pageIndex = 1
            arrEventList = []
            tb_list.reloadData()
        }
        
        startLoading()
        
        let request = EventListRequest(page: pageIndex, pageSize: 10, recordSize: 20)
        BBSAPI.eventList(request: request) { eventList, error in
            self.stopLoading()
            
            if let eventList = eventList {
                let _eventList = eventList.eventListData.bbsEvntList
                if (isMore) {
                    for i in 0 ..< _eventList.count {
                        self.arrEventList.append(_eventList[i])
                    }
                } else {
                    self.arrEventList = _eventList
                }
                self.tb_list.reloadData()
                
                if let _paginate = eventList.eventListData.paginate {
                    self.isEnableNextPage = _paginate.existNextPage
                }
            }
            
            self.processNetworkError(error)
        }
    }
}





// MARK: - UITableView Delegate

extension EventListViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrEventList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventListItemView", for: indexPath) as! EventListItemView
        cell.initialize(event: arrEventList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row == arrEventList.count - 1) {
            if (isEnableNextPage) {
                event_list(true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventListItemView", for: indexPath) as! EventListItemView
        cell.initialize(event: arrEventList[indexPath.row])
        if cell.isEnable {
            self.performSegue(withIdentifier: "segueEventListToDetail", sender: arrEventList[indexPath.row].pstSn)
        }
    }
}
