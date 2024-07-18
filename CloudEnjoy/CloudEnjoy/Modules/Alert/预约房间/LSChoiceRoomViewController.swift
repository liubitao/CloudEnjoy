//
//  LSChoiceRoomViewController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/16.
//

import UIKit
import JXSegmentedView
import SwifterSwift
import SnapKit
import LSBaseModules

class LSChoiceRoomViewController: LSBaseViewController {
    var segmentedView: JXSegmentedView!
    var segmentedDataSource: JXSegmentedTitleDataSource!
    var listContainerView: JXSegmentedListContainerView!
    var subViewControllers: [JXSegmentedListContainerViewListDelegate] = []
    
    typealias SelectedClosure = (LSOrderRoomModel?, LSOrderProjectModel?, LSSysUserModel?, LSClockType?, LSJSLevelModel?, (String, String)?) -> Void
    var selectedClosure: SelectedClosure?
    
    var selectRoomModel: LSOrderRoomModel?
    var selectProjectModel: LSOrderProjectModel?
    var selectJSModel: LSSysUserModel?
    var selectedIndex = 0
    
    var clockSelectModel: LSClockType?
    var levelSelectModel: LSJSLevelModel?
    var sexSelectModel: (String, String)?
    
    class func creaeFromStoryboard(selectRoomModel: LSOrderRoomModel?, selectProjectModel: LSOrderProjectModel?, selectJSModel: LSSysUserModel?, selectedIndex: Int, clockSelectModel: LSClockType?, levelSelectModel: LSJSLevelModel?, sexSelectModel: (String, String)?) -> Self {
        let sb = UIStoryboard.init(name: "AlertStoryboard", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "LSChoiceRoomViewController") as! Self
        vc.selectRoomModel = selectRoomModel
        vc.selectProjectModel = selectProjectModel
        vc.selectJSModel = selectJSModel
        vc.selectedIndex = parametersModel().showRoom ? selectedIndex : selectedIndex - 1
        vc.clockSelectModel = clockSelectModel
        vc.levelSelectModel = levelSelectModel
        vc.sexSelectModel = sexSelectModel
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
    
    override func setupViews() {
        self.view.backgroundColor = UIColor.white;
        self.view.frame = CGRectMake(0, 0, UI.SCREEN_WIDTH, 516+UI.BOTTOM_HEIGHT);

        if parametersModel().showRoom {
            self.subViewControllers.append(LSChoiceRoomItemController(selectRoomModel: self.selectRoomModel))
        }
        self.subViewControllers.append(LSChioceProjectItemController(selectPojectModel: self.selectProjectModel))
        self.subViewControllers.append(LSChioceTechnicianItemController(selectedProjectModel: self.selectProjectModel, selectJSModel: self.selectJSModel, clockSelectModel: self.clockSelectModel, levelSelectModel: self.levelSelectModel, sexSelectModel: self.sexSelectModel))

        self.segmentedView = {
            let segmentedView = JXSegmentedView()
            segmentedView.delegate = self
            segmentedView.backgroundColor = Color(hexString: "#FFFFFF")
            segmentedView.contentEdgeInsetLeft = 0
            segmentedView.contentEdgeInsetRight = 0
            segmentedView.clipsToBounds = true
            self.view.addSubview(segmentedView)
            segmentedView.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(45)
                make.left.equalToSuperview().offset(10)
                make.right.equalToSuperview().offset(-10)
                make.height.equalTo(42)
            }
            
            segmentedDataSource = JXSegmentedTitleDataSource()
            if parametersModel().showRoom {
                segmentedDataSource.titles.append("选择房间")
            }
            let itemCount: CGFloat = parametersModel().showRoom ? 3 : 2

            segmentedDataSource.titles.append(contentsOf: ["选择项目", "选择技师"])
            segmentedDataSource.titleNormalFont = Font.pingFangRegular(14)
            segmentedDataSource.titleSelectedFont = Font.pingFangRegular(14)
            segmentedDataSource.titleNormalColor = Color(hexString: "#363636")!
            segmentedDataSource.titleSelectedColor = Color(hexString: "#2BB8C2")!
            segmentedDataSource.itemSpacing = 0
            segmentedDataSource.itemWidth = (UI.SCREEN_WIDTH - 20)/itemCount
            segmentedView.dataSource = segmentedDataSource

            //配置指示器
            let indicator = JXSegmentedIndicatorImageView()
            indicator.indicatorPosition = .top
            indicator.image = UIImage(color: Color.white, size: CGSize(width: (UI.SCREEN_WIDTH - 20)/itemCount, height: 45))
            indicator.indicatorWidth = (UI.SCREEN_WIDTH - 20)/itemCount
            indicator.indicatorHeight = 45
            indicator.borderWidth = 1
            indicator.borderColor = Color(hexString: "#E3E3E3")
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
            segmentedView.selectItemAt(index: self.selectedIndex)

            let lineView = UIView()
            lineView.backgroundColor = Color(hexString: "#E3E3E3")
            segmentedView.insertSubview(lineView, at: 0)
            lineView.snp.makeConstraints { make in
                make.bottom.left.right.equalToSuperview()
                make.height.equalTo(1)
            }

            return segmentedView
        }()
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        let choiceRoomVC = self.subViewControllers.first(where: {$0 is LSChoiceRoomItemController}) as? LSChoiceRoomItemController
        let choiceProjectVC = self.subViewControllers.first(where: {$0 is LSChioceProjectItemController}) as? LSChioceProjectItemController
        let choiceJSVC = self.subViewControllers.first(where: {$0 is LSChioceTechnicianItemController}) as? LSChioceTechnicianItemController
        self.selectedClosure?(choiceRoomVC?.selectRoomModel, choiceProjectVC?.selectPojectModel, choiceJSVC?.selectJSModel, choiceJSVC?.clockSelectModel, choiceJSVC?.levelSelectModel, choiceJSVC?.sexSelectModel)
        self.dismiss(animated: true)
    }

}

extension LSChoiceRoomViewController: JXSegmentedViewDelegate, JXSegmentedListContainerViewDataSource {
    func segmentedView(_ segmentedView: JXSegmentedView, canClickItemAt index: Int) -> Bool {
        guard index == self.subViewControllers.count - 1 else {
            return true
        }
        guard let choiceProjectVC = self.subViewControllers.first(where: {$0 is LSChioceProjectItemController}) as? LSChioceProjectItemController,
              let selectProjectModel = choiceProjectVC.selectPojectModel else {
            Toast.show("请先选择服务项目")
            return false
        }
        (self.subViewControllers.first(where: {$0 is LSChioceTechnicianItemController}) as? LSChioceTechnicianItemController)?.selectedProjectModel = selectProjectModel
        return true
    }
   
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        return self.subViewControllers.count
    }

    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        return self.subViewControllers[index]
    }

}
