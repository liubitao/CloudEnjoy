//
//  LSMessageViewController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/3.
//

import UIKit
import SwifterSwift
import JXSegmentedView

class LSMessageViewController: LSBaseViewController {

    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var allSelectBtn: UIButton!
    @IBOutlet weak var hadReadBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    
    
    var segmentedView: JXSegmentedView!
    var segmentedDataSource: JXSegmentedTitleDataSource!
    var listContainerView: JXSegmentedListContainerView!
    
    var subViewControllers = [LSMessageItemViewController]()
    
    var isEdit = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "消息中心"
    }
    
    override func setupNavigation() {
        let rightBarBtn = UIBarButtonItem(title: "管理", style: .plain, target: self, action: #selector(editMessage))
        rightBarBtn.setTitleTextAttributes([.foregroundColor: Color(hexString: "#333333")!], for: .normal)
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
            segmentedDataSource.titles = ["全部", "预约", "等待", "上下钟", "其他"]
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
    
    override func setupNotifications() {
        NotificationCenter.default.rx.notification(Notification.Name("cancelMessageEdit")).subscribe{[weak self] _ in self?.editMessage()}.disposed(by: self.rx.disposeBag)
    }
    
    @objc func editMessage() {
        self.isEdit = !self.isEdit
        self.subViewControllers.forEach{$0.isEdit = self.isEdit}
        
        self.allSelectBtn.isSelected = false
        self.bottomView.isHidden = !self.isEdit
        self.listContainerView.snp.updateConstraints { make in
            make.bottom.equalTo(self.isEdit ? (-49 - UI.BOTTOM_HEIGHT) : 0)
        }
        
        let rightBarBtn = UIBarButtonItem(title: self.isEdit ? "取消" : "管理", style: .plain, target: self, action: #selector(editMessage))
        rightBarBtn.setTitleTextAttributes([.foregroundColor: Color(hexString: "#333333")!], for: .normal)
        self.navigationItem.rightBarButtonItem = rightBarBtn
    }
    
    override func setupData() {
        for type in LSMsgType.allCases {
            self.subViewControllers.append(LSMessageItemViewController.init(type))
        }
        self.segmentedView.reloadData()
    }
    
    
    @IBAction func selectedAllAction(_ sender: Any) {
        self.allSelectBtn.isSelected = !self.allSelectBtn.isSelected
        let currentVC = self.subViewControllers[segmentedView.selectedIndex]
        currentVC.selectAllMessage(self.allSelectBtn.isSelected)
    }
    
    @IBAction func readAction(_ sender: Any) {
        let currentVC = self.subViewControllers[segmentedView.selectedIndex]
        currentVC.readMessage()
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        let currentVC = self.subViewControllers[segmentedView.selectedIndex]
        currentVC.deletMessage()
    }
}

extension LSMessageViewController: JXSegmentedViewDelegate, JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        return 5
    }
    
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        return self.subViewControllers[index]
    }
}
