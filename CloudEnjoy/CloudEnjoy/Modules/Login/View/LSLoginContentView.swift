//
//  LSLoginContentView.swift
//  
//
//  Created by liubitao on 2023/3/4.
//

import UIKit
import JXSegmentedView
import SwifterSwift

typealias LoginClosure = (_ store: String?, _ account: String?, _ phone: String?, _ password: String) -> Void


class LSLoginContentView: UIView {
    
    var segmentedView: JXSegmentedView!
    var segmentedDataSource: JXSegmentedTitleDataSource!
    var listContainerView: JXSegmentedListContainerView!
     
    var subContains: [LSLoginView] = [LSLoginView(frame: CGRect(x: 0, y: 0, width: UI.SCREEN_WIDTH - 19*2, height: 373 - 55)), LSLoginView(frame: CGRect(x: UI.SCREEN_WIDTH - 19*2, y: 0, width: UI.SCREEN_WIDTH - 19*2, height: 373 - 55))]
    
    var loginClosure: LoginClosure!
    
    init(frame: CGRect, loginClosure: @escaping LoginClosure) {
        super.init(frame: frame)
        self.loginClosure = loginClosure
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.subContains.enumerated().forEach { (index, view) in
            var loginView: UIView?
            if index == 0 {
                loginView = LSAccountLoginView.createFromXib()
                (loginView as! LSAccountLoginView).loginClosure = loginClosure
            }else {
                loginView = LSPhoneLoginView.createFromXib()
                (loginView as! LSPhoneLoginView).loginClosure = loginClosure
            }
            view.addSubview(loginView!)
            loginView!.snp.makeConstraints { make in
                make.left.top.equalToSuperview()
                make.width.equalTo(UI.SCREEN_WIDTH - 19*2)
                make.height.equalTo(373 - 55)
            }
        }
        self.segmentedView = {
            let segmentedView = JXSegmentedView()
            segmentedView.delegate = self
            segmentedView.contentEdgeInsetLeft = 24
            self.addSubview(segmentedView)
            segmentedView.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(10)
                make.left.right.equalToSuperview()
                make.height.equalTo(50)
            }
            
            segmentedDataSource = JXSegmentedTitleDataSource()
            segmentedDataSource.titles = ["员工号登录", "手机号登录"]
            segmentedDataSource.titleNormalFont = Font.pingFangRegular(14)
            segmentedDataSource.titleSelectedFont = Font.pingFangRegular(18)
            segmentedDataSource.titleNormalColor = Color(hexString: "#707070")!
            segmentedDataSource.titleSelectedColor = Color(hexString: "#00AAB7")!
            segmentedDataSource.itemSpacing = 45
            segmentedDataSource.isItemSpacingAverageEnabled = false
            segmentedView.dataSource = segmentedDataSource
            
            let indicator = JXSegmentedIndicatorLineView()
            indicator.indicatorWidth = 38
            indicator.indicatorHeight = 4
            indicator.indicatorColor = Color(hexString: "#00AAB7")!
            indicator.verticalOffset = 5
            segmentedView.indicators = [indicator]
            
            
            listContainerView = JXSegmentedListContainerView.init(dataSource: self)
            segmentedView.listContainer = listContainerView
            self.addSubview(listContainerView)
            listContainerView.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalTo(segmentedView.snp.bottom).offset(5)
                make.bottom.equalToSuperview()
            }
            segmentedView.reloadData()
    
            return segmentedView
        }()
    }
}

extension LSLoginContentView: JXSegmentedViewDelegate, JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        return subContains.count
    }
    
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        return subContains[index]
    }
}

class LSLoginView: UIView, JXSegmentedListContainerViewListDelegate{
    func listView() -> UIView {
        return self
    }
}
