//
//  LSHomeViewController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/2.
//

import Foundation
import UIKit
import SwifterSwift
import LSBaseModules
import RxDataSources
import RxSwift

class LSHomeViewController: LSBaseViewController {

    @IBOutlet weak var headerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var nameNoLab: UILabel!
    @IBOutlet weak var clockNumLab: UILabel!
    @IBOutlet weak var royaltyLab: UILabel!
    @IBOutlet weak var rankLab: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var marqueeView: UUMarqueeView!
    
    var items = PublishSubject<[SectionModel<String, LSOrderServerModel>]>()
    var models = [LSOrderServerModel]()
    var messageModels = ["【加钟通知】:1002房间加钟60分钟，服务项目为……", "【加钟通知】:1002房间加钟60分钟，服务项目为……"]
    
    var refreshControl: KyoRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.vhl_navBarBackgroundAlpha = 0
        self.vhl_navBarTitleColor = Color(hexString: "#FFFFFF")!
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.vhl_navBarBackgroundAlpha = 1
        self.vhl_navBarTitleColor = Color(hexString: "#000000")!
    }
    
    override func setupViews() {
        self.navigationItem.title = storeModel().name
        self.backImageView.image = UIImage.createGradientImage(startColor: Color(hexString: "#00AAB7")!, endColor: Color(hexString: "#00C294")!, width: UI.SCREEN_WIDTH, height: 208 + UI.STATUS_NAV_BAR_HEIGHT, isTopToBottom: false)
        self.headerViewHeight.constant = 208 + UI.STATUS_NAV_BAR_HEIGHT
        self.nameNoLab.text = "\(userModel().name)(\(userModel().code))"
        
        do {
            tableView.tableFooterView = UIView()
            tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: UI.SCREEN_WIDTH, height: 0.01))
            tableView.isScrollEnabled = false
            tableView.rowHeight = 73
//            tableView.separatorInset =
            if #available(iOS 15.0, *) {
                tableView.sectionHeaderTopPadding = 0
            }
            tableView.register(nibWithCellClass: LSJSTableViewCell.self)
            
            let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, LSOrderServerModel>> { dataSource, tableView, indexPath, element in
                let cell: LSJSTableViewCell = tableView.dequeueReusableCell(withClass: LSJSTableViewCell.self)
                
                return cell
            }
            items.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: self.rx.disposeBag)
            
            tableView.rx.itemSelected.subscribe { [weak self] indexPath in
                guard let self = self else {return}
            }.disposed(by: self.rx.disposeBag)
        }
        
        do {
            
//            self.leftwardMarqueeView = [[UUMarqueeView alloc] initWithFrame:CGRectMake(20.0f, 475.0f, screenWidth - 40.0f, 20.0f) direction:UUMarqueeViewDirectionLeftward];
//            _leftwardMarqueeView.delegate = self;
//            _leftwardMarqueeView.timeIntervalPerScroll = 0.0f;
//            _leftwardMarqueeView.scrollSpeed = 60.0f;
//            _leftwardMarqueeView.itemSpacing = 20.0f;
//            [self.view addSubview:_leftwardMarqueeView];
//            [_leftwardMarqueeView reloadData];
            marqueeView.direction = .upward
            marqueeView.delegate = self
            marqueeView.timeDurationPerScroll = 0
            marqueeView.scrollSpeed = 60
            marqueeView.itemSpacing = 20
            marqueeView.reloadData()
        }
        
        
        self.refreshControl = {
            let refreshControl = KyoRefreshControl(scrollView: self.tableView, with: self)
            refreshControl?.kyoRefreshOperation(withDelay: 0, with: KyoManualRefreshType.center)
            return refreshControl
        }()
        
    }
    
    override func setupNavigation() {
        let rightBarBtn = UIBarButtonItem(image: UIImage(named: "消息通知")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(jumpMessage))
        self.navigationItem.rightBarButtonItem = rightBarBtn
    }
    
    @objc func jumpMessage() {
        self.navigationController?.pushViewController(LSMessageViewController(), animated: true)
    }
    
    func netwrokData(page: Int) {
        var networkError: Error? = nil
//        LSWorkbenchServer.getSaleUserProjectMe(page: page, startdate: self.startdate, enddate: self.enddate, status: self.orderServerStatus).subscribe(onSuccess: { listModels in
//            guard let listModels = listModels else{return}
//            if page == 1 { self.models.removeAll() }
//            self.refreshControl.numberOfPage = listModels.pages
//            self.models.append(contentsOf: listModels.list)
//            self.refreshUI()
//        }, onFailure: { error in
//            networkError = error
//        }, onDisposed: {
//            let hadData: Bool = !self.models.isEmpty
//            self.refreshControl.kyoRefreshDoneRefreshOrLoadMore(page == 1 ? true : false,
//                                                          withHadData: hadData,
//                                                          withError: networkError)
//        }).disposed(by: self.rx.disposeBag)
        let hadData: Bool = !self.models.isEmpty
        self.refreshControl.kyoRefreshDoneRefreshOrLoadMore(page == 1 ? true : false,
                                                      withHadData: hadData,
                                                      withError: networkError)
    }
    
    func refreshUI() {
        let sectionModels = self.models.map{SectionModel.init(model: "", items: [$0])}
        self.items.onNext(sectionModels)
    }
}

extension LSHomeViewController: UUMarqueeViewDelegate{
    func numberOfData(for marqueeView: UUMarqueeView!) -> UInt {
        return UInt(self.messageModels.count)
    }
    
    func createItemView(_ itemView: UIView!, for marqueeView: UUMarqueeView!) {

//        itemView.backgroundColor = [UIColor colorWithRed:228.0f/255.0f green:228.0f/255.0f blue:228.0f/255.0f alpha:1.0f];
        let content = UILabel(frame: itemView.bounds)
        content.font = Font.pingFangRegular(13)
        content.textColor = Color.black
        content.tag = 1001
        itemView.addSubview(content)
    }
    
    func updateItemView(_ itemView: UIView!, at index: UInt, for marqueeView: UUMarqueeView!) {
        let content = itemView.viewWithTag(1001) as? UILabel
        content?.text = self.messageModels[Int(index)];
    }
}

extension LSHomeViewController: KyoRefreshControlDelegate{
    func kyoRefreshDidTriggerRefresh(_ refreshControl: KyoRefreshControl!) {
        netwrokData(page: 1)
    }
    
    func kyoRefreshLoadMore(_ refreshControl: KyoRefreshControl!, loadPage index: Int) {
        netwrokData(page: index + 1)
    }
    func kyoRefresh(_ refreshControl: KyoRefreshControl!, withNoDataShow kyoDataTipsView: KyoDataTipsView!, withCurrentKyoDataTipsModel kyoDataTipsModel: KyoDataTipsModel!, with kyoDataTipsViewType: KyoDataTipsViewType) -> KyoDataTipsModel! {
        kyoDataTipsModel.img = UIImage(named: "组 5794")
        kyoDataTipsModel.tip = NSAttributedString(string: "您暂无派工信息，请耐心等待…", attributes: [.foregroundColor: UIColor(hexString: "#999999")!, .font: Font.pingFangRegular(14)])
        return kyoDataTipsModel
    }
}

