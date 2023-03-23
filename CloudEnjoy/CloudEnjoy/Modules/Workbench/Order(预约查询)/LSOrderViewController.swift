//
//  LSOrderViewController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/3.
//

import UIKit
import JXSegmentedView
import LSBaseModules
import SwifterSwift

class LSOrderViewController: LSBaseViewController {
    var segmentedView: JXSegmentedView!
    var segmentedDataSource: JXSegmentedTitleDataSource!
    var listContainerView: JXSegmentedListContainerView!
    var subViewControllers: [JXSegmentedListContainerViewListDelegate] = []
    
    var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "预约记录"
    }
    
    override func setupViews() {
        self.subViewControllers.append(LSOrderItemViewController(orderType: .forMe))
        self.subViewControllers.append(LSOrderItemViewController(orderType: .fromMe))
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
            segmentedDataSource.titles = ["预约我的", "我创建的"]
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
            segmentedView.listContainer = listContainerView
            self.view.addSubview(listContainerView)
            listContainerView.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalTo(segmentedView.snp.bottom)
                make.bottom.equalToSuperview().offset(-63 - UI.BOTTOM_HEIGHT)
            }
            
            segmentedView.reloadData()
            segmentedView.selectItemAt(index: 0)
            return segmentedView
        }()
                                      
        self.addButton = {
            let addButton = UIButton(type: .custom)
            addButton.setTitle("新增预约", for: .normal)
            addButton.backgroundColor = Color(hexString: "#2BB8C2")
            addButton.titleLabel?.font = Font.pingFangRegular(14)
            addButton.setTitleColor(Color(hexString: "#FFFFFF"), for: .normal)
            addButton.cornerRadius = 5
            addButton.rx.tap.subscribe {[weak self] _ in
                self?.navigationController?.pushViewController(LSAddOrderViewController(), animated: true)
            }.disposed(by: self.rx.disposeBag)
            self.view.addSubview(addButton)
            addButton.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(10)
                make.right.equalToSuperview().offset(-15)
                make.bottom.equalToSuperview().offset(-10 - UI.BOTTOM_HEIGHT)
                make.height.equalTo(43)
            }
            return addButton
        }()
    }
}


extension LSOrderViewController:  JXSegmentedViewDelegate, JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        return 2
    }

    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        return self.subViewControllers[index]
    }

}

