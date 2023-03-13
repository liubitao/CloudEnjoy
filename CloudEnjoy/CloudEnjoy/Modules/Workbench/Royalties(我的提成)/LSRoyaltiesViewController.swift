//
//  LSRoyaltiesViewController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/3.
//

import UIKit
import JXSegmentedView
import SwifterSwift


class LSRoyaltiesViewController: LSBaseViewController {
    var segmentedView: JXSegmentedView!
    var segmentedDataSource: JXSegmentedTitleDataSource!
    var listContainerView: JXSegmentedListContainerView!
    
    var subViewControllers = [LSRoyaltiesItemController]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的提成"
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
            segmentedView.reloadData()
    
            return segmentedView
        }()
    }

}

extension LSRoyaltiesViewController: JXSegmentedViewDelegate, JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        return 5
    }
    
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        var subViewController =  self.subViewControllers[safe: index]
        if subViewController == nil {
            subViewController = LSRoyaltiesItemController(timeSection: index)
        }
        return subViewController!
    }
    
}
