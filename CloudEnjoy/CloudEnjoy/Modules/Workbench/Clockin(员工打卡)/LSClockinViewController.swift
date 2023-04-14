//
//  LSClockinViewController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/3.
//

import UIKit
import JXSegmentedView
import LSBaseModules
import SwifterSwift

class LSClockinViewController: LSBaseViewController {
    var segmentedView: JXSegmentedView!
    var segmentedDataSource: JXSegmentedTitleDataSource!
    var listContainerView: JXSegmentedListContainerView!
    var subViewControllers: [JXSegmentedListContainerViewListDelegate] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "员工打卡"
    }
    
    override func setupViews() {
        self.subViewControllers.append(LSViewClockInItemController())
        self.subViewControllers.append(LSClockListViewController())
        
        self.segmentedView = {
            let segmentedView = JXSegmentedView()
            segmentedView.delegate = self
            segmentedView.backgroundColor = Color(hexString: "#FFFFFF")
            segmentedView.contentEdgeInsetLeft = 0
            segmentedView.contentEdgeInsetRight = 0
            segmentedView.cornerRadius = 5
            segmentedView.clipsToBounds = true
            self.view.addSubview(segmentedView)
            segmentedView.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(UI.STATUS_NAV_BAR_HEIGHT + 8)
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-15)
                make.height.equalTo(43)
            }
            
            segmentedDataSource = JXSegmentedTitleDataSource()
            segmentedDataSource.titles = ["员工打卡", "打卡记录"]
            segmentedDataSource.titleNormalFont = Font.pingFangRegular(14)
            segmentedDataSource.titleSelectedFont = Font.pingFangRegular(14)
            segmentedDataSource.titleNormalColor = Color(hexString: "#333333")!
            segmentedDataSource.titleSelectedColor = Color(hexString: "#FFFFFF")!
            segmentedDataSource.itemSpacing = 0
            segmentedDataSource.itemWidth = (UI.SCREEN_WIDTH - 30)/2
            
            segmentedView.dataSource = segmentedDataSource
            
            //配置指示器
            let indicator = JXSegmentedIndicatorImageView()
            indicator.image = UIImage(color: Color(hexString: "#2BC7AF")!, size: CGSize(width: (UI.SCREEN_WIDTH - 30)/2, height: 43))
            indicator.indicatorWidth = (UI.SCREEN_WIDTH - 30)/2
            indicator.indicatorHeight = 43
            segmentedView.indicators = [indicator]
            
            listContainerView = JXSegmentedListContainerView.init(dataSource: self)
            listContainerView.scrollView.isScrollEnabled = false
            segmentedView.listContainer = listContainerView
            self.view.addSubview(listContainerView)
            listContainerView.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalTo(segmentedView.snp.bottom)
                make.bottom.equalToSuperview()
            }
            segmentedView.reloadData()
            segmentedView.selectItemAt(index: 0)
            return segmentedView
        }() 
    }
}


extension LSClockinViewController: JXSegmentedViewDelegate, JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        return 2
    }
    
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        return self.subViewControllers[index]
    }
    
}

