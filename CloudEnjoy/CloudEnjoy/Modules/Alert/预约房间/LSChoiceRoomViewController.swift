//
//  LSChoiceRoomViewController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/16.
//

import UIKit
import JXSegmentedView
import SwifterSwift

class LSChoiceRoomViewController: LSBaseViewController {
    var segmentedView: JXSegmentedView!
    var segmentedDataSource: JXSegmentedTitleDataSource!
    var listContainerView: JXSegmentedListContainerView!
    var subViewControllers = [LSWorkorderItemViewController]()

    class func creaeFromStoryboard() -> Self {
        let sb = UIStoryboard.init(name: "AlertStoryboard", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "LSChoiceRoomViewController") as! Self
        return vc
    }
    
    func presentedWith(_ presentingViewController: LSBaseViewController) {
        let transitionAnimationDelegate = TransitionAnimationDelegate()
        transitionAnimationDelegate.overlayTransitioningType = .blackBackground
        transitionAnimationDelegate.touchInBackgroundType = .doNothing
        transitionAnimationDelegate.viewAnimationType = .transformFromBottom
        transitionAnimationDelegate.enableInteractive = true
        self.transitioningDelegate = transitionAnimationDelegate
        self.modalPresentationStyle = .custom
        presentingViewController.present(self, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
//    override func setupViews() {
//        self.view.backgroundColor = UIColor.white;
//        self.view.frame = CGRectMake(0, 0, UI.SCREEN_WIDTH, 516+UI.BOTTOM_HEIGHT);
//
//        self.segmentedView = {
//            let segmentedView = JXSegmentedView()
//            segmentedView.delegate = self
//            segmentedView.backgroundColor = Color(hexString: "#FFFFFF")
//            self.view.addSubview(segmentedView)
//            segmentedView.snp.makeConstraints { make in
//                make.top.equalToSuperview().offset(2 + UI.STATUS_NAV_BAR_HEIGHT)
//                make.left.right.equalToSuperview()
//                make.height.equalTo(45)
//            }
//
//            segmentedDataSource = JXSegmentedTitleDataSource()
//            segmentedDataSource.titles = ["选择房间", "选择项目", "选择技师"]
//            segmentedDataSource.titleNormalFont = Font.pingFangRegular(14)
//            segmentedDataSource.titleSelectedFont = Font.pingFangRegular(14)
//            segmentedDataSource.titleNormalColor = Color(hexString: "#363636")!
//            segmentedDataSource.titleSelectedColor = Color(hexString: "#2BB8C2")!
//            segmentedView.dataSource = segmentedDataSource
//
//            let indicator = JXSegmentedIndicatorLineView()
//            indicator.indicatorWidth = 38
//            indicator.indicatorHeight = 2
//            indicator.indicatorColor = Color(hexString: "#2BB8C2")!
//            indicator.verticalOffset = 5
//            segmentedView.indicators = [indicator]
//
//
//            listContainerView = JXSegmentedListContainerView.init(dataSource: self)
//            segmentedView.listContainer = listContainerView
//            self.view.addSubview(listContainerView)
//            listContainerView.snp.makeConstraints { make in
//                make.left.right.equalToSuperview()
//                make.top.equalTo(segmentedView.snp.bottom)
//                make.bottom.equalToSuperview()
//            }
//            segmentedView.reloadData()
//
//            return segmentedView
//        }()
//    }

}

//extension LSChoiceRoomViewController: JXSegmentedViewDelegate, JXSegmentedListContainerViewDataSource {
//    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
//        return 3
//    }
//
//    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
//        var subViewController =  self.subViewControllers[safe: index]
//        if subViewController == nil {
//            subViewController = LSWorkorderItemViewController(timeSection: index)
//            subViewController!.orderServerStatus = self.orderServerStatus
//            self.subViewControllers.append(subViewController!)
//        }
//        return subViewController!
//    }
//
//}
