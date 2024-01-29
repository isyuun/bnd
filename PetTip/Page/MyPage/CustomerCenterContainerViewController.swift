//
//  CustomerCenterContainerViewController.swift
//  PetTip
//
//  Created by carebiz on 1/10/24.
//

import UIKit
import Tabman
import Pageboy

class CustomerCenterContainerViewController : TabmanViewController {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        
        viewControllers.append(firstVC)
        viewControllers.append(secondVC)
        viewControllers.append(thirdVC)
        
//        firstVC.tabBarContainer = self
//        secondVC.tabBarContainer = self
//        thirdVC.tabBarContainer = self
        
        self.dataSource = self
        
        
        
//        UIImageView *border = [[UIImageView alloc]initWithFrame:CGRectMake(view.frame.origin.x,view.frame.size.height-6, self.view.frame.size.width/divide, 6)];
//              border.backgroundColor = “your color”;
//              [view addSubview:border];
//              [tab.tabBar setSelectionIndicatorImage:[self changeViewToImage:view]];
    }
    
    private var viewControllers: [UIViewController] = []
    let firstVC = UIStoryboard.init(name: "CustomerCenter", bundle: nil).instantiateViewController(withIdentifier: "NoticeViewController") as! NoticeViewController
    
    let secondVC = UIStoryboard.init(name: "CustomerCenter", bundle: nil).instantiateViewController(withIdentifier: "FaqViewController") as! FaqViewController
    
    let thirdVC = UIStoryboard.init(name: "CustomerCenter", bundle: nil).instantiateViewController(withIdentifier: "QnAViewController") as! QnAViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bar = TMBar.ButtonBar()
        bar.layout.transitionStyle = .snap // Customize
        bar.layout.contentMode = .fit
        bar.indicator.tintColor = .black
        bar.indicator.weight = .medium
        bar.buttons.customize { (button) in
            button.tintColor = .gray // 선택 안되어 있을 때
            button.selectedTintColor = .black // 선택 되어 있을 때
            button.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            button.selectedFont = UIFont.systemFont(ofSize: 16, weight: .bold)
        }
        bar.backgroundView.style = .flat(color: UIColor.white)
        
        // Add to view
        addBar(bar, dataSource: self, at: .top)
//        addBar(bar, dataSource: self, at: .custom(view: vw_container, layout: nil))
        
        let underline = UIView(frame: CGRect(x: 0, y: bar.frame.size.height - 1, width: bar.frame.size.width, height: 1))
        underline.backgroundColor = UIColor.init(hex: "#FFE3E9F2")
        self.view.addSubview(underline)
    }
}

extension CustomerCenterContainerViewController: PageboyViewControllerDataSource, TMBarDataSource {
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        switch index {
        case 0:
            return TMBarItem(title: "공지사항")
        case 1:
            return TMBarItem(title: "FAQ")
        case 2:
            return TMBarItem(title: "1:1 문의")
        default:
            let title = "Page \(index)"
           return TMBarItem(title: title)
        }
    }

    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
}
