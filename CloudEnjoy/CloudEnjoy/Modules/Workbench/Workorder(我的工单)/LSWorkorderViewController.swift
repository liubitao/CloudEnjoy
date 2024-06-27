//
//  LSWorkorderViewController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/3.
//

import UIKit
import JXSegmentedView
import SwifterSwift
import LSBaseModules

class LSWorkorderViewController: LSBaseViewController {
    var segmentedView: JXSegmentedView!
    var segmentedDataSource: JXSegmentedTitleDataSource!
    var listContainerView: JXSegmentedListContainerView!
    
    var subViewControllers = [LSWorkorderItemViewController]()
    
    var orderServerStatus: LSOrderServerStatus = .none

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "我的工单"
    }
    
    override func setupNavigation() {
        let rightBarBtn = UIBarButtonItem(image: UIImage(named: "筛选")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(jumpFilter))
        self.navigationItem.rightBarButtonItem = rightBarBtn
    }
    
    override func setupViews() {
        self.segmentedView = {
            let segmentedView = JXSegmentedView()
            segmentedView.delegate = self
            segmentedView.backgroundColor = Color(hexString: "#FFFFFF")
            self.view.addSubview(segmentedView)
            segmentedView.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(2 + UI.STATUS_NAV_BAR_HEIGHT)
                make.left.right.equalToSuperview()
                make.height.equalTo(45)
            }
            
            segmentedDataSource = JXSegmentedTitleDataSource()
            segmentedDataSource.titles = ["今日", "昨日", "本月", "上月", "自定义"]
            segmentedDataSource.titleNormalFont = Font.pingFangRegular(14)
            segmentedDataSource.titleSelectedFont = Font.pingFangRegular(14)
            segmentedDataSource.titleNormalColor = Color(hexString: "#333333")!
            segmentedDataSource.titleSelectedColor = Color(hexString: "#2BB8C2")!
            segmentedView.dataSource = segmentedDataSource
            
            let indicator = JXSegmentedIndicatorLineView()
            indicator.indicatorWidth = 38
            indicator.indicatorHeight = 2
            indicator.indicatorColor = Color(hexString: "#2BB8C2")!
            indicator.verticalOffset = 5
            segmentedView.indicators = [indicator]
            
            
            listContainerView = JXSegmentedListContainerView.init(dataSource: self)
            segmentedView.listContainer = listContainerView
            self.view.addSubview(listContainerView)
            listContainerView.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalTo(segmentedView.snp.bottom)
                make.bottom.equalToSuperview()
            }
            return segmentedView
        }()
    }
    
    override func setupData() {
        for type in LSTimeSectionType.allCases {
            self.subViewControllers.append(LSWorkorderItemViewController(timeSectionType: type))
        }
        self.segmentedView.reloadData()
    }
    
    @objc func jumpFilter() {
        let filterViewController = LSOrderFilterViewController.creaeFromStoryboard()
        filterViewController.orderServerStatus = self.orderServerStatus
        filterViewController.selectedClosure = { orderServerStatus in
            self.orderServerStatus = orderServerStatus
            self.subViewControllers.forEach{$0.changeOrderStatus(orderServerStatus)}
        }
        filterViewController.presentedWith(self)
    }

}

extension LSWorkorderViewController: JXSegmentedViewDelegate, JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        return 5
    }
    
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        return self.subViewControllers[index]
    }
    
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        guard index == 4 else { return }
        let calendarViewController = LSCalendarViewController.creaeFromStoryboard()
        calendarViewController.selectedClosure = {[weak self] startDate, endDate in
            guard let self = self else {return}
            let vc = self.subViewControllers[4]
            let shopStartTime = parametersModel().ShopStartTime
            let shopEndTime = parametersModel().ShopEndTime
            
            vc.startdate = startDate.beginning(of: .day)?.stringTime24(withFormat: "yyyy-MM-dd ").appending(shopStartTime) ?? ""
            vc.enddate = endDate.end(of: .day)?.adding(.day, value: 1).stringTime24(withFormat: "yyyy-MM-dd ").appending(shopEndTime) ?? ""
            vc.timeLab.text = vc.startdate + "至" + vc.enddate
            vc.networkData(page: 1)
        }
        calendarViewController.presentedWith(self)
    }
    
}
