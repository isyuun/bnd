//
//  FindIDPWContainerViewController.swift
//  PetTip
//
//  Created by carebiz on 1/15/24.
//

import Foundation
import Tabman
import Pageboy

class FindIDPWContainerViewController : TabmanViewController {
    
    public var launchTabPageIndex = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        
        viewControllers.append(firstVC)
        viewControllers.append(secondVC)
        
        self.dataSource = self
    }
    
    private var viewControllers: [UIViewController] = []
    let firstVC = UIStoryboard.init(name: "Member", bundle: nil).instantiateViewController(withIdentifier: "FindIdViewController") as! FindIDViewController
    
    let secondVC = UIStoryboard.init(name: "Member", bundle: nil).instantiateViewController(withIdentifier: "FindPwViewController") as! FindPWViewController
    
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
        
        if launchTabPageIndex != 0 {
            self.scrollToPage(.at(index: launchTabPageIndex), animated: false)
        }
    }
}

extension FindIDPWContainerViewController: PageboyViewControllerDataSource, TMBarDataSource {
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        switch index {
        case 0:
            return TMBarItem(title: "아이디 찾기")
        case 1:
            return TMBarItem(title: "비밀번호 찾기")
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
