//
//  LSOrderItemViewController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/22.
//

import UIKit
import JXSegmentedView
import RxDataSources
import SwifterSwift
import RxSwift
import LSNetwork

enum OrderType {
    case forMe
    case fromMe
}
class LSOrderItemViewController: LSBaseViewController {
    var tableView: UITableView!
    var refreshControl: KyoRefreshControl!
    
    var orderType: OrderType!
    
    var items = PublishSubject<[SectionModel<String, LSOrderModel>]>()
    var models = [LSOrderModel]()
    
    convenience init(orderType: OrderType) {
        self.init()
        self.orderType = orderType
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupViews() {
        self.tableView = {
            var tableView = UITableView(frame: CGRect.zero, style: .grouped)
            if #available(iOS 13.0, *) {
                tableView = UITableView(frame: CGRect.zero, style: .insetGrouped)
            }
            tableView.backgroundColor = Color.clear
            tableView.tableFooterView = UIView()
            tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: UI.SCREEN_WIDTH, height: 0.01))
            tableView.sectionHeaderHeight = 7
            tableView.sectionFooterHeight = 0
            tableView.rowHeight = 124
            if #available(iOS 15.0, *) {
                tableView.sectionHeaderTopPadding = 0
            }
            tableView.register(nibWithCellClass: LSCreateOrderTableViewCell.self)
            view.addSubview(tableView)
            tableView.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
            }
            
            let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, LSOrderModel>> { dataSource, tableView, indexPath, element in
                let cell: LSCreateOrderTableViewCell = tableView.dequeueReusableCell(withClass: LSCreateOrderTableViewCell.self)
                cell.titleLab.text = "\(element.roomname)房--\(element.projectname)/\(element.ctypename)"
                cell.statusLab.text = element.statusname
              
                cell.statusView.backgroundColor = element.status.backColor
                cell.nameLab.text = "客户姓名：" + element.name
                cell.arriveTimeLab.text = "抵达时间：" + element.tostoretime
                cell.createTimeLab.text = "创建时间：" + element.createname
                cell.refnameLab.text = "推荐人：" + element.refname
                return cell
            }
            items.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: self.rx.disposeBag)
            tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
                guard let self = self else {return}
                self.navigationController?.pushViewController(LSOrderDetailsViewController(orderModel: self.models[indexPath.section]), animated: true)
            }).disposed(by: self.rx.disposeBag)
            return tableView
        }()
        
        self.refreshControl = {
            let refreshControl = KyoRefreshControl(scrollView: self.tableView, with: self)
            refreshControl?.kyoRefreshOperation(withDelay: 0, with: KyoManualRefreshType.center)
            return refreshControl
        }()
    }
    
    func netwrokData(page: Int) {
        var networkError: Error? = nil
        var networkSingle:  Single<LSNetworkListModel<LSOrderModel>?>!
        if self.orderType == .forMe {
            networkSingle = LSWorkbenchServer.findAboutMe()
        }else {
            networkSingle = LSWorkbenchServer.findAboutCreateMe()
        }
        networkSingle.subscribe(onSuccess: { listModels in
            guard let listModels = listModels else{return}
            if page == 1 { self.models.removeAll() }
            self.refreshControl.numberOfPage = listModels.pages
            self.models.append(contentsOf: listModels.list)
            self.refreshUI()
        }, onFailure: { error in
            networkError = error
        }, onDisposed: {
            let hadData: Bool = !self.models.isEmpty
            self.refreshControl.kyoRefreshDoneRefreshOrLoadMore(page == 1 ? true : false,
                                                          withHadData: hadData,
                                                          withError: networkError)
        }).disposed(by: self.rx.disposeBag)
    }
    
    func refreshUI() {
        let sectionModels = self.models.map{SectionModel.init(model: "", items: [$0])}
        self.items.onNext(sectionModels)
    }
}


extension LSOrderItemViewController: KyoRefreshControlDelegate{
    func kyoRefreshDidTriggerRefresh(_ refreshControl: KyoRefreshControl!) {
        netwrokData(page: 1)
    }
    
    func kyoRefreshLoadMore(_ refreshControl: KyoRefreshControl!, loadPage index: Int) {
        netwrokData(page: index + 1)
    }
    func kyoRefresh(_ refreshControl: KyoRefreshControl!, withNoDataShow kyoDataTipsView: KyoDataTipsView!, withCurrentKyoDataTipsModel kyoDataTipsModel: KyoDataTipsModel!, with kyoDataTipsViewType: KyoDataTipsViewType) -> KyoDataTipsModel! {
        kyoDataTipsModel.img = UIImage(named: "无信息")
        kyoDataTipsModel.tip = NSAttributedString(string: "暂无预约数据", attributes: [.foregroundColor: UIColor(hexString: "#999999")!, .font: Font.pingFangRegular(14)])
        return kyoDataTipsModel
    }
}


extension LSOrderItemViewController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return self.view
    }
}
