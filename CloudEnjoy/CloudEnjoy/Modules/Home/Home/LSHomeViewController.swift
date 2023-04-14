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
    
    @IBOutlet weak var infoView: UIView!
    var userStatusView: LSHomeUserStatusView!
    
    var homeModel: LSJSHomeModel?
    
    var items = PublishSubject<[SectionModel<String, LSHomeProjectModel>]>()
    var models = [LSHomeProjectModel]()
    var messageModels =  [LSMessageModel]()
    var userStatusModel: LSUserStatusModel?
    
    var refreshControl: KyoRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.vhl_navBarBackgroundAlpha = 0
        self.vhl_navBarTitleColor = Color(hexString: "#FFFFFF")!
        self.networkHomeData()
        self.marqueeView.start()
        self.netwrokData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.vhl_navBarBackgroundAlpha = 1
        self.vhl_navBarTitleColor = Color(hexString: "#000000")!
        self.marqueeView.pause()
    }
    
    override func setupViews() {
        self.navigationItem.title = storeModel().name
        self.backImageView.image = UIImage.createGradientImage(startColor: Color(hexString: "#00AAB7")!, endColor: Color(hexString: "#00C294")!, width: UI.SCREEN_WIDTH, height: 208 + UI.STATUS_NAV_BAR_HEIGHT, isTopToBottom: false)
        self.headerViewHeight.constant = 208 + UI.STATUS_NAV_BAR_HEIGHT
        self.nameNoLab.text = "\(userModel().name)(\(userModel().code))"
        
        
        self.infoView.rx.tapGesture().when(.recognized).subscribe { [weak self] _ in
            self?.navigationController?.pushViewController(LSUserInfoViewController(), animated: true)
        }.disposed(by: self.rx.disposeBag)
        
        self.clockNumLab.rx.tapGesture().when(.recognized).subscribe { [weak self] _ in
            self?.navigationController?.pushViewController(LSClocksViewController(), animated: true)
        }.disposed(by: self.rx.disposeBag)
        
        self.royaltyLab.rx.tapGesture().when(.recognized).subscribe { [weak self] _ in
            self?.navigationController?.pushViewController(LSRoyaltiesViewController(), animated: true)
        }.disposed(by: self.rx.disposeBag)
        
        self.rankLab.rx.tapGesture().when(.recognized).subscribe { [weak self] _ in
            self?.navigationController?.pushViewController(LSRankViewController(), animated: true)
        }.disposed(by: self.rx.disposeBag)
        
        do {
            tableView.tableFooterView = UIView()
            tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: UI.SCREEN_WIDTH, height: 0.01))
            tableView.rowHeight = 73
            if #available(iOS 15.0, *) {
                tableView.sectionHeaderTopPadding = 0
            }
            tableView.register(nibWithCellClass: LSHomeProjectCell.self)
            
            let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, LSHomeProjectModel>> { dataSource, tableView, indexPath, element in
                let cell: LSHomeProjectCell = tableView.dequeueReusableCell(withClass: LSHomeProjectCell.self)
                switch element.status {
                case .wait:
                    cell.timeLab.text = element.dispatchtime.split(separator: " ").last?.split(separator: ":")[0..<2].joined(separator: ":")
                case .subscribe:
                    cell.timeLab.text = element.tostoretime
                case .servicing:
                    cell.timeLab.text = element.starttime
                default:
                    cell.timeLab.text = element.createtime
                }
                cell.statusView.backgroundColor = element.status.backColor
                cell.statusLab.text = element.status.statusString
                cell.roomNameLab.text = "房间：" + element.roomname
                cell.projectNameLab.text = element.projectname
                cell.durationLab.text = element.min + "分钟"
                cell.typeLab.text = element.ctype.clockString
                return cell
            }
            items.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: self.rx.disposeBag)
            
            tableView.rx.modelSelected(LSHomeProjectModel.self).subscribe(onNext: {[weak self] model in
                guard let self = self else {return}
                if model.status == .subscribe {
                    let orderModel = LSOrderModel(with: model)
                    self.navigationController?.pushViewController(LSOrderDetailsViewController.init(orderModel: orderModel), animated: true)
                }else {
                    self.navigationController?.pushViewController(LSProjectDetailsViewController.init(model), animated: true)
                }
            }).disposed(by: self.rx.disposeBag)
        }
        
        self.userStatusView = {
            let userStatusView = LSHomeUserStatusView.createFromXib()
            self.statusView.addSubview(userStatusView)
            userStatusView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            return userStatusView
        }()
       
        do {
            marqueeView.direction = .upward
            marqueeView.delegate = self
            marqueeView.timeIntervalPerScroll = 2
            marqueeView.timeDurationPerScroll = 1
            marqueeView.isTouchEnabled = true
            marqueeView.itemSpacing = 0
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
    
    func networkHomeData() {
        LSHomeServer.findJsHomeData().subscribe { homeModel in
            guard let homeModel = homeModel else {
                return
            }
            self.homeModel = homeModel
            self.clockNumLab.text = homeModel.sumqty.isEmpty ? "0" : homeModel.sumqty
            self.rankLab.text = homeModel.ph.isEmpty ? "0" : homeModel.ph
            self.royaltyLab.text = "￥" + (homeModel.commissionsum.isEmpty ? "0" : homeModel.commissionsum)
        } onFailure: { error in
            Toast.show(error.localizedDescription)
        } onDisposed: {
            Toast.hiddenHUD()
        }.disposed(by: self.rx.disposeBag)
        
        LSMessageServer.getMessageList(ispage: "1", see: "0", msgtype: LSMsgType.all.rawValue, page: "1").subscribe { listModel in
            self.messageModels = listModel?.list ?? []
            self.marqueeView.reloadData()
        } onFailure: { error in
            Toast.show(error.localizedDescription)
        } onDisposed: {
            Toast.hiddenHUD()
        }.disposed(by: self.rx.disposeBag)
        
//        LSMessageServer.getSeeCount().subscribe { resultModel in
//
//        } onFailure: { error in
//            Toast.show(error.localizedDescription)
//        } onDisposed: {
//            Toast.hiddenHUD()
//        }.disposed(by: self.rx.disposeBag)
        
        LSHomeServer.getUserStatus().subscribe { userStatusModel in
            self.userStatusModel = userStatusModel
            self.userStatusView.refreshUI(self.userStatusModel)
        } onFailure: { error in
            Toast.show(error.localizedDescription)
        } onDisposed: {
            Toast.hiddenHUD()
        }.disposed(by: self.rx.disposeBag)
    }
    
    func netwrokData() {
        var networkError: Error? = nil
        LSHomeServer.getSaleProject().subscribe(onSuccess: { models in
            self.refreshControl.numberOfPage = 1
            self.models = models ?? []
            self.refreshUI()
        }, onFailure: { error in
            networkError = error
        }, onDisposed: {
            let hadData: Bool = !self.models.isEmpty
            self.refreshControl.kyoRefreshDoneRefreshOrLoadMore(true,
                                                          withHadData: hadData,
                                                          withError: networkError)
        }).disposed(by: self.rx.disposeBag)
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
        let leftImageView = UIImageView(frame: CGRect(x: 18, y: 12, width: 17, height: 17))
        leftImageView.image = UIImage(named: "消息")
        itemView.addSubview(leftImageView)
        
        let rightImageView = UIImageView(frame: CGRect(x: UI.SCREEN_WIDTH - 15 - 4, y: 17, width: 4, height: 8))
        rightImageView.image = UIImage(named: "箭头")
        itemView.addSubview(rightImageView)

        let content = UILabel(frame: CGRect(x: 35, y: 0, width: UI.SCREEN_WIDTH - 35 - 35, height: 41))
        content.font = Font.pingFangRegular(13)
        content.textColor = Color.black
        content.tag = 1001
        itemView.addSubview(content)
    }
    
    func updateItemView(_ itemView: UIView!, at index: UInt, for marqueeView: UUMarqueeView!) {
        let content = itemView.viewWithTag(1001) as? UILabel
        content?.text = self.messageModels[Int(index)].title + " " + self.messageModels[Int(index)].content;
    }
    
    func itemViewHeight(at index: UInt, for marqueeView: UUMarqueeView!) -> CGFloat {
        return 41
    }
    
    func numberOfVisibleItems(for marqueeView: UUMarqueeView!) -> UInt {
        return 1
    }
    
    func didTouchItemView(at index: UInt, for marqueeView: UUMarqueeView!) {
        self.navigationController?.pushViewController(LSMessageViewController(), animated: true)
    }
}

extension LSHomeViewController: KyoRefreshControlDelegate{
    func kyoRefreshDidTriggerRefresh(_ refreshControl: KyoRefreshControl!) {
        netwrokData()
    }
    
    func kyoRefresh(_ refreshControl: KyoRefreshControl!, withNoDataShow kyoDataTipsView: KyoDataTipsView!, withCurrentKyoDataTipsModel kyoDataTipsModel: KyoDataTipsModel!, with kyoDataTipsViewType: KyoDataTipsViewType) -> KyoDataTipsModel! {
        kyoDataTipsModel.img = UIImage(named: "组 5794")
        kyoDataTipsModel.tip = NSAttributedString(string: "您暂无派工信息，请耐心等待…", attributes: [.foregroundColor: UIColor(hexString: "#999999")!, .font: Font.pingFangRegular(14)])
        return kyoDataTipsModel
    }
}

